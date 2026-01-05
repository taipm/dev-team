import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';
import type { ProjectPhase } from '@/types';
import { useUIStore } from '@/stores/projectStore';
import { projectKeys } from './useProjects';
import { taskKeys } from './useTasks';

// Query keys
export const phaseKeys = {
  all: ['phases'] as const,
  project: (projectId: string) => [...phaseKeys.all, projectId] as const,
  validation: (projectId: string, phase: ProjectPhase) =>
    [...phaseKeys.all, 'validation', projectId, phase] as const,
};

// Get phases status
export function usePhases(projectId: string) {
  return useQuery({
    queryKey: phaseKeys.project(projectId),
    queryFn: () => api.getPhases(projectId),
    enabled: !!projectId,
  });
}

// Validate phase
export function useValidatePhase(projectId: string, phase: ProjectPhase) {
  return useQuery({
    queryKey: phaseKeys.validation(projectId, phase),
    queryFn: () => api.validatePhase(projectId, phase),
    enabled: !!projectId && !!phase,
  });
}

// Complete phase
export function useCompletePhase(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: ({
      phase,
      options,
    }: {
      phase: ProjectPhase;
      options?: { validationOverride?: boolean; notes?: string };
    }) => api.completePhase(projectId, phase, options),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: phaseKeys.project(projectId) });
      queryClient.invalidateQueries({ queryKey: projectKeys.detail(projectId) });
      addNotification({
        type: 'success',
        message: `Phase ${data.data.previousPhase} completed. Now in ${data.data.currentPhase} phase.`,
      });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Auto prioritize
export function useAutoPrioritize(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: () => api.autoPrioritize(projectId),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: taskKeys.lists() });
      queryClient.invalidateQueries({ queryKey: taskKeys.kanban(projectId) });
      addNotification({
        type: 'success',
        message: `Auto-prioritized ${data.data.totalTasks} tasks across ${data.data.distribution.length} phases`,
      });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Auto sequence
export function useAutoSequence(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: () => api.autoSequence(projectId),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: taskKeys.lists() });
      addNotification({
        type: 'success',
        message: `Sequence calculated: ${data.data.sequence.length} steps, ${data.data.parallelSavings.efficiencyGain} time savings`,
      });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}
