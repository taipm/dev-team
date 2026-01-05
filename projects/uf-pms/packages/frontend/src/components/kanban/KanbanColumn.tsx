import { useDroppable } from '@dnd-kit/core';
import { SortableContext, verticalListSortingStrategy } from '@dnd-kit/sortable';
import clsx from 'clsx';
import { TaskCard } from './TaskCard';
import type { Task, TaskStatus } from '@/types';

interface KanbanColumnProps {
  id: TaskStatus;
  title: string;
  tasks: Task[];
  isWipColumn?: boolean;
  wipLimit?: number;
  currentWip?: number;
}

const columnColors: Record<TaskStatus, string> = {
  backlog: 'border-gray-300',
  in_progress: 'border-blue-400',
  review: 'border-amber-400',
  blocked: 'border-red-400',
  done: 'border-green-400',
  skipped: 'border-gray-300',
};

const headerColors: Record<TaskStatus, string> = {
  backlog: 'bg-gray-100 text-gray-700',
  in_progress: 'bg-blue-50 text-blue-700',
  review: 'bg-amber-50 text-amber-700',
  blocked: 'bg-red-50 text-red-700',
  done: 'bg-green-50 text-green-700',
  skipped: 'bg-gray-100 text-gray-500',
};

export function KanbanColumn({
  id,
  title,
  tasks,
  isWipColumn,
  wipLimit,
  currentWip,
}: KanbanColumnProps) {
  const { setNodeRef, isOver } = useDroppable({ id });

  const taskIds = tasks.map((t) => t.taskId);

  return (
    <div
      ref={setNodeRef}
      className={clsx(
        'kanban-column border-t-4',
        columnColors[id],
        isOver && 'ring-2 ring-blue-400 ring-opacity-50'
      )}
    >
      {/* Column Header */}
      <div className="flex items-center justify-between mb-3">
        <div className={clsx('flex items-center gap-2 px-2 py-1 rounded-md', headerColors[id])}>
          <span className="font-medium">{title}</span>
          <span className="bg-white/50 px-1.5 py-0.5 rounded text-xs font-medium">
            {tasks.length}
          </span>
        </div>

        {isWipColumn && wipLimit && (
          <div className="text-xs text-gray-500">
            WIP: {currentWip}/{wipLimit}
          </div>
        )}
      </div>

      {/* Tasks */}
      <SortableContext items={taskIds} strategy={verticalListSortingStrategy}>
        <div className="flex flex-col gap-2 min-h-[200px]">
          {tasks.map((task) => (
            <TaskCard key={task.taskId} task={task} />
          ))}

          {tasks.length === 0 && (
            <div className="flex items-center justify-center h-24 text-gray-400 text-sm border-2 border-dashed border-gray-200 rounded-lg">
              Drop tasks here
            </div>
          )}
        </div>
      </SortableContext>
    </div>
  );
}
