import { MongoClient, Db, Collection, Document } from 'mongodb';
import { config } from '../config/index.js';

class DatabaseProvider {
  private client: MongoClient | null = null;
  private database: Db | null = null;
  private static instance: DatabaseProvider;

  private constructor() {}

  static getInstance(): DatabaseProvider {
    if (!DatabaseProvider.instance) {
      DatabaseProvider.instance = new DatabaseProvider();
    }
    return DatabaseProvider.instance;
  }

  async connect(): Promise<void> {
    if (this.client) {
      console.log('Database already connected');
      return;
    }

    try {
      this.client = new MongoClient(config.mongodb.uri);
      await this.client.connect();
      this.database = this.client.db(config.mongodb.dbName);
      console.log(`Connected to MongoDB: ${config.mongodb.dbName}`);
    } catch (error) {
      console.error('Failed to connect to MongoDB:', error);
      throw error;
    }
  }

  getDb(): Db {
    if (!this.database) {
      throw new Error('Database not connected. Call connect() first.');
    }
    return this.database;
  }

  collection<T extends Document>(name: string): Collection<T> {
    return this.getDb().collection<T>(name);
  }

  async close(): Promise<void> {
    if (this.client) {
      await this.client.close();
      this.client = null;
      this.database = null;
      console.log('Database connection closed');
    }
  }

  async ping(): Promise<boolean> {
    try {
      await this.getDb().command({ ping: 1 });
      return true;
    } catch {
      return false;
    }
  }
}

export const db = DatabaseProvider.getInstance();

// Collection accessors
export const collections = {
  projects: () => db.collection('projects'),
  tasks: () => db.collection('tasks'),
  validations: () => db.collection('validations'),
  handoffs: () => db.collection('handoffs'),
  users: () => db.collection('users'),
};
