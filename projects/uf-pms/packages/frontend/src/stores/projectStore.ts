import { create } from 'zustand';
import type { Project, Task, KanbanData, ProjectPhase } from '@/types';

interface ProjectState {
  // Current project context
  currentProject: Project | null;
  setCurrentProject: (project: Project | null) => void;

  // Kanban data
  kanbanData: KanbanData | null;
  setKanbanData: (data: KanbanData | null) => void;
  updateTaskInKanban: (task: Task) => void;

  // UI State
  selectedTask: Task | null;
  setSelectedTask: (task: Task | null) => void;
  isTaskModalOpen: boolean;
  openTaskModal: (task?: Task) => void;
  closeTaskModal: () => void;

  // Filters
  filters: {
    status?: string;
    priority?: string;
    executionPhase?: string;
    search?: string;
  };
  setFilters: (filters: Partial<ProjectState['filters']>) => void;
  clearFilters: () => void;
}

export const useProjectStore = create<ProjectState>((set, get) => ({
  // Current project
  currentProject: null,
  setCurrentProject: (project) => set({ currentProject: project }),

  // Kanban
  kanbanData: null,
  setKanbanData: (data) => set({ kanbanData: data }),
  updateTaskInKanban: (task) => {
    const { kanbanData } = get();
    if (!kanbanData) return;

    // Create new kanban data with updated task
    const newData = { ...kanbanData };

    // Remove task from all columns
    for (const status of Object.keys(newData) as Array<keyof KanbanData>) {
      newData[status] = newData[status].filter((t) => t.taskId !== task.taskId);
    }

    // Add task to correct column
    newData[task.status] = [...newData[task.status], task];

    set({ kanbanData: newData });
  },

  // UI State
  selectedTask: null,
  setSelectedTask: (task) => set({ selectedTask: task }),
  isTaskModalOpen: false,
  openTaskModal: (task) => set({ selectedTask: task || null, isTaskModalOpen: true }),
  closeTaskModal: () => set({ selectedTask: null, isTaskModalOpen: false }),

  // Filters
  filters: {},
  setFilters: (filters) => set((state) => ({ filters: { ...state.filters, ...filters } })),
  clearFilters: () => set({ filters: {} }),
}));

// App-wide UI state
interface UIState {
  sidebarOpen: boolean;
  toggleSidebar: () => void;
  setSidebarOpen: (open: boolean) => void;

  // Notifications
  notifications: Array<{
    id: string;
    type: 'success' | 'error' | 'info' | 'warning';
    message: string;
    duration?: number;
  }>;
  addNotification: (notification: Omit<UIState['notifications'][0], 'id'>) => void;
  removeNotification: (id: string) => void;
}

export const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
  setSidebarOpen: (open) => set({ sidebarOpen: open }),

  notifications: [],
  addNotification: (notification) => {
    const id = Math.random().toString(36).substr(2, 9);
    set((state) => ({
      notifications: [...state.notifications, { ...notification, id }],
    }));

    // Auto-remove after duration
    if (notification.duration !== 0) {
      setTimeout(() => {
        set((state) => ({
          notifications: state.notifications.filter((n) => n.id !== id),
        }));
      }, notification.duration || 5000);
    }
  },
  removeNotification: (id) =>
    set((state) => ({
      notifications: state.notifications.filter((n) => n.id !== id),
    })),
}));
