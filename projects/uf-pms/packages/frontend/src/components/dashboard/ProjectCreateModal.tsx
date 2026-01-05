import { useState } from 'react';
import { Modal, ModalFooter } from '../common/Modal';
import { Button } from '../common/Button';
import { useCreateProject } from '@/hooks/useProjects';
import type { CreateProjectInput, ProjectType, FidelityLevel } from '@/types';

interface ProjectCreateModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const PROJECT_TYPES: { value: ProjectType; label: string; description: string }[] = [
  { value: 'ui', label: 'UI', description: 'Frontend/user interface project' },
  { value: 'api', label: 'API', description: 'Backend/API service' },
  { value: 'algorithm', label: 'Algorithm', description: 'Data processing/algorithm' },
  { value: 'documentation', label: 'Documentation', description: 'Technical documentation' },
  { value: 'hybrid', label: 'Hybrid', description: 'Full-stack application' },
];

const FIDELITY_LEVELS: { value: FidelityLevel; label: string; description: string }[] = [
  { value: 'prototype', label: 'Prototype', description: 'Quick validation, minimal polish' },
  { value: 'functional', label: 'Functional', description: 'Working product, basic styling' },
  { value: 'polished', label: 'Polished', description: 'Production-ready, good UX' },
  { value: 'realistic', label: 'Realistic', description: 'Full production quality' },
];

export function ProjectCreateModal({ isOpen, onClose }: ProjectCreateModalProps) {
  const createProject = useCreateProject();

  const [formData, setFormData] = useState<{
    name: string;
    description: string;
    type: ProjectType;
    fidelityLevel: FidelityLevel;
    objective: string;
    wipLimit: number;
  }>({
    name: '',
    description: '',
    type: 'hybrid',
    fidelityLevel: 'functional',
    objective: '',
    wipLimit: 3,
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const input: CreateProjectInput = {
      name: formData.name,
      description: formData.description,
      type: formData.type,
      fidelityLevel: formData.fidelityLevel,
      wipLimit: formData.wipLimit,
      okr: {
        objective: formData.objective,
        keyResults: [
          {
            id: 'kr-1',
            description: 'Define key result 1',
            metric: 'completion',
            baseline: null,
            target: 100,
            current: 0,
            unit: '%',
            verificationMethod: 'manual',
            status: 'not_started',
          },
        ],
      },
    };

    await createProject.mutateAsync(input);
    onClose();

    // Reset form
    setFormData({
      name: '',
      description: '',
      type: 'hybrid',
      fidelityLevel: 'functional',
      objective: '',
      wipLimit: 3,
    });
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Create New Project" size="lg">
      <form onSubmit={handleSubmit}>
        {/* Name */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Project Name *
          </label>
          <input
            type="text"
            value={formData.name}
            onChange={(e) => setFormData((prev) => ({ ...prev, name: e.target.value }))}
            placeholder="My Awesome Project"
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
            rows={2}
            placeholder="Brief description of the project..."
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
        </div>

        {/* Objective */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Objective (OKR) *
          </label>
          <textarea
            value={formData.objective}
            onChange={(e) => setFormData((prev) => ({ ...prev, objective: e.target.value }))}
            rows={2}
            placeholder="What is the main goal of this project?"
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            required
          />
        </div>

        {/* Type */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Project Type *
          </label>
          <div className="grid grid-cols-5 gap-2">
            {PROJECT_TYPES.map((type) => (
              <button
                key={type.value}
                type="button"
                onClick={() => setFormData((prev) => ({ ...prev, type: type.value }))}
                className={`p-3 text-center rounded-lg border-2 transition-colors ${
                  formData.type === type.value
                    ? 'border-blue-500 bg-blue-50 text-blue-700'
                    : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                <span className="block text-sm font-medium">{type.label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Fidelity Level */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Fidelity Level *
          </label>
          <div className="grid grid-cols-4 gap-2">
            {FIDELITY_LEVELS.map((level) => (
              <button
                key={level.value}
                type="button"
                onClick={() => setFormData((prev) => ({ ...prev, fidelityLevel: level.value }))}
                className={`p-3 text-center rounded-lg border-2 transition-colors ${
                  formData.fidelityLevel === level.value
                    ? 'border-blue-500 bg-blue-50 text-blue-700'
                    : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                <span className="block text-sm font-medium">{level.label}</span>
                <span className="block text-xs text-gray-500 mt-1">{level.description}</span>
              </button>
            ))}
          </div>
        </div>

        {/* WIP Limit */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            WIP Limit
          </label>
          <input
            type="number"
            value={formData.wipLimit}
            onChange={(e) => setFormData((prev) => ({ ...prev, wipLimit: Number(e.target.value) }))}
            min={1}
            max={10}
            className="w-24 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <p className="text-sm text-gray-500 mt-1">
            Maximum tasks in progress at once (1-10)
          </p>
        </div>

        <ModalFooter>
          <Button type="button" variant="outline" onClick={onClose}>
            Cancel
          </Button>
          <Button type="submit" isLoading={createProject.isPending}>
            Create Project
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
