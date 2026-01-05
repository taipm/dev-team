import { useParams } from 'react-router-dom';
import { Plus, Filter, RotateCcw } from 'lucide-react';
import { useKanban } from '@/hooks/useTasks';
import { useProject } from '@/hooks/useProjects';
import { useProjectStore } from '@/stores/projectStore';
import { KanbanBoard } from './KanbanBoard';
import { TaskModal } from '../task/TaskModal';
import { Button } from '../common/Button';
import type { TaskStatus } from '@/types';

const STATUS_ORDER: TaskStatus[] = ['backlog', 'in_progress', 'review', 'blocked', 'done'];

export function KanbanPage() {
  const { projectId } = useParams<{ projectId: string }>();
  const { data: projectData } = useProject(projectId || '');
  const { data: kanbanData, isLoading, refetch } = useKanban(projectId || '');
  const { isTaskModalOpen, openTaskModal, closeTaskModal, selectedTask } = useProjectStore();

  const project = projectData?.data;

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600" />
      </div>
    );
  }

  if (!project) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">Project not found</p>
      </div>
    );
  }

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{project.name} - Kanban</h1>
          <p className="text-gray-500 mt-1">
            WIP Limit: {project.metrics.currentWip}/{project.wipLimit} |
            Total Tasks: {project.metrics.totalTasksCreated} |
            Completed: {project.metrics.totalTasksCompleted}
          </p>
        </div>
        <div className="flex items-center gap-3">
          <Button variant="outline" size="sm" onClick={() => refetch()}>
            <RotateCcw className="w-4 h-4" />
            Refresh
          </Button>
          <Button variant="outline" size="sm">
            <Filter className="w-4 h-4" />
            Filter
          </Button>
          <Button onClick={() => openTaskModal()}>
            <Plus className="w-4 h-4" />
            Add Task
          </Button>
        </div>
      </div>

      {/* WIP Progress */}
      <div className="mb-4">
        <div className="flex items-center gap-2 text-sm text-gray-500 mb-1">
          <span>Work in Progress</span>
          <span className="font-medium text-gray-700">
            {project.metrics.currentWip} / {project.wipLimit}
          </span>
        </div>
        <div className="wip-indicator w-64">
          <div
            className={`fill ${
              project.metrics.currentWip >= project.wipLimit
                ? 'danger'
                : project.metrics.currentWip >= project.wipLimit * 0.7
                ? 'warning'
                : 'safe'
            }`}
            style={{ width: `${(project.metrics.currentWip / project.wipLimit) * 100}%` }}
          />
        </div>
      </div>

      {/* Kanban Board */}
      {kanbanData?.data && (
        <KanbanBoard
          data={kanbanData.data}
          projectId={project._id}
          wipLimit={project.wipLimit}
          currentWip={project.metrics.currentWip}
        />
      )}

      {/* Task Modal */}
      <TaskModal
        isOpen={isTaskModalOpen}
        onClose={closeTaskModal}
        projectId={project._id}
        task={selectedTask}
      />
    </div>
  );
}
