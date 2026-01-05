import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/errors.js';
import { sendError } from '../utils/response.js';
import { config } from '../config/index.js';

export function errorHandler(
  err: Error,
  req: Request,
  res: Response,
  _next: NextFunction
): void {
  console.error('Error:', err.message);
  if (config.isDev) {
    console.error(err.stack);
  }

  // Operational errors (known errors)
  if (err instanceof AppError && err.isOperational) {
    sendError(res, err.code, err.message, err.statusCode, err.details);
    return;
  }

  // MongoDB duplicate key error
  if ((err as any).code === 11000) {
    sendError(res, 'DUPLICATE_KEY', 'Resource already exists', 409, (err as any).keyValue);
    return;
  }

  // MongoDB validation error
  if (err.name === 'ValidationError') {
    sendError(res, 'VALIDATION_ERROR', 'Database validation failed', 400);
    return;
  }

  // Zod validation error
  if (err.name === 'ZodError') {
    sendError(res, 'VALIDATION_ERROR', 'Invalid request data', 400, {
      issues: (err as any).issues,
    });
    return;
  }

  // Unknown errors - don't expose details in production
  sendError(
    res,
    'INTERNAL_ERROR',
    config.isDev ? err.message : 'An unexpected error occurred',
    500
  );
}

export function notFoundHandler(req: Request, res: Response): void {
  sendError(res, 'NOT_FOUND', `Route not found: ${req.method} ${req.path}`, 404);
}
