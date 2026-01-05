import { createApp } from './app.js';
import { config } from './config/index.js';
import { db } from './database/provider.js';

async function main() {
  try {
    // Connect to database
    console.log('Connecting to MongoDB...');
    await db.connect();
    console.log('Connected to MongoDB successfully');

    // Create and start server
    const app = createApp();

    app.listen(config.port, () => {
      console.log(`
╔════════════════════════════════════════════════════════════╗
║                     UF-PMS API Server                      ║
╠════════════════════════════════════════════════════════════╣
║  Environment: ${config.isDev ? 'Development' : 'Production'}                              ║
║  Port: ${config.port}                                             ║
║  API: http://localhost:${config.port}/api/v1                      ║
║  Health: http://localhost:${config.port}/health                   ║
╚════════════════════════════════════════════════════════════╝
      `);
    });

    // Graceful shutdown
    const shutdown = async (signal: string) => {
      console.log(`\n${signal} received. Shutting down gracefully...`);
      await db.close();
      console.log('Database disconnected');
      process.exit(0);
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));

  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

main();
