export class AppError extends Error {
  public readonly code: string;
  public readonly statusCode: number;
  public readonly details?: Record<string, unknown>;
  public readonly isOperational: boolean;

  constructor(
    code: string,
    message: string,
    statusCode: number = 500,
    details?: Record<string, unknown>
  ) {
    super(message);
    this.code = code;
    this.statusCode = statusCode;
    this.details = details;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

// 400 Bad Request
export class ValidationError extends AppError {
  constructor(message: string, details?: Record<string, unknown>) {
    super('VALIDATION_ERROR', message, 400, details);
  }
}

// 404 Not Found
export class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super('NOT_FOUND', `${resource} not found: ${id}`, 404);
  }
}

// 409 Conflict
export class ConflictError extends AppError {
  constructor(message: string, details?: Record<string, unknown>) {
    super('CONFLICT', message, 409, details);
  }
}

// 401 Unauthorized
export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super('UNAUTHORIZED', message, 401);
  }
}

// 403 Forbidden
export class ForbiddenError extends AppError {
  constructor(message: string = 'Access denied') {
    super('FORBIDDEN', message, 403);
  }
}

// Business Logic Errors
export class WIPLimitError extends AppError {
  constructor(current: number, limit: number) {
    super('WIP_LIMIT_EXCEEDED', `WIP limit reached (${current}/${limit})`, 400, {
      current,
      limit,
    });
  }
}

export class DependencyError extends AppError {
  constructor(taskId: string, blockedBy: string[]) {
    super('DEPENDENCIES_NOT_MET', `Task ${taskId} has unmet dependencies`, 400, {
      blockedBy,
    });
  }
}

export class PhaseValidationError extends AppError {
  constructor(phase: string, failedChecks: { name: string; message: string }[]) {
    super('VALIDATION_GATE_FAILED', `Phase ${phase} validation failed`, 400, {
      phase,
      failedChecks,
    });
  }
}

export class InvalidTransitionError extends AppError {
  constructor(from: string, to: string) {
    super('INVALID_TRANSITION', `Cannot transition from ${from} to ${to}`, 400, {
      from,
      to,
    });
  }
}
