import { ObjectId, WithId } from 'mongodb';
import { collections } from '../database/provider.js';
import {
  Task,
  TaskStatus,
  TaskPriority,
  TaskType,
  ExecutionPhase,
  TaskFilters,
  TaskInput,
  TaskOutput,
  TaskVerify,
} from '../models/interfaces/index.js';
import { NotFoundError, WIPLimitError, DependencyError, InvalidTransitionError } from '../utils/errors.js';
import { projectService } from './project.service.js';

export interface CreateTaskInput {
  title: string;
  description?: string;
  type?: TaskType;
  priority?: TaskPriority;
  executionPhase: ExecutionPhase;
  estimatedHours?: number;
  dependencies?: string[];
  input?: TaskInput;
  output?: TaskOutput;
  verify?: TaskVerify;
  labels?: string[];
  skillsRequired?: string[];
}

export interface UpdateTaskInput {
  title?: string;
  description?: string;
  type?: TaskType;
  priority?: TaskPriority;
  estimatedHours?: number;
  actualHours?: number;
  dependencies?: string[];
  verify?: TaskVerify;
  labels?: string[];
  result?: string;
}

export interface MoveTaskInput {
  status: TaskStatus;
  blockedReason?: string;
  result?: string;
}

// Valid status transitions
const VALID_TRANSITIONS: Record<TaskStatus, TaskStatus[]> = {
  backlog: ['in_progress', 'skipped'],
  in_progress: ['review', 'blocked', 'backlog'],
  review: ['done', 'in_progress', 'blocked'],
  blocked: ['in_progress', 'backlog'],
  done: ['in_progress'], // Allow reopening
  skipped: ['backlog'],
};

export class TaskService {
  async list(projectId: string, filters: TaskFilters): Promise<{ tasks: WithId<Task>[]; total: number }> {
    const {
      page = 1,
      limit = 100,
      sort = 'createdAt',
      order = 'asc',
      status,
      priority,
      executionPhase,
      assigneeId,
      labels,
      search,
    } = filters;

    const query: Record<string, unknown> = {
      projectId: new ObjectId(projectId),
    };

    if (status) {
      query.status = Array.isArray(status) ? { $in: status } : status;
    }
    if (priority) {
      query.priority = Array.isArray(priority) ? { $in: priority } : priority;
    }
    if (executionPhase) query.executionPhase = executionPhase;
    if (assigneeId) query.assigneeId = new ObjectId(assigneeId);
    if (labels && labels.length > 0) query.labels = { $all: labels };
    if (search) {
      query.$or = [
        { title: { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } },
        { taskId: { $regex: search, $options: 'i' } },
      ];
    }

    const skip = (page - 1) * limit;
    const sortDir = order === 'asc' ? 1 : -1;

    const [tasks, total] = await Promise.all([
      collections.tasks()
        .find(query)
        .sort({ [sort]: sortDir })
        .skip(skip)
        .limit(limit)
        .toArray() as Promise<WithId<Task>[]>,
      collections.tasks().countDocuments(query),
    ]);

    return { tasks, total };
  }

  async listByStatus(projectId: string): Promise<Record<TaskStatus, WithId<Task>[]>> {
    const tasks = await collections.tasks()
      .find({ projectId: new ObjectId(projectId) })
      .sort({ priority: -1, createdAt: 1 })
      .toArray() as WithId<Task>[];

    const grouped: Record<TaskStatus, WithId<Task>[]> = {
      backlog: [],
      in_progress: [],
      review: [],
      blocked: [],
      done: [],
      skipped: [],
    };

    for (const task of tasks) {
      grouped[task.status].push(task);
    }

    return grouped;
  }

  async getById(projectId: string, taskId: string): Promise<WithId<Task>> {
    const task = await collections.tasks().findOne({
      projectId: new ObjectId(projectId),
      taskId,
    }) as WithId<Task> | null;

    if (!task) {
      throw new NotFoundError('Task', taskId);
    }

    return task;
  }

  async create(projectId: string, input: CreateTaskInput): Promise<WithId<Task>> {
    // Generate task ID
    const count = await collections.tasks().countDocuments({
      projectId: new ObjectId(projectId),
    });
    const taskId = `TASK-${String(count + 1).padStart(3, '0')}`;

    const now = new Date();
    const task: Task = {
      projectId: new ObjectId(projectId),
      taskId,
      title: input.title,
      description: input.description || '',
      type: input.type || 'code',
      status: 'backlog',
      priority: input.priority || 'medium',
      executionPhase: input.executionPhase,
      estimatedHours: input.estimatedHours || 0,
      actualHours: 0,
      dependencies: input.dependencies || [],
      input: input.input,
      output: input.output,
      verify: input.verify,
      labels: input.labels || [],
      skillsRequired: input.skillsRequired,
      createdAt: now,
      updatedAt: now,
      history: [
        {
          action: 'created',
          timestamp: now,
          by: 'system',
        },
      ],
    };

    const result = await collections.tasks().insertOne(task);

    // Update project metrics
    await this.updateProjectMetrics(projectId);

    return { ...task, _id: result.insertedId };
  }

  async update(projectId: string, taskId: string, input: UpdateTaskInput): Promise<WithId<Task>> {
    const updateData: Record<string, unknown> = {
      updatedAt: new Date(),
    };

    if (input.title !== undefined) updateData.title = input.title;
    if (input.description !== undefined) updateData.description = input.description;
    if (input.type !== undefined) updateData.type = input.type;
    if (input.priority !== undefined) updateData.priority = input.priority;
    if (input.estimatedHours !== undefined) updateData.estimatedHours = input.estimatedHours;
    if (input.actualHours !== undefined) updateData.actualHours = input.actualHours;
    if (input.dependencies !== undefined) updateData.dependencies = input.dependencies;
    if (input.verify !== undefined) updateData.verify = input.verify;
    if (input.labels !== undefined) updateData.labels = input.labels;
    if (input.result !== undefined) updateData.result = input.result;

    const result = await collections.tasks().findOneAndUpdate(
      { projectId: new ObjectId(projectId), taskId },
      {
        $set: updateData,
        $push: {
          history: {
            action: 'updated',
            timestamp: new Date(),
            by: 'system',
            details: JSON.stringify(Object.keys(input)),
          },
        } as any,
      },
      { returnDocument: 'after' }
    );

    if (!result) {
      throw new NotFoundError('Task', taskId);
    }

    return result as WithId<Task>;
  }

  async move(projectId: string, taskId: string, input: MoveTaskInput): Promise<WithId<Task>> {
    const task = await this.getById(projectId, taskId);
    const project = await projectService.getById(projectId);

    // Validate transition
    const validNextStatuses = VALID_TRANSITIONS[task.status];
    if (!validNextStatuses.includes(input.status)) {
      throw new InvalidTransitionError(task.status, input.status);
    }

    // Check WIP limit when moving to in_progress
    if (input.status === 'in_progress') {
      const wipCount = await collections.tasks().countDocuments({
        projectId: new ObjectId(projectId),
        status: 'in_progress',
      });

      if (wipCount >= project.wipLimit) {
        throw new WIPLimitError(wipCount, project.wipLimit);
      }

      // Check dependencies
      if (task.dependencies.length > 0) {
        const completedDeps = await collections.tasks().countDocuments({
          projectId: new ObjectId(projectId),
          taskId: { $in: task.dependencies },
          status: 'done',
        });

        if (completedDeps < task.dependencies.length) {
          const incompleteDeps = task.dependencies.filter(async (depId) => {
            const dep = await collections.tasks().findOne({
              projectId: new ObjectId(projectId),
              taskId: depId,
              status: { $ne: 'done' },
            });
            return dep !== null;
          });
          throw new DependencyError(taskId, incompleteDeps);
        }
      }
    }

    const updateData: Record<string, unknown> = {
      status: input.status,
      updatedAt: new Date(),
    };

    // Handle specific transitions
    if (input.status === 'in_progress' && !task.startedAt) {
      updateData.startedAt = new Date();
    }

    if (input.status === 'done') {
      updateData.completedAt = new Date();
      if (input.result) {
        updateData.result = input.result;
      }
    }

    if (input.status === 'blocked') {
      updateData.blockedReason = input.blockedReason || 'No reason provided';
    } else {
      updateData.blockedReason = null;
    }

    const result = await collections.tasks().findOneAndUpdate(
      { projectId: new ObjectId(projectId), taskId },
      {
        $set: updateData,
        $push: {
          history: {
            action: `moved_to_${input.status}`,
            timestamp: new Date(),
            by: 'system',
            details: input.blockedReason || input.result,
          },
        } as any,
      },
      { returnDocument: 'after' }
    );

    // Update project metrics
    await this.updateProjectMetrics(projectId);

    return result as WithId<Task>;
  }

  async delete(projectId: string, taskId: string): Promise<void> {
    const result = await collections.tasks().deleteOne({
      projectId: new ObjectId(projectId),
      taskId,
    });

    if (result.deletedCount === 0) {
      throw new NotFoundError('Task', taskId);
    }

    await this.updateProjectMetrics(projectId);
  }

  async getDependencies(projectId: string, taskId: string): Promise<{
    task: WithId<Task>;
    blockedBy: WithId<Task>[];
    blocks: WithId<Task>[];
    canStart: boolean;
  }> {
    const task = await this.getById(projectId, taskId);

    const blockedBy = task.dependencies.length > 0
      ? await collections.tasks()
          .find({
            projectId: new ObjectId(projectId),
            taskId: { $in: task.dependencies },
          })
          .toArray() as WithId<Task>[]
      : [];

    const blocks = await collections.tasks()
      .find({
        projectId: new ObjectId(projectId),
        dependencies: taskId,
      })
      .toArray() as WithId<Task>[];

    const incompleteDeps = blockedBy.filter((t) => t.status !== 'done');
    const canStart = incompleteDeps.length === 0;

    return { task, blockedBy, blocks, canStart };
  }

  private async updateProjectMetrics(projectId: string): Promise<void> {
    const pipeline = [
      { $match: { projectId: new ObjectId(projectId) } },
      {
        $group: {
          _id: null,
          totalTasksCreated: { $sum: 1 },
          totalTasksCompleted: {
            $sum: { $cond: [{ $eq: ['$status', 'done'] }, 1, 0] },
          },
          currentWip: {
            $sum: { $cond: [{ $eq: ['$status', 'in_progress'] }, 1, 0] },
          },
          blockedCount: {
            $sum: { $cond: [{ $eq: ['$status', 'blocked'] }, 1, 0] },
          },
          totalEstimatedHours: { $sum: '$estimatedHours' },
          totalActualHours: { $sum: '$actualHours' },
        },
      },
    ];

    const [metrics] = await collections.tasks().aggregate(pipeline).toArray();

    if (metrics) {
      await projectService.updateMetrics(projectId, {
        totalTasksCreated: metrics.totalTasksCreated,
        totalTasksCompleted: metrics.totalTasksCompleted,
        currentWip: metrics.currentWip,
        blockedCount: metrics.blockedCount,
        totalEstimatedHours: metrics.totalEstimatedHours,
        totalActualHours: metrics.totalActualHours,
      });
    }
  }
}

export const taskService = new TaskService();
