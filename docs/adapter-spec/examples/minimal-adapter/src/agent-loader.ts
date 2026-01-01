/**
 * Agent Loader
 * Bộ load Agent
 *
 * Level 1 Compliance: Parse YAML frontmatter, load agent body
 * Level 2 Compliance: Load knowledge and memory
 */

import * as fs from 'fs';
import * as path from 'path';
import * as yaml from 'js-yaml';
import { Agent, AgentFrontmatter } from './types';
import { ReferenceResolver } from './reference-resolver';

export class AgentLoader {
  private projectRoot: string;
  private resolver: ReferenceResolver;

  constructor(projectRoot: string, resolver: ReferenceResolver) {
    this.projectRoot = projectRoot;
    this.resolver = resolver;
  }

  /**
   * Discover all agents in .microai/agents/
   * Khám phá tất cả agent trong .microai/agents/
   */
  async discover(): Promise<Agent[]> {
    const agentsDir = path.join(this.projectRoot, '.microai', 'agents');

    if (!fs.existsSync(agentsDir)) {
      return [];
    }

    const agents: Agent[] = [];
    await this.scanDirectory(agentsDir, agents);
    return agents;
  }

  /**
   * Load a single agent from file path
   * Load một agent từ đường dẫn file
   */
  async load(agentPath: string): Promise<Agent> {
    const content = await fs.promises.readFile(agentPath, 'utf-8');
    const { frontmatter, body } = this.parseAgentFile(content);

    return {
      name: frontmatter.name,
      description: frontmatter.description,
      model: frontmatter.model,
      tools: frontmatter.tools,
      language: frontmatter.language,
      permissionMode: frontmatter.permissionMode,
      skills: frontmatter.skills,
      body,
      path: agentPath
    };
  }

  /**
   * Activate an agent and return full prompt
   * Kích hoạt agent và trả về prompt đầy đủ
   *
   * Activation steps:
   * 1. Load agent body
   * 2. Expand @-references
   * 3. Load knowledge (Level 2)
   * 4. Load memory (Level 2)
   */
  async activate(agent: Agent): Promise<string> {
    let prompt = agent.body;

    // Expand @-references in agent body
    prompt = await this.resolver.expandReferences(prompt);

    // Load knowledge if available (Level 2)
    const agentDir = path.dirname(agent.path);
    const knowledgeDir = path.join(agentDir, 'knowledge');
    if (fs.existsSync(knowledgeDir)) {
      const knowledge = await this.loadKnowledge(knowledgeDir, prompt);
      if (knowledge) {
        prompt = knowledge + '\n\n---\n\n' + prompt;
      }
    }

    // Load memory if available (Level 2)
    const memoryDir = path.join(agentDir, 'memory');
    if (fs.existsSync(memoryDir)) {
      const memory = await this.loadMemory(memoryDir);
      if (memory) {
        prompt = memory + '\n\n---\n\n' + prompt;
      }
    }

    return prompt;
  }

  /**
   * Parse agent file with YAML frontmatter
   * Parse file agent với YAML frontmatter
   */
  private parseAgentFile(content: string): { frontmatter: AgentFrontmatter; body: string } {
    const frontmatterRegex = /^---\n([\s\S]*?)\n---\n([\s\S]*)$/;
    const match = content.match(frontmatterRegex);

    if (!match) {
      throw new Error('Invalid agent file: missing YAML frontmatter');
    }

    const frontmatter = yaml.load(match[1]) as AgentFrontmatter;
    const body = match[2].trim();

    // Validate required fields
    if (!frontmatter.name) {
      throw new Error('Agent frontmatter missing required field: name');
    }
    if (!frontmatter.description) {
      throw new Error('Agent frontmatter missing required field: description');
    }

    return { frontmatter, body };
  }

  /**
   * Scan directory for agents recursively
   * Quét thư mục tìm agent đệ quy
   */
  private async scanDirectory(dir: string, agents: Agent[]): Promise<void> {
    const entries = await fs.promises.readdir(dir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);

      if (entry.isDirectory()) {
        // Check for agent.md in subdirectory
        const agentPath = path.join(fullPath, 'agent.md');
        if (fs.existsSync(agentPath)) {
          try {
            const agent = await this.load(agentPath);
            agents.push(agent);
          } catch (error) {
            console.warn(`Failed to load agent at ${agentPath}:`, error);
          }
        }

        // Recursively scan (but skip special directories)
        if (!['knowledge', 'memory', 'sessions', 'team-memory'].includes(entry.name)) {
          await this.scanDirectory(fullPath, agents);
        }
      } else if (entry.name.endsWith('.md') && entry.name !== 'agent.md') {
        // Standalone agent file
        try {
          const agent = await this.load(fullPath);
          agents.push(agent);
        } catch (error) {
          // Not all .md files are agents, ignore parse errors
        }
      }
    }
  }

  /**
   * Load knowledge files (Level 2)
   * Load các file knowledge
   */
  private async loadKnowledge(knowledgeDir: string, _task: string): Promise<string | null> {
    // Check for knowledge-index.yaml
    const indexPath = path.join(knowledgeDir, 'knowledge-index.yaml');

    if (fs.existsSync(indexPath)) {
      // Level 2: Selective loading based on keywords
      // For minimal adapter, just load core files
      const indexContent = await fs.promises.readFile(indexPath, 'utf-8');
      const index = yaml.load(indexContent) as {
        core_files?: string[];
        knowledge?: Array<{ file: string }>;
      };

      const filesToLoad = index.core_files || [];
      const contents: string[] = [];

      for (const file of filesToLoad) {
        const filePath = path.join(knowledgeDir, file);
        if (fs.existsSync(filePath)) {
          const content = await fs.promises.readFile(filePath, 'utf-8');
          contents.push(`## ${file}\n\n${content}`);
        }
      }

      return contents.length > 0 ? contents.join('\n\n---\n\n') : null;
    }

    return null;
  }

  /**
   * Load memory files (Level 2)
   * Load các file memory
   */
  private async loadMemory(memoryDir: string): Promise<string | null> {
    const sections: string[] = [];

    // Load context.md
    const contextPath = path.join(memoryDir, 'context.md');
    if (fs.existsSync(contextPath)) {
      const content = await fs.promises.readFile(contextPath, 'utf-8');
      sections.push(`## Current Context\n\n${content}`);
    }

    // Load recent decisions from decisions.md
    const decisionsPath = path.join(memoryDir, 'decisions.md');
    if (fs.existsSync(decisionsPath)) {
      const content = await fs.promises.readFile(decisionsPath, 'utf-8');
      // Get last 10 decisions
      const decisions = content.split(/\n---\n/).filter(d => d.trim());
      const recentDecisions = decisions.slice(-10);
      if (recentDecisions.length > 0) {
        sections.push(`## Recent Decisions\n\n${recentDecisions.join('\n\n---\n\n')}`);
      }
    }

    return sections.length > 0 ? sections.join('\n\n') : null;
  }
}
