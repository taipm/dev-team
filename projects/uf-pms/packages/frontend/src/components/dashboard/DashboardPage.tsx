import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Plus, Search, Filter, FolderKanban, MoreHorizontal, Archive } from 'lucide-react';
import { useProjects, useCreateProject, useArchiveProject } from '@/hooks/useProjects';
import { Button } from '../common/Button';
import { ProjectPhaseBadge } from '../common/Badge';
import { ProjectCreateModal } from './ProjectCreateModal';
import type { Project } from '@/types';

export function DashboardPage() {
  const [search, setSearch] = useState('');
  const [showCreateModal, setShowCreateModal] = useState(false);

  const { data, isLoading } = useProjects({ search: search || undefined });
  const archiveProject = useArchiveProject();

  const projects = data?.data || [];

  return (
    <div>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Projects</h1>
          <p className="text-gray-500 mt-1">
            Manage your Universal Framework projects
          </p>
        </div>
        <Button onClick={() => setShowCreateModal(true)}>
          <Plus className="w-4 h-4" />
          New Project
        </Button>
      </div>

      {/* Filters */}
      <div className="flex items-center gap-4 mb-6">
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search projects..."
            className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>
        <Button variant="outline" size="sm">
          <Filter className="w-4 h-4" />
          Filter
        </Button>
      </div>

      {/* Projects Grid */}
      {isLoading ? (
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600" />
        </div>
      ) : projects.length === 0 ? (
        <div className="text-center py-12 bg-white rounded-lg border border-gray-200">
          <FolderKanban className="w-12 h-12 text-gray-300 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">No projects yet</h3>
          <p className="text-gray-500 mb-4">Create your first project to get started</p>
          <Button onClick={() => setShowCreateModal(true)}>
            <Plus className="w-4 h-4" />
            Create Project
          </Button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {projects.map((project) => (
            <ProjectCard
              key={project._id}
              project={project}
              onArchive={() => archiveProject.mutate(project._id)}
            />
          ))}
        </div>
      )}

      {/* Pagination */}
      {data?.pagination && data.pagination.totalPages > 1 && (
        <div className="flex justify-center mt-6">
          <span className="text-sm text-gray-500">
            Page {data.pagination.page} of {data.pagination.totalPages}
          </span>
        </div>
      )}

      {/* Create Modal */}
      <ProjectCreateModal
        isOpen={showCreateModal}
        onClose={() => setShowCreateModal(false)}
      />
    </div>
  );
}

function ProjectCard({
  project,
  onArchive,
}: {
  project: Project;
  onArchive: () => void;
}) {
  const progressPercent = project.metrics.totalTasksCreated > 0
    ? Math.round((project.metrics.totalTasksCompleted / project.metrics.totalTasksCreated) * 100)
    : 0;

  return (
    <Link
      to={`/projects/${project._id}`}
      className="block bg-white rounded-lg border border-gray-200 p-4 hover:shadow-md transition-shadow"
    >
      <div className="flex items-start justify-between mb-3">
        <div>
          <h3 className="font-semibold text-gray-900">{project.name}</h3>
          <p className="text-sm text-gray-500 mt-1 line-clamp-2">
            {project.description || 'No description'}
          </p>
        </div>
        <button
          onClick={(e) => {
            e.preventDefault();
            onArchive();
          }}
          className="p-1 text-gray-400 hover:text-gray-600"
        >
          <MoreHorizontal className="w-5 h-5" />
        </button>
      </div>

      {/* Phase */}
      <div className="mb-3">
        <ProjectPhaseBadge phase={project.currentPhase} />
      </div>

      {/* Progress */}
      <div className="mb-3">
        <div className="flex items-center justify-between text-sm mb-1">
          <span className="text-gray-500">Progress</span>
          <span className="font-medium">{progressPercent}%</span>
        </div>
        <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
          <div
            className="h-full bg-blue-500 rounded-full transition-all"
            style={{ width: `${progressPercent}%` }}
          />
        </div>
      </div>

      {/* Metrics */}
      <div className="flex items-center gap-4 text-sm text-gray-500">
        <span>{project.metrics.totalTasksCreated} tasks</span>
        <span>{project.metrics.currentWip} WIP</span>
        <span>{project.metrics.blockedCount} blocked</span>
      </div>

      {/* Type and Fidelity */}
      <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100">
        <span className="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">
          {project.type}
        </span>
        <span className="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">
          {project.fidelityLevel}
        </span>
      </div>
    </Link>
  );
}
