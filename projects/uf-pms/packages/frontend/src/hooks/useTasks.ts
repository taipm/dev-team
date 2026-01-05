import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';
import type {
  CreateTaskInput,
  UpdateTaskInput,
  MoveTaskInput,
  Task,
} from '@/types';
import { useUIStore, useProjectStore } from '@/stores/projectStore';

// Query keys
export const taskKeys = {
  all: ['tasks'] as const,
  lists: () => [...taskKeys.all, 'list'] as const,
  list: (projectId: string, filters: Record<string, unknown>) =>
    [...taskKeys.lists(), projectId, filters] as const,
  kanban: (projectId: string) => [...taskKeys.all, 'kanban', projectId] as const,
  details: () => [...taskKeys.all, 'detail'] as const,
  detail: (projectId: string, taskId: string) =>
    [...taskKeys.details(), projectId, taskId] as const,
  dependencies: (projectId: string, taskId: string) =>
    [...taskKeys.all, 'dependencies', projectId, taskId] as const,
};

// List tasks
export function useTasks(
  projectId: string,
  params?: {
    page?: number;
    limit?: number;
    status?: string;
    priority?: string;
    executionPhase?: string;
    search?: string;
  }
) {
  return useQuery({
    queryKey: taskKeys.list(projectId, params || {}),
    queryFn: () => api.listTasks(projectId, params),
    enabled: !!projectId,
  });
}

// Get kanban view
export function useKanban(projectId: string) {
  const setKanbanData = useProjectStore((state) => state.setKanbanData);

  return useQuery({
    queryKey: taskKeys.kanban(projectId),
    queryFn: async () => {
      const result = await api.getTasksKanban(projectId);
      setKanbanData(result.data);
      return result;
    },
    enabled: !!projectId,
  });
}

// Get single task
export function useTask(projectId: string, taskId: string) {
  return useQuery({
    queryKey: taskKeys.detail(projectId, taskId),
    queryFn: () => api.getTask(projectId, taskId),
    enabled: !!projectId && !!taskId,
  });
}

// Get task dependencies
export function useTaskDependencies(projectId: string, taskId: string) {
  return useQuery({
    queryKey: taskKeys.dependencies(projectId, taskId),
    queryFn: () => api.getTaskDependencies(projectId, taskId),
    enabled: !!projectId && !!taskId,
  });
}

// Create task
export function useCreateTask(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: (input: CreateTaskInput) => api.createTask(projectId, input),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: taskKeys.lists() });
      queryClient.invalidateQueries({ queryKey: taskKeys.kanban(projectId) });
      addNotification({ type: 'success', message: 'Task created successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Update task
export function useUpdateTask(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);
  const updateTaskInKanban = useProjectStore((state) => state.updateTaskInKanban);

  return useMutation({
    mutationFn: ({ taskId, input }: { taskId: string; input: UpdateTaskInput }) =>
      api.updateTask(projectId, taskId, input),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: taskKeys.lists() });
      queryClient.setQueryData(taskKeys.detail(projectId, data.data.taskId), data);
      updateTaskInKanban(data.data);
      addNotification({ type: 'success', message: 'Task updated successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}

// Move task (status transition)
export function useMoveTask(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);
  const updateTaskInKanban = useProjectStore((state) => state.updateTaskInKanban);

  return useMutation({
    mutationFn: ({ taskId, input }: { taskId: string; input: MoveTaskInput }) =>
      api.moveTask(projectId, taskId, input),
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: taskKeys.kanban(projectId) });
      updateTaskInKanban(data.data);
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
      // Refetch kanban to reset optimistic update
      queryClient.invalidateQueries({ queryKey: taskKeys.kanban(projectId) });
    },
  });
}

// Delete task
export function useDeleteTask(projectId: string) {
  const queryClient = useQueryClient();
  const addNotification = useUIStore((state) => state.addNotification);

  return useMutation({
    mutationFn: (taskId: string) => api.deleteTask(projectId, taskId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: taskKeys.lists() });
      queryClient.invalidateQueries({ queryKey: taskKeys.kanban(projectId) });
      addNotification({ type: 'success', message: 'Task deleted successfully' });
    },
    onError: (error: Error) => {
      addNotification({ type: 'error', message: error.message });
    },
  });
}
