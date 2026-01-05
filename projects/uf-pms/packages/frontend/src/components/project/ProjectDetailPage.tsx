import { useParams, Link } from 'react-router-dom';
import {
  FolderKanban,
  Target,
  CheckCircle2,
  Clock,
  AlertTriangle,
  Play,
  FileText,
  ArrowRight,
  Settings,
} from 'lucide-react';
import { useProject, useHandoff } from '@/hooks/useProjects';
import { usePhases, useCompletePhase, useAutoPrioritize, useAutoSequence } from '@/hooks/usePhases';
import { Button } from '../common/Button';
import { ProjectPhaseBadge, ExecutionPhaseBadge } from '../common/Badge';
import { PhaseProgress } from './PhaseProgress';
import type { Project, ProjectPhase } from '@/types';

export function ProjectDetailPage() {
  const { projectId } = useParams<{ projectId: string }>();
  const { data: projectData, isLoading } = useProject(projectId || '');
  const { data: phasesData } = usePhases(projectId || '');
  const completePhase = useCompletePhase(projectId || '');
  const autoPrioritize = useAutoPrioritize(projectId || '');
  const autoSequence = useAutoSequence(projectId || '');

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600" />
      </div>
    );
  }

  const project = projectData?.data;

  if (!project) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">Project not found</p>
      </div>
    );
  }

  const handleCompletePhase = () => {
    completePhase.mutate({ phase: project.currentPhase });
  };

  return (
    <div className="max-w-6xl mx-auto">
      {/* Header */}
      <div className="flex items-start justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{project.name}</h1>
          <p className="text-gray-500 mt-1">{project.description}</p>
          <div className="flex items-center gap-3 mt-3">
            <ProjectPhaseBadge phase={project.currentPhase} />
            <span className="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">
              {project.type}
            </span>
            <span className="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">
              {project.fidelityLevel}
            </span>
          </div>
        </div>
        <div className="flex items-center gap-3">
          <Link to={`/projects/${project._id}/kanban`}>
            <Button>
              <FolderKanban className="w-4 h-4" />
              Open Kanban
            </Button>
          </Link>
          <Button variant="outline">
            <Settings className="w-4 h-4" />
          </Button>
        </div>
      </div>

      {/* Phase Progress */}
      <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Project Phases</h2>
        <PhaseProgress
          phases={project.phases}
          currentPhase={project.currentPhase}
        />
        <div className="flex items-center gap-3 mt-4 pt-4 border-t border-gray-100">
          <Button
            onClick={handleCompletePhase}
            isLoading={completePhase.isPending}
            disabled={project.currentPhase === 'review'}
          >
            <CheckCircle2 className="w-4 h-4" />
            Complete {project.currentPhase} Phase
          </Button>

          {project.currentPhase === 'prioritize' && (
            <Button
              variant="outline"
              onClick={() => autoPrioritize.mutate()}
              isLoading={autoPrioritize.isPending}
            >
              Auto-Prioritize (30/30/25/15)
            </Button>
          )}

          {project.currentPhase === 'sequence' && (
            <Button
              variant="outline"
              onClick={() => autoSequence.mutate()}
              isLoading={autoSequence.isPending}
            >
              Auto-Sequence (Critical Path)
            </Button>
          )}
        </div>
      </div>

      {/* Metrics Row */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        <MetricCard
          icon={<Target className="w-5 h-5 text-blue-500" />}
          label="Total Tasks"
          value={project.metrics.totalTasksCreated}
        />
        <MetricCard
          icon={<CheckCircle2 className="w-5 h-5 text-green-500" />}
          label="Completed"
          value={project.metrics.totalTasksCompleted}
          subtitle={`${Math.round((project.metrics.totalTasksCompleted / (project.metrics.totalTasksCreated || 1)) * 100)}%`}
        />
        <MetricCard
          icon={<Play className="w-5 h-5 text-blue-500" />}
          label="In Progress"
          value={project.metrics.currentWip}
          subtitle={`WIP Limit: ${project.wipLimit}`}
        />
        <MetricCard
          icon={<AlertTriangle className="w-5 h-5 text-red-500" />}
          label="Blocked"
          value={project.metrics.blockedCount}
        />
      </div>

      {/* Time Metrics */}
      <div className="grid grid-cols-2 gap-4 mb-6">
        <div className="bg-white rounded-lg border border-gray-200 p-4">
          <div className="flex items-center gap-2 mb-3">
            <Clock className="w-5 h-5 text-gray-400" />
            <h3 className="font-medium text-gray-900">Time Tracking</h3>
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-2xl font-bold text-gray-900">
                {project.metrics.totalEstimatedHours}h
              </p>
              <p className="text-sm text-gray-500">Estimated</p>
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">
                {project.metrics.totalActualHours}h
              </p>
              <p className="text-sm text-gray-500">Actual</p>
            </div>
          </div>
          {project.metrics.totalActualHours > project.metrics.totalEstimatedHours && (
            <p className="mt-2 text-sm text-amber-600">
              Over budget by {project.metrics.totalActualHours - project.metrics.totalEstimatedHours}h
            </p>
          )}
        </div>

        {/* OKR */}
        <div className="bg-white rounded-lg border border-gray-200 p-4">
          <div className="flex items-center gap-2 mb-3">
            <Target className="w-5 h-5 text-gray-400" />
            <h3 className="font-medium text-gray-900">Objective</h3>
          </div>
          <p className="text-gray-700">{project.okr.objective}</p>
          <div className="mt-3">
            <p className="text-sm text-gray-500 mb-2">
              Key Results ({project.okr.keyResults.length})
            </p>
            {project.okr.keyResults.slice(0, 2).map((kr) => (
              <div key={kr.id} className="flex items-center gap-2 text-sm">
                <div
                  className={`w-2 h-2 rounded-full ${
                    kr.status === 'completed'
                      ? 'bg-green-500'
                      : kr.status === 'at_risk'
                      ? 'bg-red-500'
                      : 'bg-gray-300'
                  }`}
                />
                <span className="truncate">{kr.description}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Execution Phase Distribution */}
      <div className="bg-white rounded-lg border border-gray-200 p-4 mb-6">
        <h3 className="font-medium text-gray-900 mb-4">Execution Phase Distribution</h3>
        <div className="flex items-center gap-2">
          <ExecutionPhaseBar phase="FOUNDATION" percentage={30} />
          <ExecutionPhaseBar phase="BUILD" percentage={30} />
          <ExecutionPhaseBar phase="ENHANCE" percentage={25} />
          <ExecutionPhaseBar phase="FINALIZE" percentage={15} />
        </div>
        <div className="flex items-center justify-between mt-2 text-xs text-gray-500">
          <span>FOUNDATION (30%)</span>
          <span>BUILD (30%)</span>
          <span>ENHANCE (25%)</span>
          <span>FINALIZE (15%)</span>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-3 gap-4">
        <Link
          to={`/projects/${project._id}/kanban`}
          className="flex items-center gap-3 p-4 bg-white rounded-lg border border-gray-200 hover:shadow-md transition-shadow"
        >
          <FolderKanban className="w-8 h-8 text-blue-500" />
          <div>
            <h3 className="font-medium text-gray-900">Kanban Board</h3>
            <p className="text-sm text-gray-500">Manage tasks visually</p>
          </div>
          <ArrowRight className="w-5 h-5 text-gray-400 ml-auto" />
        </Link>

        <HandoffCard projectId={project._id} />

        <Link
          to={`/projects/${project._id}/settings`}
          className="flex items-center gap-3 p-4 bg-white rounded-lg border border-gray-200 hover:shadow-md transition-shadow"
        >
          <Settings className="w-8 h-8 text-gray-500" />
          <div>
            <h3 className="font-medium text-gray-900">Settings</h3>
            <p className="text-sm text-gray-500">Configure project</p>
          </div>
          <ArrowRight className="w-5 h-5 text-gray-400 ml-auto" />
        </Link>
      </div>
    </div>
  );
}

function MetricCard({
  icon,
  label,
  value,
  subtitle,
}: {
  icon: React.ReactNode;
  label: string;
  value: number;
  subtitle?: string;
}) {
  return (
    <div className="metrics-card">
      <div className="flex items-center gap-2 mb-2">
        {icon}
        <span className="text-sm text-gray-500">{label}</span>
      </div>
      <div className="value">{value}</div>
      {subtitle && <div className="text-sm text-gray-400">{subtitle}</div>}
    </div>
  );
}

function ExecutionPhaseBar({
  phase,
  percentage,
}: {
  phase: 'FOUNDATION' | 'BUILD' | 'ENHANCE' | 'FINALIZE';
  percentage: number;
}) {
  const colors = {
    FOUNDATION: 'bg-blue-500',
    BUILD: 'bg-emerald-500',
    ENHANCE: 'bg-amber-500',
    FINALIZE: 'bg-violet-500',
  };

  return (
    <div className={`h-4 rounded ${colors[phase]}`} style={{ width: `${percentage}%` }} />
  );
}

function HandoffCard({ projectId }: { projectId: string }) {
  const { data: handoffContent, isLoading } = useHandoff(projectId);

  const handleDownload = () => {
    if (handoffContent) {
      const blob = new Blob([handoffContent], { type: 'text/markdown' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'HANDOFF.md';
      a.click();
      URL.revokeObjectURL(url);
    }
  };

  return (
    <button
      onClick={handleDownload}
      disabled={isLoading}
      className="flex items-center gap-3 p-4 bg-white rounded-lg border border-gray-200 hover:shadow-md transition-shadow text-left"
    >
      <FileText className="w-8 h-8 text-green-500" />
      <div>
        <h3 className="font-medium text-gray-900">HANDOFF Document</h3>
        <p className="text-sm text-gray-500">Download project summary</p>
      </div>
      <ArrowRight className="w-5 h-5 text-gray-400 ml-auto" />
    </button>
  );
}
