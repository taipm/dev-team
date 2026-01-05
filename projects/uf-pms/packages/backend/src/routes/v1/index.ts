import { Router } from 'express';
import { projectRoutes } from './projects.routes.js';
import { taskRoutes } from './tasks.routes.js';
import { phaseRoutes } from './phases.routes.js';

export const v1Router = Router();

v1Router.use('/projects', projectRoutes);
v1Router.use('/projects/:projectId/tasks', taskRoutes);
v1Router.use('/projects/:projectId/phases', phaseRoutes);

// Info endpoint
v1Router.get('/', (_req, res) => {
  res.json({
    name: 'UF-PMS API',
    version: 'v1',
    endpoints: [
      'GET /api/v1/projects',
      'POST /api/v1/projects',
      'GET /api/v1/projects/:id',
      'PATCH /api/v1/projects/:id',
      'DELETE /api/v1/projects/:id',
      'GET /api/v1/projects/:id/handoff',
      'GET /api/v1/projects/:id/tasks',
      'POST /api/v1/projects/:id/tasks',
      'POST /api/v1/projects/:id/tasks/:taskId/move',
      'GET /api/v1/projects/:id/phases',
      'POST /api/v1/projects/:id/phases/:phase/complete',
    ],
  });
});
