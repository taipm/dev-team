import clsx from 'clsx';
import { Check, Circle, Play } from 'lucide-react';
import type { PhaseProgress as PhaseProgressType, ProjectPhase } from '@/types';

interface PhaseProgressProps {
  phases: PhaseProgressType[];
  currentPhase: ProjectPhase;
}

const PHASE_ORDER: ProjectPhase[] = ['define', 'decompose', 'prioritize', 'sequence', 'execute', 'review'];

const phaseLabels: Record<ProjectPhase, string> = {
  define: 'Define',
  decompose: 'Decompose',
  prioritize: 'Prioritize',
  sequence: 'Sequence',
  execute: 'Execute',
  review: 'Review',
};

const phaseDescriptions: Record<ProjectPhase, string> = {
  define: 'Set objectives and key results',
  decompose: 'Break down into tasks',
  prioritize: 'Assign execution phases',
  sequence: 'Order by dependencies',
  execute: 'Complete all tasks',
  review: 'Validate and document',
};

export function PhaseProgress({ phases, currentPhase }: PhaseProgressProps) {
  const currentIndex = PHASE_ORDER.indexOf(currentPhase);

  return (
    <div className="relative">
      {/* Progress line */}
      <div className="absolute top-5 left-0 right-0 h-0.5 bg-gray-200">
        <div
          className="h-full bg-blue-500 transition-all duration-500"
          style={{ width: `${(currentIndex / (PHASE_ORDER.length - 1)) * 100}%` }}
        />
      </div>

      {/* Phase steps */}
      <div className="relative flex justify-between">
        {PHASE_ORDER.map((phase, index) => {
          const phaseData = phases.find((p) => p.phase === phase);
          const isCompleted = phaseData?.status === 'completed';
          const isCurrent = phase === currentPhase;
          const isPending = index > currentIndex;

          return (
            <div key={phase} className="flex flex-col items-center">
              {/* Circle */}
              <div
                className={clsx(
                  'w-10 h-10 rounded-full flex items-center justify-center transition-colors z-10',
                  isCompleted && 'bg-green-500 text-white',
                  isCurrent && 'bg-blue-500 text-white ring-4 ring-blue-100',
                  isPending && 'bg-gray-200 text-gray-400'
                )}
              >
                {isCompleted ? (
                  <Check className="w-5 h-5" />
                ) : isCurrent ? (
                  <Play className="w-4 h-4" />
                ) : (
                  <Circle className="w-4 h-4" />
                )}
              </div>

              {/* Label */}
              <div className="mt-3 text-center">
                <p
                  className={clsx(
                    'text-sm font-medium',
                    isCompleted && 'text-green-600',
                    isCurrent && 'text-blue-600',
                    isPending && 'text-gray-400'
                  )}
                >
                  {phaseLabels[phase]}
                </p>
                <p className="text-xs text-gray-400 mt-0.5 max-w-[100px]">
                  {phaseDescriptions[phase]}
                </p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
