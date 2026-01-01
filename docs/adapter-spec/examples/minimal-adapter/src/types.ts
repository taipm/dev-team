/**
 * MicroAI Adapter Type Definitions
 * Định nghĩa kiểu cho MicroAI Adapter
 *
 * Level 1 Compliance Types
 */

// ============================================================================
// Settings Types | Kiểu cấu hình
// ============================================================================

export interface MicroAISettings {
  permissions: PermissionsConfig;
  enabledPlugins?: Record<string, boolean>;
  mcpServers?: Record<string, MCPServerConfig>;
  hooks?: HooksConfig;
  model?: ModelConfig;
}

export interface PermissionsConfig {
  allow: string[];
  deny: string[];
}

export interface MCPServerConfig {
  command: string;
  args?: string[];
  env?: Record<string, string>;
}

export interface HooksConfig {
  PreToolUse?: HookEntry[];
  PostToolUse?: HookEntry[];
  UserPromptSubmit?: HookEntry[];
  SessionStart?: HookEntry[];
  SessionEnd?: HookEntry[];
}

export interface HookEntry {
  matcher?: string;
  command: string;
  timeout?: number;
  continueOnFailure?: boolean;
}

export interface ModelConfig {
  default?: 'opus' | 'sonnet' | 'haiku';
  maxTokens?: number;
}

// ============================================================================
// Tool Types | Kiểu công cụ
// ============================================================================

export interface Tool {
  name: string;
  execute(params: Record<string, unknown>): Promise<ToolResult>;
  validate(params: Record<string, unknown>): ValidationResult;
}

export interface ToolResult {
  success: boolean;
  data?: unknown;
  error?: string;
}

export interface ValidationResult {
  valid: boolean;
  error?: string;
}

// Tool-specific parameter types
export interface ReadParams {
  file_path: string;
  offset?: number;
  limit?: number;
}

export interface WriteParams {
  file_path: string;
  content: string;
}

export interface EditParams {
  file_path: string;
  old_string: string;
  new_string: string;
  replace_all?: boolean;
}

export interface GlobParams {
  pattern: string;
  path?: string;
}

export interface GrepParams {
  pattern: string;
  path?: string;
  glob?: string;
  output_mode?: 'content' | 'files_with_matches' | 'count';
  '-i'?: boolean;
  '-n'?: boolean;
  '-A'?: number;
  '-B'?: number;
  '-C'?: number;
}

export interface BashParams {
  command: string;
  timeout?: number;
  cwd?: string;
}

export interface AskUserQuestionParams {
  questions: Question[];
}

export interface Question {
  question: string;
  header: string;
  options: QuestionOption[];
  multiSelect?: boolean;
}

export interface QuestionOption {
  label: string;
  description: string;
}

// ============================================================================
// Agent Types | Kiểu Agent
// ============================================================================

export interface Agent {
  name: string;
  description: string;
  model?: 'opus' | 'sonnet' | 'haiku';
  tools?: string[];
  language?: 'en' | 'vi';
  permissionMode?: string;
  skills?: string[];
  body: string;
  path: string;
}

export interface AgentFrontmatter {
  name: string;
  description: string;
  model?: 'opus' | 'sonnet' | 'haiku';
  tools?: string[];
  language?: 'en' | 'vi';
  permissionMode?: string;
  skills?: string[];
}

// ============================================================================
// Command Types | Kiểu Command
// ============================================================================

export interface Command {
  name: string;
  namespace: string;
  description: string;
  argumentHint?: string;
  body: string;
  path: string;
}

export interface CommandFrontmatter {
  name: string;
  description: string;
  'argument-hint'?: string;
}

// ============================================================================
// Permission Types | Kiểu quyền
// ============================================================================

export interface PermissionResult {
  allowed: boolean;
  reason: string;
}

// ============================================================================
// Context Types | Kiểu context
// ============================================================================

export interface ExecutionContext {
  projectRoot: string;
  userHome: string;
  platform: string;
  sessionId: string;
  timestamp: string;
  userName?: string;
  agentName?: string;
}

// ============================================================================
// Reference Types | Kiểu tham chiếu
// ============================================================================

export type ReferenceType = 'microai' | 'project' | 'home' | 'absolute';

export interface ResolvedReference {
  type: ReferenceType;
  originalRef: string;
  absolutePath: string;
}
