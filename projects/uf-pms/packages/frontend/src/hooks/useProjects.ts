import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';
import type {
  CreateProjectInput,
  UpdateProjectInput,
  Project,
} from '@/types';
import { useUIStore } from '@/stores/projectStore';

// Query keys
export const projectKeys = {
  all: ['projects'] as const,
  lists: () => [...projectKeys.all, 'list'] as const,
  list: (filters: Record<string, unknown>) => [...projectKeys.lists(), filters] as const,
  details: () => [...projectKeys.all, 'detail'] as const,
  detail: (id: string) => [...projectKeys.details(), id] as const,
  handoff: (id: string) => [...projectKeys.all, 'handoff', id] as const,
};

// List projects
export function useProjects(params?: {
  page?: number;
  limit?: number;
  type?: string;
  search?: string;
  archived?: boolean;
}) {
  return useQuery({
    queryKey: projectKeys.list(params || {}),
    queryFn: () => api.listProjects(params),
  });
}

// Get single project
export function useProject(id: string) {
  return useQuery({
    queryKey: projectKeys.detail(id),
    queryFn: () => api.getProject(id),
    enabled: !!id,
  });
}

// Get project handoff
export function useHandoff(id: string) {
  return useQuery({
    queryKey: projectKeys.handoff(id),
    queryFn: () => api.getHandoff(id),
    enabled: !!id,
  });
}

// Create project
export function useCreateProject() {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: (input: CreateProjectInput) => api.createProject(input),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: projectKeys.lists() });
      addNotification({ type: 'success', message: 'Project created successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Update project
export function useUpdateProject() {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: ({ id, input }: { id: string; input: UpdateProjectInput }) =>
      api.updateProject(id, input),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: projectKeys.lists() });
      queryClient.setQueryData(projectKeys.detail(data.data._id), data);
      addNotification({ type: 'success', message: 'Project updated successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Delete project
export function useDeleteProject() {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: (id: string) => api.deleteProject(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: projectKeys.lists() });
      addNotification({ type: 'success', message: 'Project deleted successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Archive project
export function useArchiveProject() {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: (id: string) => api.archiveProject(id),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: projectKeys.lists() });
      queryClient.setQueryData(projectKeys.detail(data.data._id), data);
      addNotification({ type: 'success', message: 'Project archived successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}
