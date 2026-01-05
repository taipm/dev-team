import { ObjectId } from 'mongodb';

// =============================================================================
// ENUMS
// =============================================================================

export type ProjectType = 'ui' | 'api' | 'algorithm' | 'documentation' | 'hybrid';
export type FidelityLevel = 'prototype' | 'functional' | 'polished' | 'realistic';
export type ProjectPhase = 'define' | 'decompose' | 'prioritize' | 'sequence' | 'execute' | 'review';
export type ExecutionPhase = 'FOUNDATION' | 'BUILD' | 'ENHANCE' | 'FINALIZE';
export type TaskStatus = 'backlog' | 'in_progress' | 'review' | 'blocked' | 'done' | 'skipped';
export type TaskPriority = 'critical' | 'high' | 'medium' | 'low';
export type TaskType = 'analysis' | 'design' | 'code' | 'test' | 'documentation';

// =============================================================================
// KEY RESULT
// =============================================================================

export interface KeyResult {
  id: string;
  description: string;
  metric: string;
  baseline: number | null;
  target: number;
  current: number;
  unit: string;
  deadline?: Date;
  verificationMethod: string;
  status: 'not_started' | 'in_progress' | 'at_risk' | 'on_track' | 'completed';
}

// =============================================================================
// OKR
// =============================================================================

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

// =============================================================================
// PHASE PROGRESS
// =============================================================================

export interface PhaseProgress {
  phase: ProjectPhase;
  status: 'pending' | 'in_progress' | 'completed';
  tasksTotal: number;
  tasksCompleted: number;
  hoursEstimated: number;
  hoursActual: number;
  startedAt?: Date;
  completedAt?: Date;
}

// =============================================================================
// PROJECT METRICS
// =============================================================================

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

// =============================================================================
// PROJECT
// =============================================================================

export interface Project {
  _id?: ObjectId;
  name: string;
  slug: string;
  description: string;
  type: ProjectType;
  fidelityLevel: FidelityLevel;
  currentPhase: ProjectPhase;
  okr: OKR;
  phases: PhaseProgress[];
  metrics: ProjectMetrics;

  // Universal Framework sync
  frameworkPath?: string;
  syncStatus?: 'synced' | 'local_changes' | 'file_changes' | 'conflict';
  lastSyncedAt?: Date;
  fileHash?: string;

  // Team
  ownerId?: ObjectId;
  memberIds?: ObjectId[];

  // Settings
  wipLimit: number;

  // Timestamps
  createdAt: Date;
  updatedAt: Date;
  deadline?: Date;

  // Status
  isArchived: boolean;
}

// =============================================================================
// TASK INPUT/OUTPUT
// =============================================================================

export interface TaskInput {
  required: { name: string; format: string; providedBy?: string }[];
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

// =============================================================================
// TASK
// =============================================================================

export interface Task {
  _id?: ObjectId;
  projectId: ObjectId;
  taskId: string;
  title: string;
  description: string;
  type: TaskType;
  status: TaskStatus;
  priority: TaskPriority;
  executionPhase: ExecutionPhase;

  // Time tracking
  estimatedHours: number;
  actualHours: number;

  // Assignment
  assigneeId?: ObjectId;
  assigneeType?: 'user' | 'agent';

  // Dependencies
  dependencies: string[];
  dependents?: string[];

  // Specs
  input?: TaskInput;
  output?: TaskOutput;
  verify?: TaskVerify;

  // Labels
  labels: string[];
  skillsRequired?: string[];

  // Blocked info
  blockedReason?: string;
  blockedBy?: string;

  // Result
  result?: string;

  // Timestamps
  createdAt: Date;
  startedAt?: Date;
  completedAt?: Date;
  updatedAt: Date;

  // History
  history: {
    action: string;
    timestamp: Date;
    by: string;
    details?: string;
  }[];
}

// =============================================================================
// VALIDATION
// =============================================================================

export type CheckpointType = 'pre_execute' | 'mid_execute_25' | 'mid_execute_50' | 'post_execute';

export interface ValidationCheck {
  id: string;
  category: string;
  description: string;
  status: 'pass' | 'fail' | 'warning' | 'skipped';
  critical: boolean;
  evidence?: {
    type: string;
    location: string;
    details: string;
  };
  deviation?: string;
  recommendation?: string;
}

export interface ValidationGate {
  _id?: ObjectId;
  projectId: ObjectId;
  checkpoint: CheckpointType;
  status: 'pending' | 'passed' | 'blocked' | 'passed_with_warnings';
  checks: ValidationCheck[];
  blockingIssues: {
    checkId: string;
    issue: string;
    fixRequired: string;
  }[];
  executedAt: Date;
}

// =============================================================================
// HANDOFF
// =============================================================================

export interface HandoffSection {
  id: string;
  title: string;
  content: string;
  type: 'metadata' | 'execution' | 'visual' | 'api' | 'algorithm' | 'validation';
}

export interface Handoff {
  _id?: ObjectId;
  projectId: ObjectId;
  version: string;
  content: string;
  sections: HandoffSection[];
  filePath?: string;
  fileHash?: string;
  generatedAt: Date;
  lastEditedAt: Date;
}

// =============================================================================
// USER
// =============================================================================

export interface User {
  _id?: ObjectId;
  email: string;
  passwordHash: string;
  name: string;
  role: 'admin' | 'project_manager' | 'developer' | 'viewer';
  avatarUrl?: string;
  stats: {
    completedTotal: number;
    completedToday: number;
    avgCycleTimeMinutes: number;
  };
  createdAt: Date;
  updatedAt: Date;
  lastLoginAt?: Date;
  isActive: boolean;
}

// =============================================================================
// API TYPES
// =============================================================================

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: Record<string, unknown>;
  };
  meta?: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

export interface PaginationQuery {
  page?: number;
  limit?: number;
  sort?: string;
  order?: 'asc' | 'desc';
}

export interface TaskFilters extends PaginationQuery {
  status?: TaskStatus | TaskStatus[];
  priority?: TaskPriority | TaskPriority[];
  executionPhase?: ExecutionPhase;
  assigneeId?: string;
  labels?: string[];
  search?: string;
}
