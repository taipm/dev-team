import { Router, Request, Response } from 'express';
import { db } from '../database/provider.js';

export const healthRoutes = Router();

healthRoutes.get('/', (_req: Request, res: Response) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'uf-pms-api',
    version: '1.0.0',
  });
});

healthRoutes.get('/ready', async (_req: Request, res: Response) => {
  const dbHealthy = await db.ping();

  if (dbHealthy) {
    res.json({
      status: 'ready',
      database: 'connected',
      timestamp: new Date().toISOString(),
    });
  } else {
    res.status(503).json({
      status: 'not_ready',
      database: 'disconnected',
      timestamp: new Date().toISOString(),
    });
  }
});
