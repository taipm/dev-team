import clsx from 'clsx';
import type { TaskStatus, TaskPriority, ExecutionPhase, ProjectPhase } from '@/types';

interface BadgeProps {
  children: React.ReactNode;
  variant?: 'default' | 'outline';
  className?: string;
}

export function Badge({ children, variant = 'default', className }: BadgeProps) {
  return (
    <span
      className={clsx(
        'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium',
        variant === 'default' && 'bg-gray-100 text-gray-700',
        variant === 'outline' && 'border border-gray-300 text-gray-600',
        className
      )}
    >
      {children}
    </span>
  );
}

// Status Badge
const statusStyles: Record<TaskStatus, string> = {
  backlog: 'bg-gray-100 text-gray-700',
  in_progress: 'bg-blue-100 text-blue-700',
  review: 'bg-amber-100 text-amber-700',
  blocked: 'bg-red-100 text-red-700',
  done: 'bg-green-100 text-green-700',
  skipped: 'bg-gray-100 text-gray-400',
};

const statusLabels: Record<TaskStatus, string> = {
  backlog: 'Backlog',
  in_progress: 'In Progress',
  review: 'Review',
  blocked: 'Blocked',
  done: 'Done',
  skipped: 'Skipped',
};

export function StatusBadge({ status }: { status: TaskStatus }) {
  return (
    <span className={clsx('status-badge', statusStyles[status])}>
      {statusLabels[status]}
    </span>
  );
}

// Priority Badge
const priorityStyles: Record<TaskPriority, string> = {
  critical: 'bg-red-100 text-red-700',
  high: 'bg-orange-100 text-orange-700',
  medium: 'bg-amber-100 text-amber-700',
  low: 'bg-gray-100 text-gray-600',
};

const priorityLabels: Record<TaskPriority, string> = {
  critical: 'Critical',
  high: 'High',
  medium: 'Medium',
  low: 'Low',
};

export function PriorityBadge({ priority }: { priority: TaskPriority }) {
  return (
    <span className={clsx('priority-badge', priorityStyles[priority])}>
      {priorityLabels[priority]}
    </span>
  );
}

// Execution Phase Badge
const executionStyles: Record<ExecutionPhase, string> = {
  FOUNDATION: 'bg-blue-100 text-blue-700',
  BUILD: 'bg-emerald-100 text-emerald-700',
  ENHANCE: 'bg-amber-100 text-amber-700',
  FINALIZE: 'bg-violet-100 text-violet-700',
};

export function ExecutionPhaseBadge({ phase }: { phase: ExecutionPhase }) {
  return (
    <span className={clsx('execution-badge', executionStyles[phase])}>
      {phase}
    </span>
  );
}

// Project Phase Badge
const phaseStyles: Record<ProjectPhase, string> = {
  define: 'bg-blue-100 text-blue-700',
  decompose: 'bg-violet-100 text-violet-700',
  prioritize: 'bg-amber-100 text-amber-700',
  sequence: 'bg-emerald-100 text-emerald-700',
  execute: 'bg-red-100 text-red-700',
  review: 'bg-indigo-100 text-indigo-700',
};

const phaseLabels: Record<ProjectPhase, string> = {
  define: 'Define',
  decompose: 'Decompose',
  prioritize: 'Prioritize',
  sequence: 'Sequence',
  execute: 'Execute',
  review: 'Review',
};

export function ProjectPhaseBadge({ phase }: { phase: ProjectPhase }) {
  return (
    <span className={clsx('rounded-full px-3 py-1 text-xs font-medium', phaseStyles[phase])}>
      {phaseLabels[phase]}
    </span>
  );
}
