import axios, { AxiosInstance, AxiosError } from 'axios';
import type {
  Project,
  Task,
  CreateProjectInput,
  UpdateProjectInput,
  CreateTaskInput,
  UpdateTaskInput,
  MoveTaskInput,
  ApiResponse,
  PaginatedResponse,
  KanbanData,
  PhaseValidation,
  ProjectPhase,
} from '@/types';

const API_BASE_URL = '/api/v1';

class ApiService {
  private client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      headers: {
        'Content-Type': 'application/json',
      },
    });

    // Response interceptor for error handling
    this.client.interceptors.response.use(
      (response) => response,
      (error: AxiosError) => {
        const message = (error.response?.data as { error?: { message?: string } })?.error?.message
          || error.message
          || 'An error occurred';
        console.error('API Error:', message);
        return Promise.reject(new Error(message));
      }
    );
  }

  // Projects
  async listProjects(params?: {
    page?: number;
    limit?: number;
    type?: string;
    search?: string;
    archived?: boolean;
  }): Promise<PaginatedResponse<Project>> {
    const { data } = await this.client.get('/projects', { params });
    return data;
  }

  async getProject(id: string): Promise<ApiResponse<Project>> {
    const { data } = await this.client.get(`/projects/${id}`);
    return data;
  }

  async createProject(input: CreateProjectInput): Promise<ApiResponse<Project>> {
    const { data } = await this.client.post('/projects', input);
    return data;
  }

  async updateProject(id: string, input: UpdateProjectInput): Promise<ApiResponse<Project>> {
    const { data } = await this.client.patch(`/projects/${id}`, input);
    return data;
  }

  async deleteProject(id: string): Promise<void> {
    await this.client.delete(`/projects/${id}`);
  }

  async archiveProject(id: string): Promise<ApiResponse<Project>> {
    const { data } = await this.client.post(`/projects/${id}/archive`);
    return data;
  }

  async getHandoff(id: string, format?: 'json' | 'file'): Promise<string> {
    const { data } = await this.client.get(`/projects/${id}/handoff`, {
      params: { format },
      responseType: format === 'file' ? 'text' : 'json',
    });
    return format === 'file' ? data : data.data.content;
  }

  // Tasks
  async listTasks(
    projectId: string,
    params?: {
      page?: number;
      limit?: number;
      status?: string;
      priority?: string;
      executionPhase?: string;
      search?: string;
    }
  ): Promise<PaginatedResponse<Task>> {
    const { data } = await this.client.get(`/projects/${projectId}/tasks`, { params });
    return data;
  }

  async getTasksKanban(projectId: string): Promise<ApiResponse<KanbanData>> {
    const { data } = await this.client.get(`/projects/${projectId}/tasks`, {
      params: { view: 'kanban' },
    });
    return data;
  }

  async getTask(projectId: string, taskId: string): Promise<ApiResponse<Task>> {
    const { data } = await this.client.get(`/projects/${projectId}/tasks/${taskId}`);
    return data;
  }

  async createTask(projectId: string, input: CreateTaskInput): Promise<ApiResponse<Task>> {
    const { data } = await this.client.post(`/projects/${projectId}/tasks`, input);
    return data;
  }

  async updateTask(
    projectId: string,
    taskId: string,
    input: UpdateTaskInput
  ): Promise<ApiResponse<Task>> {
    const { data } = await this.client.patch(`/projects/${projectId}/tasks/${taskId}`, input);
    return data;
  }

  async moveTask(
    projectId: string,
    taskId: string,
    input: MoveTaskInput
  ): Promise<ApiResponse<Task>> {
    const { data } = await this.client.post(`/projects/${projectId}/tasks/${taskId}/move`, input);
    return data;
  }

  async deleteTask(projectId: string, taskId: string): Promise<void> {
    await this.client.delete(`/projects/${projectId}/tasks/${taskId}`);
  }

  async getTaskDependencies(
    projectId: string,
    taskId: string
  ): Promise<ApiResponse<{
    task: Task;
    blockedBy: Task[];
    blocks: Task[];
    canStart: boolean;
  }>> {
    const { data } = await this.client.get(`/projects/${projectId}/tasks/${taskId}/dependencies`);
    return data;
  }

  // Phases
  async getPhases(projectId: string): Promise<ApiResponse<{
    currentPhase: ProjectPhase;
    phases: Array<{
      phase: ProjectPhase;
      status: string;
      canTransition: boolean;
      isComplete: boolean;
      isCurrent: boolean;
    }>;
  }>> {
    const { data } = await this.client.get(`/projects/${projectId}/phases`);
    return data;
  }

  async validatePhase(projectId: string, phase: ProjectPhase): Promise<ApiResponse<PhaseValidation>> {
    const { data } = await this.client.get(`/projects/${projectId}/phases/${phase}/validate`);
    return data;
  }

  async completePhase(
    projectId: string,
    phase: ProjectPhase,
    options?: { validationOverride?: boolean; notes?: string }
  ): Promise<ApiResponse<{
    previousPhase: ProjectPhase;
    currentPhase: ProjectPhase;
    project: Project;
  }>> {
    const { data } = await this.client.post(`/projects/${projectId}/phases/${phase}/complete`, options);
    return data;
  }

  async autoPrioritize(projectId: string): Promise<ApiResponse<{
    distribution: Array<{
      phase: string;
      taskCount: number;
      hours: number;
      percentage: number;
      tasks: Array<{ taskId: string; title: string }>;
    }>;
    totalTasks: number;
    totalHours: number;
  }>> {
    const { data } = await this.client.post(`/projects/${projectId}/phases/prioritize/auto`);
    return data;
  }

  async autoSequence(projectId: string): Promise<ApiResponse<{
    sequence: Array<{
      step: number;
      tasks: string[];
      parallel: boolean;
      hours: number;
    }>;
    criticalPath: {
      tasks: string[];
      totalHours: number;
    };
    parallelSavings: {
      sequentialHours: number;
      parallelHours: number;
      hoursSaved: number;
      efficiencyGain: string;
    };
    milestones: Array<{
      name: string;
      afterStep: number;
    }>;
  }>> {
    const { data } = await this.client.post(`/projects/${projectId}/phases/sequence/auto`);
    return data;
  }
}

export const api = new ApiService();
