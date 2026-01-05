import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { projectService } from '../../services/project.service.js';
import { taskService } from '../../services/task.service.js';
import { sendSuccess } from '../../utils/response.js';
import { ValidationError, PhaseValidationError } from '../../utils/errors.js';
import { ProjectPhase, ExecutionPhase, Task } from '../../models/interfaces/index.js';
import { ObjectId, WithId } from 'mongodb';

export const phaseRoutes = Router({ mergeParams: true });

// Phase order for validation
const PHASE_ORDER: ProjectPhase[] = ['define', 'decompose', 'prioritize', 'sequence', 'execute', 'review'];

// Distribution percentages for auto-prioritize
const PHASE_DISTRIBUTION: Record<ExecutionPhase, number> = {
  FOUNDATION: 0.30,
  BUILD: 0.30,
  ENHANCE: 0.25,
  FINALIZE: 0.15,
};

const completePhaseSchema = z.object({
  validationOverride: z.boolean().default(false),
  notes: z.string().optional(),
});

// Get all phases status
phaseRoutes.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId } = req.params;
    const project = await projectService.getById(projectId);

    const phasesWithValidation = project.phases.map((phase) => {
      const phaseIndex = PHASE_ORDER.indexOf(phase.phase);
      const currentIndex = PHASE_ORDER.indexOf(project.currentPhase);

      return {
        ...phase,
        canTransition: phaseIndex === currentIndex && phase.status === 'in_progress',
        isComplete: phase.status === 'completed',
        isCurrent: phase.phase === project.currentPhase,
      };
    });

    sendSuccess(res, {
      currentPhase: project.currentPhase,
      phases: phasesWithValidation,
    });
  } catch (error) {
    next(error);
  }
});

// Complete phase and transition to next
phaseRoutes.post('/:phase/complete', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, phase } = req.params;
    const parsed = completePhaseSchema.safeParse(req.body);

    if (!parsed.success) {
      throw new ValidationError('Invalid request data', { issues: parsed.error.issues });
    }

    const project = await projectService.getById(projectId);

    // Validate current phase matches
    if (project.currentPhase !== phase) {
      throw new ValidationError(`Cannot complete phase ${phase}. Current phase is ${project.currentPhase}`);
    }

    // Run phase validation (unless override)
    if (!parsed.data.validationOverride) {
      const validationErrors = await validatePhase(projectId, phase as ProjectPhase);
      if (validationErrors.length > 0) {
        throw new PhaseValidationError(phase, validationErrors);
      }
    }

    // Get next phase
    const currentIndex = PHASE_ORDER.indexOf(phase as ProjectPhase);
    if (currentIndex >= PHASE_ORDER.length - 1) {
      throw new ValidationError('Project is already in the final phase');
    }

    const nextPhase = PHASE_ORDER[currentIndex + 1];
    const updatedProject = await projectService.updatePhase(projectId, nextPhase);

    sendSuccess(res, {
      previousPhase: phase,
      currentPhase: nextPhase,
      project: updatedProject,
    });
  } catch (error) {
    next(error);
  }
});

// Validate phase (dry run)
phaseRoutes.get('/:phase/validate', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId, phase } = req.params;

    const errors = await validatePhase(projectId, phase as ProjectPhase);

    sendSuccess(res, {
      phase,
      canComplete: errors.length === 0,
      checks: errors.length === 0
        ? [{ name: 'All checks passed', passed: true }]
        : errors.map((e) => ({ name: e.name, passed: false, message: e.message })),
    });
  } catch (error) {
    next(error);
  }
});

// Auto-prioritize tasks (30/30/25/15 distribution)
phaseRoutes.post('/prioritize/auto', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId } = req.params;

    const { tasks } = await taskService.list(projectId, { limit: 500 });

    if (tasks.length === 0) {
      throw new ValidationError('No tasks found to prioritize');
    }

    // Calculate total hours
    const totalHours = tasks.reduce((sum, t) => sum + t.estimatedHours, 0);

    // Sort by dependencies (tasks with no deps first), then by priority
    const sorted = [...tasks].sort((a, b) => {
      const aDeps = (a.dependencies || []).length;
      const bDeps = (b.dependencies || []).length;
      if (aDeps !== bDeps) return aDeps - bDeps;

      const priorityOrder: Record<string, number> = { critical: 0, high: 1, medium: 2, low: 3 };
      return priorityOrder[a.priority] - priorityOrder[b.priority];
    });

    // Assign to phases
    const phaseHours: Record<ExecutionPhase, number> = {
      FOUNDATION: 0,
      BUILD: 0,
      ENHANCE: 0,
      FINALIZE: 0,
    };

    const distribution: Record<ExecutionPhase, WithId<Task>[]> = {
      FOUNDATION: [],
      BUILD: [],
      ENHANCE: [],
      FINALIZE: [],
    };

    for (const task of sorted) {
      const phase = assignToPhase(task, phaseHours, totalHours);
      distribution[phase].push(task);
      phaseHours[phase] += task.estimatedHours;

      // Update task in database
      await taskService.update(projectId, task.taskId, {
        // Note: executionPhase is set on creation, this is for re-assignment
      });
    }

    const result = {
      distribution: Object.entries(distribution).map(([phase, phaseTasks]) => ({
        phase,
        taskCount: phaseTasks.length,
        hours: phaseHours[phase as ExecutionPhase],
        percentage: totalHours > 0
          ? Math.round((phaseHours[phase as ExecutionPhase] / totalHours) * 100)
          : 0,
        tasks: phaseTasks.map((t) => ({ taskId: t.taskId, title: t.title })),
      })),
      totalTasks: tasks.length,
      totalHours,
    };

    sendSuccess(res, result);
  } catch (error) {
    next(error);
  }
});

// Auto-sequence tasks (calculate critical path)
phaseRoutes.post('/sequence/auto', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { projectId } = req.params;

    const { tasks } = await taskService.list(projectId, { limit: 500 });

    if (tasks.length === 0) {
      throw new ValidationError('No tasks found to sequence');
    }

    // Build dependency graph
    const taskMap = new Map(tasks.map((t) => [t.taskId, t]));
    const sequence: { step: number; tasks: string[]; parallel: boolean; hours: number }[] = [];

    // Find entry points (tasks with no dependencies)
    let remaining = new Set(tasks.map((t) => t.taskId));
    let completed = new Set<string>();
    let step = 0;

    while (remaining.size > 0) {
      step++;

      // Find tasks that can be executed (all deps completed)
      const executable: string[] = [];
      for (const taskId of remaining) {
        const task = taskMap.get(taskId)!;
        const depsCompleted = (task.dependencies || []).every((d) => completed.has(d));
        if (depsCompleted) {
          executable.push(taskId);
        }
      }

      if (executable.length === 0) {
        // Circular dependency or error
        throw new ValidationError('Circular dependency detected', {
          remaining: Array.from(remaining),
        });
      }

      const stepHours = executable.reduce((sum, id) => sum + (taskMap.get(id)?.estimatedHours || 0), 0);

      sequence.push({
        step,
        tasks: executable,
        parallel: executable.length > 1,
        hours: stepHours,
      });

      // Mark as completed
      for (const taskId of executable) {
        remaining.delete(taskId);
        completed.add(taskId);
      }
    }

    // Calculate critical path (longest path)
    const criticalPath = calculateCriticalPath(tasks, taskMap);

    // Calculate totals
    const sequentialHours = tasks.reduce((sum, t) => sum + t.estimatedHours, 0);
    const parallelHours = sequence.reduce((sum, s) => {
      const maxHours = Math.max(...s.tasks.map((id) => taskMap.get(id)?.estimatedHours || 0));
      return sum + maxHours;
    }, 0);

    sendSuccess(res, {
      sequence,
      criticalPath: {
        tasks: criticalPath.path,
        totalHours: criticalPath.hours,
      },
      parallelSavings: {
        sequentialHours,
        parallelHours,
        hoursSaved: sequentialHours - parallelHours,
        efficiencyGain: `${Math.round(((sequentialHours - parallelHours) / sequentialHours) * 100)}%`,
      },
      milestones: [
        { name: 'FOUNDATION Complete', afterStep: Math.ceil(sequence.length * 0.3) },
        { name: 'BUILD Complete', afterStep: Math.ceil(sequence.length * 0.6) },
        { name: 'ENHANCE Complete', afterStep: Math.ceil(sequence.length * 0.85) },
        { name: 'FINALIZE Complete', afterStep: sequence.length },
      ],
    });
  } catch (error) {
    next(error);
  }
});

// Helper functions
async function validatePhase(projectId: string, phase: ProjectPhase): Promise<{ name: string; message: string }[]> {
  const errors: { name: string; message: string }[] = [];
  const project = await projectService.getById(projectId);

  switch (phase) {
    case 'define':
      if (!project.okr.objective) {
        errors.push({ name: 'objective_required', message: 'OKR objective is required' });
      }
      if (!project.okr.keyResults || project.okr.keyResults.length === 0) {
        errors.push({ name: 'key_results_required', message: 'At least one key result is required' });
      }
      break;

    case 'decompose':
      const { total } = await taskService.list(projectId, { limit: 1 });
      if (total === 0) {
        errors.push({ name: 'tasks_required', message: 'At least one task must be created' });
      }
      break;

    case 'prioritize':
      // Check all tasks have execution phase assigned
      const { tasks } = await taskService.list(projectId, { limit: 500 });
      const unassigned = tasks.filter((t) => !t.executionPhase);
      if (unassigned.length > 0) {
        errors.push({
          name: 'phases_required',
          message: `${unassigned.length} tasks need execution phase assignment`,
        });
      }
      break;

    case 'execute':
      // Check all tasks are done
      const execResult = await taskService.list(projectId, { limit: 500 });
      const incomplete = execResult.tasks.filter((t) => t.status !== 'done' && t.status !== 'skipped');
      if (incomplete.length > 0) {
        errors.push({
          name: 'tasks_incomplete',
          message: `${incomplete.length} tasks are not completed`,
        });
      }
      break;
  }

  return errors;
}

function assignToPhase(
  task: WithId<Task>,
  currentHours: Record<ExecutionPhase, number>,
  totalHours: number
): ExecutionPhase {
  const phases: ExecutionPhase[] = ['FOUNDATION', 'BUILD', 'ENHANCE', 'FINALIZE'];

  for (const phase of phases) {
    const targetHours = totalHours * PHASE_DISTRIBUTION[phase];
    const current = currentHours[phase];

    if (current + task.estimatedHours <= targetHours * 1.1) {
      return phase;
    }
  }

  // Default to phase with most remaining capacity
  let bestPhase: ExecutionPhase = 'BUILD';
  let maxRemaining = 0;

  for (const phase of phases) {
    const targetHours = totalHours * PHASE_DISTRIBUTION[phase];
    const remaining = targetHours - currentHours[phase];
    if (remaining > maxRemaining) {
      maxRemaining = remaining;
      bestPhase = phase;
    }
  }

  return bestPhase;
}

function calculateCriticalPath(
  tasks: WithId<Task>[],
  taskMap: Map<string, WithId<Task>>
): { path: string[]; hours: number } {
  const distances = new Map<string, number>();
  const previous = new Map<string, string | null>();

  // Initialize
  for (const task of tasks) {
    distances.set(task.taskId, 0);
    previous.set(task.taskId, null);
  }

  // Process in topological order
  const visited = new Set<string>();
  const order: string[] = [];

  function visit(taskId: string) {
    if (visited.has(taskId)) return;
    visited.add(taskId);

    const task = taskMap.get(taskId)!;
    for (const dep of task.dependencies || []) {
      visit(dep);
    }
    order.push(taskId);
  }

  for (const task of tasks) {
    visit(task.taskId);
  }

  // Calculate longest path
  for (const taskId of order) {
    const task = taskMap.get(taskId)!;
    for (const dep of task.dependencies || []) {
      const newDist = distances.get(dep)! + task.estimatedHours;
      if (newDist > distances.get(taskId)!) {
        distances.set(taskId, newDist);
        previous.set(taskId, dep);
      }
    }
    // If no dependencies, just use own hours
    if ((task.dependencies || []).length === 0) {
      distances.set(taskId, task.estimatedHours);
    }
  }

  // Find task with maximum distance
  let maxTask = order[0];
  let maxDist = 0;
  for (const [taskId, dist] of distances) {
    if (dist > maxDist) {
      maxDist = dist;
      maxTask = taskId;
    }
  }

  // Reconstruct path
  const path: string[] = [];
  let current: string | null = maxTask;
  while (current) {
    path.unshift(current);
    current = previous.get(current) || null;
  }

  return { path, hours: maxDist };
}
