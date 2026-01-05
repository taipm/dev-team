// Project Types
export type ProjectType = 'ui' | 'api' | 'algorithm' | 'documentation' | 'hybrid';
export type FidelityLevel = 'prototype' | 'functional' | 'polished' | 'realistic';
export type ProjectPhase = 'define' | 'decompose' | 'prioritize' | 'sequence' | 'execute' | 'review';
export type ExecutionPhase = 'FOUNDATION' | 'BUILD' | 'ENHANCE' | 'FINALIZE';

// Task Types
export type TaskStatus = 'backlog' | 'in_progress' | 'review' | 'blocked' | 'done' | 'skipped';
export type TaskPriority = 'critical' | 'high' | 'medium' | 'low';
export type TaskType = 'analysis' | 'design' | 'code' | 'test' | 'documentation';

// Key Result
export interface KeyResult {
  id: string;
  description: string;
  metric: string;
  baseline: number | null;
  target: number;
  current: number;
  unit: string;
  verificationMethod: string;
  status: 'not_started' | 'in_progress' | 'at_risk' | 'on_track' | 'completed';
}

// OKR
export interface OKR {
  objective: string;
  keyResults: KeyResult[];
  speedOfLight?: {
    value: number;
    unit: string;
    breakdown: { item: string; hours: number }[];
  };
  constraints?: {
    time?: string;
    resources?: string;
    technology?: string;
  };
}

// Phase Progress
export interface PhaseProgress {
  phase: ProjectPhase;
  status: 'pending' | 'in_progress' | 'completed';
  tasksTotal: number;
  tasksCompleted: number;
  hoursEstimated: number;
  hoursActual: number;
  startedAt?: string;
  completedAt?: string;
}

// Project Metrics
export interface ProjectMetrics {
  totalTasksCreated: number;
  totalTasksCompleted: number;
  currentWip: number;
  blockedCount: number;
  avgCycleTimeHours: number;
  throughput7d: number;
  totalEstimatedHours: number;
  totalActualHours: number;
}

// Project
export interface Project {
  _id: string;
  name: string;
  slug: string;
  description: string;
  type: ProjectType;
  fidelityLevel: FidelityLevel;
  currentPhase: ProjectPhase;
  okr: OKR;
  phases: PhaseProgress[];
  metrics: ProjectMetrics;
  frameworkPath?: string;
  wipLimit: number;
  createdAt: string;
  updatedAt: string;
  deadline?: string;
  isArchived: boolean;
}

// Task Input/Output
export interface TaskInput {
  required: {
    name: string;
    format: string;
    providedBy?: string;
  }[];
}

export interface TaskOutput {
  deliverable: string;
  format: string;
  location: string;
}

export interface TaskVerify {
  criteria: string[];
  method: string;
  doneWhen: string;
}

// Task History
export interface TaskHistory {
  action: string;
  timestamp: string;
  by: string;
  details?: string;
}

// Task
export interface Task {
  _id: string;
  projectId: string;
  taskId: string;
  title: string;
  description: string;
  type: TaskType;
  status: TaskStatus;
  priority: TaskPriority;
  executionPhase: ExecutionPhase;
  estimatedHours: number;
  actualHours: number;
  dependencies: string[];
  input?: TaskInput;
  output?: TaskOutput;
  verify?: TaskVerify;
  labels: string[];
  skillsRequired?: string[];
  assigneeId?: string;
  createdAt: string;
  updatedAt: string;
  startedAt?: string;
  completedAt?: string;
  blockedReason?: string;
  result?: string;
  history: TaskHistory[];
}

// API Response Types
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  timestamp: string;
}

export interface PaginatedResponse<T> {
  success: boolean;
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
  timestamp: string;
}

// Create/Update DTOs
export interface CreateProjectInput {
  name: string;
  description: string;
  type: ProjectType;
  fidelityLevel: FidelityLevel;
  okr: OKR;
  deadline?: string;
  wipLimit?: number;
  frameworkPath?: string;
}

export interface UpdateProjectInput {
  name?: string;
  description?: string;
  deadline?: string;
  wipLimit?: number;
  okr?: Partial<OKR>;
  isArchived?: boolean;
}

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

// Kanban grouped tasks
export type KanbanData = Record<TaskStatus, Task[]>;

// Phase validation
export interface PhaseValidation {
  phase: ProjectPhase;
  canComplete: boolean;
  checks: {
    name: string;
    passed: boolean;
    message?: string;
  }[];
}
