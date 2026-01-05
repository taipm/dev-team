import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { projectService, CreateProjectInput, UpdateProjectInput, ProjectFilters } from '../../services/project.service.js';
import { handoffService } from '../../services/handoff.service.js';
import { sendSuccess, sendPaginated } from '../../utils/response.js';
import { ValidationError } from '../../utils/errors.js';

export const projectRoutes = Router();

// Validation schemas
const createProjectSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().max(2000).default(''),
  type: z.enum(['ui', 'api', 'algorithm', 'documentation', 'hybrid']),
  fidelityLevel: z.enum(['prototype', 'functional', 'polished', 'realistic']),
  okr: z.object({
    objective: z.string().min(1),
    keyResults: z.array(z.object({
      id: z.string(),
      description: z.string(),
      metric: z.string(),
      baseline: z.number().nullable(),
      target: z.number(),
      current: z.number().default(0),
      unit: z.string(),
      verificationMethod: z.string(),
      status: z.enum(['not_started', 'in_progress', 'at_risk', 'on_track', 'completed']).default('not_started'),
    })),
    speedOfLight: z.object({
      value: z.number(),
      unit: z.string(),
      breakdown: z.array(z.object({ item: z.string(), hours: z.number() })),
    }).optional(),
    constraints: z.object({
      time: z.string().optional(),
      resources: z.string().optional(),
      technology: z.string().optional(),
    }).optional(),
  }),
  deadline: z.string().datetime().optional().transform((val) => val ? new Date(val) : undefined),
  wipLimit: z.number().min(1).max(10).default(3),
  frameworkPath: z.string().optional(),
});

const updateProjectSchema = z.object({
  name: z.string().min(1).max(200).optional(),
  description: z.string().max(2000).optional(),
  deadline: z.string().datetime().optional().transform((val) => val ? new Date(val) : undefined),
  wipLimit: z.number().min(1).max(10).optional(),
  isArchived: z.boolean().optional(),
  okr: z.object({
    objective: z.string().optional(),
    keyResults: z.array(z.any()).optional(),
  }).optional(),
});

// List projects
projectRoutes.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const filters: ProjectFilters = {
      page: parseInt(req.query.page as string) || 1,
      limit: Math.min(parseInt(req.query.limit as string) || 20, 100),
      sort: (req.query.sort as string) || 'createdAt',
      order: (req.query.order as 'asc' | 'desc') || 'desc',
      type: req.query.type as any,
      fidelityLevel: req.query.fidelityLevel as any,
      currentPhase: req.query.currentPhase as any,
      isArchived: req.query.archived === 'true',
      search: req.query.search as string,
    };

    const { projects, total } = await projectService.list(filters);
    sendPaginated(res, projects, filters.page!, filters.limit!, total);
  } catch (error) {
    next(error);
  }
});

// Get project by ID
projectRoutes.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const project = await projectService.getById(req.params.id);
    sendSuccess(res, project);
  } catch (error) {
    next(error);
  }
});

// Create project
projectRoutes.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const parsed = createProjectSchema.safeParse(req.body);
    if (!parsed.success) {
      throw new ValidationError('Invalid project data', { issues: parsed.error.issues });
    }

    const project = await projectService.create(parsed.data as CreateProjectInput);
    sendSuccess(res, project, 201);
  } catch (error) {
    next(error);
  }
});

// Update project
projectRoutes.patch('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const parsed = updateProjectSchema.safeParse(req.body);
    if (!parsed.success) {
      throw new ValidationError('Invalid update data', { issues: parsed.error.issues });
    }

    const project = await projectService.update(req.params.id, parsed.data as UpdateProjectInput);
    sendSuccess(res, project);
  } catch (error) {
    next(error);
  }
});

// Delete project
projectRoutes.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await projectService.delete(req.params.id);
    sendSuccess(res, { message: 'Project deleted successfully' });
  } catch (error) {
    next(error);
  }
});

// Archive project
projectRoutes.post('/:id/archive', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const project = await projectService.archive(req.params.id);
    sendSuccess(res, project);
  } catch (error) {
    next(error);
  }
});

// Get HANDOFF document
projectRoutes.get('/:id/handoff', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const project = await projectService.getById(req.params.id);
    const handoffDoc = await handoffService.generate(req.params.id);

    if (req.query.format === 'file') {
      res.setHeader('Content-Type', 'text/markdown');
      res.setHeader('Content-Disposition', `attachment; filename="${project.slug}-handoff.md"`);
      res.send(handoffDoc.content);
    } else {
      sendSuccess(res, {
        content: handoffDoc.content,
        generatedAt: handoffDoc.generatedAt,
        version: handoffDoc.version,
      });
    }
  } catch (error) {
    next(error);
  }
});
