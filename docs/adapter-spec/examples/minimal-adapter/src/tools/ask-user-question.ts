/**
 * AskUserQuestion Tool
 * Công cụ hỏi người dùng
 *
 * Level 1 Compliance
 *
 * Note: This is a stub implementation. Real adapters need to
 * integrate with their platform's UI system to present questions.
 */

import * as readline from 'readline';
import { BaseTool } from '../tool-registry';
import { ToolResult, ValidationResult, AskUserQuestionParams, Question } from '../types';

export class AskUserQuestionTool extends BaseTool {
  name = 'AskUserQuestion';

  async execute(params: Record<string, unknown>): Promise<ToolResult> {
    const { questions } = params as AskUserQuestionParams;

    try {
      const answers: Record<string, string> = {};

      // In a real implementation, this would use the platform's UI
      // For CLI, we use readline
      const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
      });

      const askQuestion = (question: Question): Promise<string> => {
        return new Promise((resolve) => {
          console.log(`\n${question.header}: ${question.question}`);
          console.log('Options:');
          question.options.forEach((opt, i) => {
            console.log(`  ${i + 1}. ${opt.label} - ${opt.description}`);
          });

          rl.question('Enter choice number (or text for other): ', (answer) => {
            const num = parseInt(answer, 10);
            if (!isNaN(num) && num >= 1 && num <= question.options.length) {
              resolve(question.options[num - 1].label);
            } else {
              resolve(answer);
            }
          });
        });
      };

      for (const question of questions) {
        const answer = await askQuestion(question);
        answers[question.header] = answer;
      }

      rl.close();

      return this.success({ answers });
    } catch (error) {
      return this.error(`Failed to ask question: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  validate(params: Record<string, unknown>): ValidationResult {
    const { questions } = params as Partial<AskUserQuestionParams>;

    if (!questions) {
      return this.invalid('questions is required');
    }

    if (!Array.isArray(questions)) {
      return this.invalid('questions must be an array');
    }

    if (questions.length === 0) {
      return this.invalid('questions array cannot be empty');
    }

    if (questions.length > 4) {
      return this.invalid('questions array cannot have more than 4 items');
    }

    for (const question of questions) {
      if (!question.question) {
        return this.invalid('Each question must have a question field');
      }

      if (!question.header) {
        return this.invalid('Each question must have a header field');
      }

      if (!Array.isArray(question.options)) {
        return this.invalid('Each question must have an options array');
      }

      if (question.options.length < 2 || question.options.length > 4) {
        return this.invalid('Each question must have 2-4 options');
      }

      for (const option of question.options) {
        if (!option.label) {
          return this.invalid('Each option must have a label');
        }
        if (!option.description) {
          return this.invalid('Each option must have a description');
        }
      }
    }

    return this.valid();
  }
}
