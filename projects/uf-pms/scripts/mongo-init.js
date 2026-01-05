// MongoDB initialization script
db = db.getSiblingDB('uf_pms');

// Create application user
db.createUser({
  user: 'uf_pms_user',
  pwd: 'uf_pms_pass',
  roles: [
    { role: 'readWrite', db: 'uf_pms' }
  ]
});

// Create collections with validation
db.createCollection('projects', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['name', 'slug', 'type', 'fidelityLevel', 'currentPhase', 'createdAt'],
      properties: {
        name: { bsonType: 'string', minLength: 1, maxLength: 200 },
        slug: { bsonType: 'string', pattern: '^[a-z0-9-]+$' },
        type: { enum: ['ui', 'api', 'algorithm', 'documentation', 'hybrid'] },
        fidelityLevel: { enum: ['prototype', 'functional', 'polished', 'realistic'] },
        currentPhase: { enum: ['define', 'decompose', 'prioritize', 'sequence', 'execute', 'review'] }
      }
    }
  }
});

db.createCollection('tasks', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['projectId', 'taskId', 'title', 'status', 'priority', 'executionPhase', 'createdAt'],
      properties: {
        taskId: { bsonType: 'string', pattern: '^TASK-[0-9]+$' },
        status: { enum: ['backlog', 'in_progress', 'review', 'blocked', 'done', 'skipped'] },
        priority: { enum: ['critical', 'high', 'medium', 'low'] },
        executionPhase: { enum: ['FOUNDATION', 'BUILD', 'ENHANCE', 'FINALIZE'] }
      }
    }
  }
});

db.createCollection('validations');
db.createCollection('handoffs');
db.createCollection('users');

// Create indexes
db.projects.createIndex({ slug: 1 }, { unique: true });
db.projects.createIndex({ type: 1, currentPhase: 1 });
db.projects.createIndex({ createdAt: -1 });

db.tasks.createIndex({ projectId: 1, taskId: 1 }, { unique: true });
db.tasks.createIndex({ projectId: 1, status: 1, priority: -1 });
db.tasks.createIndex({ projectId: 1, executionPhase: 1 });

print('Database initialized successfully!');
