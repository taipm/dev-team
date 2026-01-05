import { useState, useEffect } from 'react';
import { Modal, ModalFooter } from '../common/Modal';
import { Button } from '../common/Button';
import { StatusBadge, PriorityBadge, ExecutionPhaseBadge } from '../common/Badge';
import { useCreateTask, useUpdateTask, useDeleteTask } from '@/hooks/useTasks';
import { Trash2, Clock, GitBranch, CheckSquare, X } from 'lucide-react';
import type { Task, CreateTaskInput, UpdateTaskInput, TaskPriority, ExecutionPhase, TaskType } from '@/types';

interface TaskModalProps {
  isOpen: boolean;
  onClose: () => void;
  projectId: string;
  task?: Task | null;
}

const PRIORITIES: TaskPriority[] = ['critical', 'high', 'medium', 'low'];
const EXECUTION_PHASES: ExecutionPhase[] = ['FOUNDATION', 'BUILD', 'ENHANCE', 'FINALIZE'];
const TASK_TYPES: TaskType[] = ['analysis', 'design', 'code', 'test', 'documentation'];

export function TaskModal({ isOpen, onClose, projectId, task }: TaskModalProps) {
  const createTask = useCreateTask(projectId);
  const updateTask = useUpdateTask(projectId);
  const deleteTask = useDeleteTask(projectId);

  const isEditing = !!task;

  const [formData, setFormData] = useState({
    title: '',
    description: '',
    type: 'code' as TaskType,
    priority: 'medium' as TaskPriority,
    executionPhase: 'BUILD' as ExecutionPhase,
    estimatedHours: 0,
    labels: [] as string[],
    dependencies: [] as string[],
  });

  const [newLabel, setNewLabel] = useState('');

  // Populate form when editing
  useEffect(() => {
    if (task) {
      setFormData({
        title: task.title,
        description: task.description,
        type: task.type,
        priority: task.priority,
        executionPhase: task.executionPhase,
        estimatedHours: task.estimatedHours,
        labels: task.labels,
        dependencies: task.dependencies,
      });
    } else {
      setFormData({
        title: '',
        description: '',
        type: 'code',
        priority: 'medium',
        executionPhase: 'BUILD',
        estimatedHours: 0,
        labels: [],
        dependencies: [],
      });
    }
  }, [task]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (isEditing) {
      await updateTask.mutateAsync({
        taskId: task.taskId,
        input: {
          title: formData.title,
          description: formData.description,
          type: formData.type,
          priority: formData.priority,
          estimatedHours: formData.estimatedHours,
          labels: formData.labels,
          dependencies: formData.dependencies,
        } as UpdateTaskInput,
      });
    } else {
      await createTask.mutateAsync(formData as CreateTaskInput);
    }

    onClose();
  };

  const handleDelete = async () => {
    if (task && window.confirm('Are you sure you want to delete this task?')) {
      await deleteTask.mutateAsync(task.taskId);
      onClose();
    }
  };

  const addLabel = () => {
    if (newLabel && !formData.labels.includes(newLabel)) {
      setFormData((prev) => ({ ...prev, labels: [...prev.labels, newLabel] }));
      setNewLabel('');
    }
  };

  const removeLabel = (label: string) => {
    setFormData((prev) => ({
      ...prev,
      labels: prev.labels.filter((l) => l !== label),
    }));
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={isEditing ? `Edit Task: ${task?.taskId}` : 'Create New Task'}
      size="lg"
    >
      <form onSubmit={handleSubmit}>
        {/* Task info (when editing) */}
        {isEditing && task && (
          <div className="flex items-center gap-2 mb-4 pb-4 border-b">
            <StatusBadge status={task.status} />
            {task.blockedReason && (
              <span className="text-sm text-red-600">
                Blocked: {task.blockedReason}
              </span>
            )}
          </div>
        )}

        {/* Title */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Title *
          </label>
          <input
            type="text"
            value={formData.title}
            onChange={(e) => setFormData((prev) => ({ ...prev, title: e.target.value }))}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            required
          />
        </div>

        {/* Description */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Description
          </label>
          <textarea
            value={formData.description}
            onChange={(e) => setFormData((prev) => ({ ...prev, description: e.target.value }))}
            rows={3}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        {/* Row: Type, Priority, Execution Phase */}
        <div className="grid grid-cols-3 gap-4 mb-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Type
            </label>
            <select
              value={formData.type}
              onChange={(e) => setFormData((prev) => ({ ...prev, type: e.target.value as TaskType }))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              {TASK_TYPES.map((t) => (
                <option key={t} value={t}>
                  {t.charAt(0).toUpperCase() + t.slice(1)}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Priority
            </label>
            <select
              value={formData.priority}
              onChange={(e) => setFormData((prev) => ({ ...prev, priority: e.target.value as TaskPriority }))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              {PRIORITIES.map((p) => (
                <option key={p} value={p}>
                  {p.charAt(0).toUpperCase() + p.slice(1)}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Execution Phase
            </label>
            <select
              value={formData.executionPhase}
              onChange={(e) => setFormData((prev) => ({ ...prev, executionPhase: e.target.value as ExecutionPhase }))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              disabled={isEditing}
            >
              {EXECUTION_PHASES.map((p) => (
                <option key={p} value={p}>
                  {p}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Estimated Hours */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            <Clock className="w-4 h-4 inline mr-1" />
            Estimated Hours
          </label>
          <input
            type="number"
            value={formData.estimatedHours}
            onChange={(e) => setFormData((prev) => ({ ...prev, estimatedHours: Number(e.target.value) }))}
            min={0}
            step={0.5}
            className="w-32 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        {/* Labels */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Labels
          </label>
          <div className="flex flex-wrap gap-2 mb-2">
            {formData.labels.map((label) => (
              <span
                key={label}
                className="inline-flex items-center gap-1 px-2 py-1 bg-gray-100 text-gray-700 text-sm rounded"
              >
                {label}
                <button
                  type="button"
                  onClick={() => removeLabel(label)}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <X className="w-3 h-3" />
                </button>
              </span>
            ))}
          </div>
          <div className="flex gap-2">
            <input
              type="text"
              value={newLabel}
              onChange={(e) => setNewLabel(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addLabel())}
              placeholder="Add label..."
              className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
            <Button type="button" variant="outline" onClick={addLabel}>
              Add
            </Button>
          </div>
        </div>

        {/* Verification (when editing and has verify) */}
        {isEditing && task?.verify && (
          <div className="mb-4 p-3 bg-gray-50 rounded-lg">
            <h4 className="font-medium text-gray-700 mb-2 flex items-center gap-2">
              <CheckSquare className="w-4 h-4" />
              Verification Criteria
            </h4>
            <ul className="text-sm text-gray-600 space-y-1">
              {task.verify.criteria.map((c, i) => (
                <li key={i} className="flex items-start gap-2">
                  <span className="text-gray-400">-</span>
                  {c}
                </li>
              ))}
            </ul>
            <p className="mt-2 text-sm text-gray-500">
              <strong>Done when:</strong> {task.verify.doneWhen}
            </p>
          </div>
        )}

        {/* Footer */}
        <ModalFooter>
          {isEditing && (
            <Button
              type="button"
              variant="danger"
              onClick={handleDelete}
              isLoading={deleteTask.isPending}
            >
              <Trash2 className="w-4 h-4" />
              Delete
            </Button>
          )}
          <div className="flex-1" />
          <Button type="button" variant="outline" onClick={onClose}>
            Cancel
          </Button>
          <Button
            type="submit"
            isLoading={createTask.isPending || updateTask.isPending}
          >
            {isEditing ? 'Save Changes' : 'Create Task'}
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
