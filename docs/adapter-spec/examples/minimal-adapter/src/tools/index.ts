/**
 * Tools Index
 * Export all tools
 */

export { ReadTool } from './read';
export { WriteTool } from './write';
export { EditTool } from './edit';
export { GlobTool } from './glob';
export { GrepTool } from './grep';
export { BashTool } from './bash';
export { AskUserQuestionTool } from './ask-user-question';

import { Tool } from '../types';
import { ReadTool } from './read';
import { WriteTool } from './write';
import { EditTool } from './edit';
import { GlobTool } from './glob';
import { GrepTool } from './grep';
import { BashTool } from './bash';
import { AskUserQuestionTool } from './ask-user-question';

/**
 * Create all core tools
 * Tạo tất cả công cụ lõi
 *
 * Level 1: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
 */
export function createCoreTools(): Tool[] {
  return [
    new ReadTool(),
    new WriteTool(),
    new EditTool(),
    new GlobTool(),
    new GrepTool(),
    new BashTool(),
    new AskUserQuestionTool()
  ];
}
