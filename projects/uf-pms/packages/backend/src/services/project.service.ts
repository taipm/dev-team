import { ObjectId, WithId } from 'mongodb';
import slugify from 'slugify';
import { collections } from '../database/provider.js';
import {
  Project,
  ProjectType,
  FidelityLevel,
  ProjectPhase,
  OKR,
  ProjectMetrics,
  PhaseProgress,
  PaginationQuery,
} from '../models/interfaces/index.js';
import { NotFoundError, ConflictError } from '../utils/errors.js';

export interface CreateProjectInput {
  name: string;
  description: string;
  type: ProjectType;
  fidelityLevel: FidelityLevel;
  okr: OKR;
  deadline?: Date;
  wipLimit?: number;
  frameworkPath?: string;
}

export interface UpdateProjectInput {
  name?: string;
  description?: string;
  deadline?: Date;
  wipLimit?: number;
  okr?: Partial<OKR>;
  isArchived?: boolean;
}

export interface ProjectFilters extends PaginationQuery {
  type?: ProjectType;
  fidelityLevel?: FidelityLevel;
  currentPhase?: ProjectPhase;
  isArchived?: boolean;
  search?: string;
}

function createInitialPhases(): PhaseProgress[] {
  const phases: ProjectPhase[] = ['define', 'decompose', 'prioritize', 'sequence', 'execute', 'review'];
  return phases.map((phase, index) => ({
    phase,
    status: index === 0 ? 'in_progress' : 'pending',
    tasksTotal: 0,
    tasksCompleted: 0,
    hoursEstimated: 0,
    hoursActual: 0,
  }));
}

function createInitialMetrics(): ProjectMetrics {
  return {
    totalTasksCreated: 0,
    totalTasksCompleted: 0,
    currentWip: 0,
    blockedCount: 0,
    avgCycleTimeHours: 0,
    throughput7d: 0,
    totalEstimatedHours: 0,
    totalActualHours: 0,
  };
}

export class ProjectService {
  async list(filters: ProjectFilters): Promise<{ projects: WithId<Project>[]; total: number }> {
    const {
      page = 1,
      limit = 20,
      sort = 'createdAt',
      order = 'desc',
      type,
      fidelityLevel,
      currentPhase,
      isArchived = false,
      search,
    } = filters;

    const query: Record<string, unknown> = { isArchived };

    if (type) query.type = type;
    if (fidelityLevel) query.fidelityLevel = fidelityLevel;
    if (currentPhase) query.currentPhase = currentPhase;
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } },
      ];
    }

    const skip = (page - 1) * limit;
    const sortDir = order === 'asc' ? 1 : -1;

    const [projects, total] = await Promise.all([
      collections.projects()
        .find(query)
        .sort({ [sort]: sortDir })
        .skip(skip)
        .limit(limit)
        .toArray() as Promise<WithId<Project>[]>,
      collections.projects().countDocuments(query),
    ]);

    return { projects, total };
  }

  async getById(id: string): Promise<WithId<Project>> {
    const project = await collections.projects().findOne({
      _id: new ObjectId(id),
    }) as WithId<Project> | null;

    if (!project) {
      throw new NotFoundError('Project', id);
    }

    return project;
  }

  async getBySlug(slug: string): Promise<WithId<Project>> {
    const project = await collections.projects().findOne({ slug }) as WithId<Project> | null;

    if (!project) {
      throw new NotFoundError('Project', slug);
    }

    return project;
  }

  async create(input: CreateProjectInput): Promise<WithId<Project>> {
    const slug = slugify(input.name, { lower: true, strict: true });

    // Check for duplicate slug
    const existing = await collections.projects().findOne({ slug });
    if (existing) {
      throw new ConflictError(`Project with slug "${slug}" already exists`);
    }

    const now = new Date();
    const project: Project = {
      name: input.name,
      slug,
      description: input.description,
      type: input.type,
      fidelityLevel: input.fidelityLevel,
      currentPhase: 'define',
      okr: input.okr,
      phases: createInitialPhases(),
      metrics: createInitialMetrics(),
      frameworkPath: input.frameworkPath,
      wipLimit: input.wipLimit || 3,
      createdAt: now,
      updatedAt: now,
      deadline: input.deadline,
      isArchived: false,
    };

    const result = await collections.projects().insertOne(project);
    return { ...project, _id: result.insertedId };
  }

  async update(id: string, input: UpdateProjectInput): Promise<WithId<Project>> {
    const updateData: Record<string, unknown> = {
      updatedAt: new Date(),
    };

    if (input.name !== undefined) {
      updateData.name = input.name;
      updateData.slug = slugify(input.name, { lower: true, strict: true });
    }
    if (input.description !== undefined) updateData.description = input.description;
    if (input.deadline !== undefined) updateData.deadline = input.deadline;
    if (input.wipLimit !== undefined) updateData.wipLimit = input.wipLimit;
    if (input.isArchived !== undefined) updateData.isArchived = input.isArchived;

    // Handle OKR partial update
    if (input.okr) {
      const current = await this.getById(id);
      updateData.okr = { ...current.okr, ...input.okr };
    }

    const result = await collections.projects().findOneAndUpdate(
      { _id: new ObjectId(id) },
      { $set: updateData },
      { returnDocument: 'after' }
    );

    if (!result) {
      throw new NotFoundError('Project', id);
    }

    return result as WithId<Project>;
  }

  async delete(id: string): Promise<void> {
    const result = await collections.projects().deleteOne({ _id: new ObjectId(id) });

    if (result.deletedCount === 0) {
      throw new NotFoundError('Project', id);
    }

    // Also delete related tasks
    await collections.tasks().deleteMany({ projectId: new ObjectId(id) });
  }

  async archive(id: string): Promise<WithId<Project>> {
    return this.update(id, { isArchived: true });
  }

  async updatePhase(id: string, phase: ProjectPhase): Promise<WithId<Project>> {
    const project = await this.getById(id);

    // Update phases status
    const updatedPhases = project.phases.map((p) => {
      if (p.phase === phase) {
        return { ...p, status: 'in_progress' as const, startedAt: new Date() };
      }
      if (p.phase === project.currentPhase && p.status === 'in_progress') {
        return { ...p, status: 'completed' as const, completedAt: new Date() };
      }
      return p;
    });

    const result = await collections.projects().findOneAndUpdate(
      { _id: new ObjectId(id) },
      {
        $set: {
          currentPhase: phase,
          phases: updatedPhases,
          updatedAt: new Date(),
        },
      },
      { returnDocument: 'after' }
    );

    return result as WithId<Project>;
  }

  async updateMetrics(id: string, metrics: Partial<ProjectMetrics>): Promise<void> {
    await collections.projects().updateOne(
      { _id: new ObjectId(id) },
      {
        $set: {
          ...Object.fromEntries(
            Object.entries(metrics).map(([key, value]) => [`metrics.${key}`, value])
          ),
          updatedAt: new Date(),
        },
      }
    );
  }
}

export const projectService = new ProjectService();
