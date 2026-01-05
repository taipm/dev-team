import { WithId } from 'mongodb';
import { Project, Task, ExecutionPhase } from '../models/interfaces/index.js';
import { projectService } from './project.service.js';
import { taskService } from './task.service.js';

export interface HandoffDocument {
  content: string;
  generatedAt: Date;
  projectId: string;
  version: string;
}

const EXECUTION_PHASE_ORDER: ExecutionPhase[] = ['FOUNDATION', 'BUILD', 'ENHANCE', 'FINALIZE'];

export class HandoffService {
  async generate(projectId: string): Promise<HandoffDocument> {
    const project = await projectService.getById(projectId);
    const { tasks } = await taskService.list(projectId, { limit: 500 });

    const content = this.buildHandoffContent(project, tasks);

    return {
      content,
      generatedAt: new Date(),
      projectId: project._id.toString(),
      version: '2.1',
    };
  }

  private buildHandoffContent(project: WithId<Project>, tasks: WithId<Task>[]): string {
    const sections: string[] = [];

    // Header
    sections.push(this.buildHeader(project));

    // Project Metadata
    sections.push(this.buildMetadata(project));

    // OKR Section
    sections.push(this.buildOKRSection(project));

    // Execution Summary
    sections.push(this.buildExecutionSummary(project, tasks));

    // Tasks by Execution Phase
    sections.push(this.buildTasksByPhase(tasks));

    // Metrics
    sections.push(this.buildMetrics(project));

    // Validation Status
    sections.push(this.buildValidationStatus(project));

    // Footer
    sections.push(this.buildFooter());

    return sections.join('\n\n');
  }

  private buildHeader(project: WithId<Project>): string {
    return `# HANDOFF: ${project.name}

> Universal Framework v2.1 - Complete Execution Philosophy
> Generated: ${new Date().toISOString()}
> Status: ${project.currentPhase.toUpperCase()} PHASE

---`;
  }

  private buildMetadata(project: WithId<Project>): string {
    return `## Project Metadata

| Property | Value |
|----------|-------|
| **Name** | ${project.name} |
| **Slug** | ${project.slug} |
| **Type** | ${project.type.toUpperCase()} |
| **Fidelity** | ${project.fidelityLevel} |
| **Current Phase** | ${project.currentPhase} |
| **WIP Limit** | ${project.wipLimit} |
| **Created** | ${project.createdAt.toISOString()} |
${project.deadline ? `| **Deadline** | ${project.deadline.toISOString()} |` : ''}`;
  }

  private buildOKRSection(project: WithId<Project>): string {
    const krRows = project.okr.keyResults.map((kr, i) => {
      const progress = kr.target > 0 ? Math.round((kr.current / kr.target) * 100) : 0;
      const statusEmoji = {
        completed: '✅',
        on_track: '🟢',
        in_progress: '🔵',
        at_risk: '🟡',
        not_started: '⚪',
      }[kr.status] || '⚪';

      return `| KR${i + 1} | ${kr.description} | ${kr.current}/${kr.target} ${kr.unit} | ${progress}% ${statusEmoji} |`;
    });

    return `## OKR (Objectives & Key Results)

### Objective
> ${project.okr.objective}

### Key Results
| ID | Description | Progress | Status |
|----|-------------|----------|--------|
${krRows.join('\n')}

${project.okr.speedOfLight ? `
### Speed of Light (Total Capacity)
- **Total**: ${project.okr.speedOfLight.value} ${project.okr.speedOfLight.unit}
- **Breakdown**:
${project.okr.speedOfLight.breakdown.map(b => `  - ${b.item}: ${b.hours}h`).join('\n')}
` : ''}

${project.okr.constraints ? `
### Constraints
${project.okr.constraints.time ? `- **Time**: ${project.okr.constraints.time}` : ''}
${project.okr.constraints.resources ? `- **Resources**: ${project.okr.constraints.resources}` : ''}
${project.okr.constraints.technology ? `- **Technology**: ${project.okr.constraints.technology}` : ''}
` : ''}`;
  }

  private buildExecutionSummary(project: WithId<Project>, tasks: WithId<Task>[]): string {
    const totalTasks = tasks.length;
    const completedTasks = tasks.filter(t => t.status === 'done').length;
    const totalEstimated = tasks.reduce((sum, t) => sum + t.estimatedHours, 0);
    const totalActual = tasks.reduce((sum, t) => sum + t.actualHours, 0);

    const phaseDistribution = EXECUTION_PHASE_ORDER.map(phase => {
      const phaseTasks = tasks.filter(t => t.executionPhase === phase);
      const completed = phaseTasks.filter(t => t.status === 'done').length;
      return {
        phase,
        total: phaseTasks.length,
        completed,
        hours: phaseTasks.reduce((sum, t) => sum + t.estimatedHours, 0),
      };
    });

    return `## Execution Summary

### Progress Overview
- **Total Tasks**: ${totalTasks}
- **Completed**: ${completedTasks} (${Math.round((completedTasks / totalTasks) * 100)}%)
- **In Progress**: ${project.metrics.currentWip}
- **Blocked**: ${project.metrics.blockedCount}

### Time Tracking
- **Estimated**: ${totalEstimated}h
- **Actual**: ${totalActual}h
- **Variance**: ${totalActual - totalEstimated}h (${totalEstimated > 0 ? Math.round(((totalActual - totalEstimated) / totalEstimated) * 100) : 0}%)

### Phase Distribution (30/30/25/15)
| Phase | Tasks | Completed | Hours | Target % |
|-------|-------|-----------|-------|----------|
| FOUNDATION | ${phaseDistribution[0].total} | ${phaseDistribution[0].completed} | ${phaseDistribution[0].hours}h | 30% |
| BUILD | ${phaseDistribution[1].total} | ${phaseDistribution[1].completed} | ${phaseDistribution[1].hours}h | 30% |
| ENHANCE | ${phaseDistribution[2].total} | ${phaseDistribution[2].completed} | ${phaseDistribution[2].hours}h | 25% |
| FINALIZE | ${phaseDistribution[3].total} | ${phaseDistribution[3].completed} | ${phaseDistribution[3].hours}h | 15% |`;
  }

  private buildTasksByPhase(tasks: WithId<Task>[]): string {
    const phaseBlocks = EXECUTION_PHASE_ORDER.map(phase => {
      const phaseTasks = tasks.filter(t => t.executionPhase === phase);

      if (phaseTasks.length === 0) {
        return `### ${phase}\n*No tasks in this phase*`;
      }

      const taskRows = phaseTasks.map(t => {
        const statusEmoji = {
          done: '✅',
          in_progress: '🔵',
          review: '🟡',
          blocked: '🔴',
          backlog: '⚪',
          skipped: '⏭️',
        }[t.status];

        return `| ${t.taskId} | ${t.title.substring(0, 50)}${t.title.length > 50 ? '...' : ''} | ${t.priority} | ${statusEmoji} ${t.status} | ${t.estimatedHours}h |`;
      });

      return `### ${phase}

| Task ID | Title | Priority | Status | Hours |
|---------|-------|----------|--------|-------|
${taskRows.join('\n')}`;
    });

    return `## Tasks by Execution Phase

${phaseBlocks.join('\n\n')}`;
  }

  private buildMetrics(project: WithId<Project>): string {
    return `## Metrics

| Metric | Value |
|--------|-------|
| Total Tasks Created | ${project.metrics.totalTasksCreated} |
| Total Tasks Completed | ${project.metrics.totalTasksCompleted} |
| Current WIP | ${project.metrics.currentWip} |
| Blocked Count | ${project.metrics.blockedCount} |
| Avg Cycle Time | ${project.metrics.avgCycleTimeHours}h |
| 7-Day Throughput | ${project.metrics.throughput7d} tasks |
| Total Estimated Hours | ${project.metrics.totalEstimatedHours}h |
| Total Actual Hours | ${project.metrics.totalActualHours}h |`;
  }

  private buildValidationStatus(project: WithId<Project>): string {
    const phaseStatus = project.phases.map(p => {
      const emoji = {
        completed: '✅',
        in_progress: '🔵',
        pending: '⚪',
      }[p.status];

      return `| ${p.phase} | ${emoji} ${p.status} | ${p.tasksCompleted}/${p.tasksTotal} | ${p.hoursActual}/${p.hoursEstimated}h |`;
    });

    return `## Phase Status

| Phase | Status | Tasks | Hours |
|-------|--------|-------|-------|
${phaseStatus.join('\n')}`;
  }

  private buildFooter(): string {
    return `---

## Appendix

### Universal Framework v2.1 Principles
1. **Complete Execution**: Every identified task is implemented
2. **No MVP Filtering**: Quality over speed
3. **Type-Aware Processing**: Tailored workflows per project type
4. **Phase Distribution**: 30/30/25/15 for balanced execution
5. **Validation Gates**: Pre/Post execution verification

### Generation Info
- **Generator**: UF-PMS HANDOFF Service
- **Version**: 2.1
- **Format**: Markdown

---
*This document was automatically generated. Validate all information before use.*`;
  }
}

export const handoffService = new HandoffService();
