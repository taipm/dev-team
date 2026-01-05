import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { taskService, CreateTaskInput, UpdateTaskInput, MoveTaskInput } from '../../services/task.service.js';
import { sendSuccess, sendPaginated } from '../../utils/response.js';
import { ValidationError } from '../../utils/errors.js';
import { TaskFilters } from '../../models/interfaces/index.js';

export const taskRoutes = Router({ mergeParams: true });

// Validation schemas
const createTaskSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().max(5000).default(''),
  type: z.enum(['analysis', 'design', 'code', 'test', 'documentation']).default('code'),
  priority: z.enum(['critical', 'high', 'medium', 'low']).default('medium'),
  executionPhase: z.enum(['FOUNDATION', 'BUILD', 'ENHANCE', 'FINALIZE']),
  estimatedHours: z.number().min(0).default(0),
  dependencies: z.array(z.string()).default([]),
  input: z.object({
    required: z.array(z.object({
      name: z.string(),
      format: z.string(),
      providedBy: z.string().optional(),
    })),
  }).optional(),
  output: z.object({
    deliverable: z.string(),
    format: z.string(),
    location: z.string(),
  }).optional(),
  verify: z.object({
    criteria: z.array(z.string()),
    method: z.string(),
    doneWhen: z.string(),
  }).optional(),
  labels: z.array(z.string()).default([]),
  skillsRequired: z.array(z.string()).optional(),
});

const updateTaskSchema = z.object({
  title: z.string().min(1).max(500).optional(),
  description: z.string().max(5000).optional(),
  type: z.enum(['analysis', 'design', 'code', 'test', 'documentation']).optional(),
  priority: z.enum(['critical', 'high', 'medium', 'low']).optional(),
  estimatedHours: z.number().min(0).optional(),
  actualHours: z.number().min(0).optional(),
  dependencies: z.array(z.string()).optional(),
  verify: z.object({
    criteria: z.array(z.string()),
    method: z.string(),
    doneWhen: z.string(),
  }).optional(),
  labels: z.array(z.string()).optional(),
  result: z.string().optional(),
});

const moveTaskSchema = z.object({
  status: z.enum(['backlog', 'in_progress', 'review', 'blocked', 'done', 'skipped']),
  blockedReason: z.string().optional(),
  result: z.string().optional(),
});

// List tasks (kanban view)
taskRoutes.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId } = req.params;
    const view = req.query.view as string;

    if (view === 'kanban') {
      const grouped = await taskService.listByStatus(projectId);
      sendSuccess(res, grouped);
      return;
    }

    const filters: TaskFilters = {
      page: parseInt(req.query.page as string) || 1,
      limit: Math.min(parseInt(req.query.limit as string) || 100, 500),
      sort: (req.query.sort as string) || 'createdAt',
      order: (req.query.order as 'asc' | 'desc') || 'asc',
      status: req.query.status as any,
      priority: req.query.priority as any,
      executionPhase: req.query.executionPhase as any,
      assigneeId: req.query.assigneeId as string,
      labels: req.query.labels ? (req.query.labels as string).split(',') : undefined,
      search: req.query.search as string,
    };

    const { tasks, total } = await taskService.list(projectId, filters);
    sendPaginated(res, tasks, filters.page!, filters.limit!, total);
  } catch (error) {
    next(error);
  }
});

// Get task by ID
taskRoutes.get('/:taskId', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, taskId } = req.params;
    const task = await taskService.getById(projectId, taskId);
    sendSuccess(res, task);
  } catch (error) {
    next(error);
  }
});

// Create task
taskRoutes.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId } = req.params;
    const parsed = createTaskSchema.safeParse(req.body);

    if (!parsed.success) {
      throw new ValidationError('Invalid task data', { issues: parsed.error.issues });
    }

    const task = await taskService.create(projectId, parsed.data as CreateTaskInput);
    sendSuccess(res, task, 201);
  } catch (error) {
    next(error);
  }
});

// Update task
taskRoutes.patch('/:taskId', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, taskId } = req.params;
    const parsed = updateTaskSchema.safeParse(req.body);

    if (!parsed.success) {
      throw new ValidationError('Invalid update data', { issues: parsed.error.issues });
    }

    const task = await taskService.update(projectId, taskId, parsed.data as UpdateTaskInput);
    sendSuccess(res, task);
  } catch (error) {
    next(error);
  }
});

// Move task (status transition)
taskRoutes.post('/:taskId/move', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, taskId } = req.params;
    const parsed = moveTaskSchema.safeParse(req.body);

    if (!parsed.success) {
      throw new ValidationError('Invalid move data', { issues: parsed.error.issues });
    }

    const task = await taskService.move(projectId, taskId, parsed.data as MoveTaskInput);
    sendSuccess(res, task);
  } catch (error) {
    next(error);
  }
});

// Delete task
taskRoutes.delete('/:taskId', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, taskId } = req.params;
    await taskService.delete(projectId, taskId);
    sendSuccess(res, { message: 'Task deleted successfully' });
  } catch (error) {
    next(error);
  }
});

// Get task dependencies
taskRoutes.get('/:taskId/dependencies', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, taskId } = req.params;
    const deps = await taskService.getDependencies(projectId, taskId);
    sendSuccess(res, deps);
  } catch (error) {
    next(error);
  }
});

// Bulk update tasks
taskRoutes.patch('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId } = req.params;
    const { taskIds, updates } = req.body;

    if (!Array.isArray(taskIds) || taskIds.length === 0) {
      throw new ValidationError('taskIds must be a non-empty array');
    }

    const results = await Promise.all(
      taskIds.map((taskId: string) =>
        taskService.update(projectId, taskId, updates)
      )
    );

    sendSuccess(res, { updatedCount: results.length, tasks: results });
  } catch (error) {
    next(error);
  }
});
