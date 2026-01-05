import { useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import clsx from 'clsx';
import { Clock, GitBranch, AlertCircle } from 'lucide-react';
import { useProjectStore } from '@/stores/projectStore';
import { PriorityBadge, ExecutionPhaseBadge } from '../common/Badge';
import type { Task } from '@/types';

interface TaskCardProps {
  task: Task;
  isDragging?: boolean;
}

export function TaskCard({ task, isDragging }: TaskCardProps) {
  const { openTaskModal } = useProjectStore();
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging: isSortableDragging,
  } = useSortable({ id: task.taskId });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };

  const handleClick = (e: React.MouseEvent) => {
    // Don't open modal when dragging
    if (!isSortableDragging) {
      openTaskModal(task);
    }
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
      onClick={handleClick}
      className={clsx(
        'task-card',
        (isDragging || isSortableDragging) && 'dragging opacity-50'
      )}
    >
      {/* Task ID and Priority */}
      <div className="flex items-center justify-between mb-2">
        <span className="text-xs font-mono text-gray-400">{task.taskId}</span>
        <PriorityBadge priority={task.priority} />
      </div>

      {/* Title */}
      <h3 className="text-sm font-medium text-gray-900 mb-2 line-clamp-2">
        {task.title}
      </h3>

      {/* Execution Phase */}
      <div className="mb-2">
        <ExecutionPhaseBadge phase={task.executionPhase} />
      </div>

      {/* Metadata row */}
      <div className="flex items-center gap-3 text-xs text-gray-500">
        {/* Estimated hours */}
        <div className="flex items-center gap-1">
          <Clock className="w-3.5 h-3.5" />
          <span>
            {task.actualHours > 0 ? `${task.actualHours}/` : ''}
            {task.estimatedHours}h
          </span>
        </div>

        {/* Dependencies */}
        {task.dependencies.length > 0 && (
          <div className="flex items-center gap-1">
            <GitBranch className="w-3.5 h-3.5" />
            <span>{task.dependencies.length}</span>
          </div>
        )}

        {/* Blocked indicator */}
        {task.status === 'blocked' && (
          <div className="flex items-center gap-1 text-red-500">
            <AlertCircle className="w-3.5 h-3.5" />
          </div>
        )}
      </div>

      {/* Labels */}
      {task.labels.length > 0 && (
        <div className="flex flex-wrap gap-1 mt-2">
          {task.labels.slice(0, 3).map((label) => (
            <span
              key={label}
              className="px-1.5 py-0.5 bg-gray-100 text-gray-600 text-xs rounded"
            >
              {label}
            </span>
          ))}
          {task.labels.length > 3 && (
            <span className="text-xs text-gray-400">+{task.labels.length - 3}</span>
          )}
        </div>
      )}
    </div>
  );
}
