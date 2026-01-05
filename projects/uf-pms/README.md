# UF-PMS (Universal Framework Project Management System)

A centralized project management web application following the Universal Framework v2.1 methodology.

## Features

- **6-Phase Project Lifecycle**: Define → Decompose → Prioritize → Sequence → Execute → Review
- **Kanban Board**: Visual task management with drag-and-drop
- **OKR Tracking**: Objectives and Key Results management
- **Execution Phase Distribution**: 30/30/25/15 (FOUNDATION/BUILD/ENHANCE/FINALIZE)
- **WIP Limits**: Control work-in-progress to prevent overload
- **HANDOFF Generation**: Automated project documentation

## Tech Stack

- **Frontend**: React 18 + TypeScript + Vite + Tailwind CSS
- **Backend**: Node.js + Express + TypeScript
- **Database**: MongoDB 7.0
- **State**: Zustand + TanStack Query
- **DnD**: @dnd-kit

## Quick Start

### Prerequisites

- Node.js 20+
- Docker & Docker Compose
- npm 10+

### Installation

```bash
# Clone and navigate to project
cd projects/uf-pms

# Install dependencies
npm install

# Start MongoDB
npm run db:up

# Start development servers
npm run dev
```

### URLs

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3001/api/v1
- **Health Check**: http://localhost:3001/health

## Project Structure

```
uf-pms/
├── packages/
│   ├── backend/           # Express API
│   │   ├── src/
│   │   │   ├── config/    # Configuration
│   │   │   ├── database/  # MongoDB provider
│   │   │   ├── models/    # TypeScript interfaces
│   │   │   ├── routes/    # API routes
│   │   │   ├── services/  # Business logic
│   │   │   └── utils/     # Helpers
│   │   └── package.json
│   │
│   └── frontend/          # React App
│       ├── src/
│       │   ├── components/  # UI components
│       │   ├── hooks/       # React Query hooks
│       │   ├── services/    # API client
│       │   ├── stores/      # Zustand stores
│       │   └── types/       # TypeScript types
│       └── package.json
│
├── docker-compose.yml     # MongoDB container
└── package.json           # Workspace root
```

## API Endpoints

### Projects
- `GET /api/v1/projects` - List projects
- `POST /api/v1/projects` - Create project
- `GET /api/v1/projects/:id` - Get project
- `PATCH /api/v1/projects/:id` - Update project
- `DELETE /api/v1/projects/:id` - Delete project
- `GET /api/v1/projects/:id/handoff` - Generate HANDOFF document

### Tasks
- `GET /api/v1/projects/:id/tasks` - List tasks (add `?view=kanban` for grouped)
- `POST /api/v1/projects/:id/tasks` - Create task
- `PATCH /api/v1/projects/:id/tasks/:taskId` - Update task
- `POST /api/v1/projects/:id/tasks/:taskId/move` - Move task status
- `DELETE /api/v1/projects/:id/tasks/:taskId` - Delete task

### Phases
- `GET /api/v1/projects/:id/phases` - Get phase status
- `POST /api/v1/projects/:id/phases/:phase/complete` - Complete phase
- `POST /api/v1/projects/:id/phases/prioritize/auto` - Auto-prioritize (30/30/25/15)
- `POST /api/v1/projects/:id/phases/sequence/auto` - Auto-sequence (critical path)

## Universal Framework Principles

1. **Complete Execution**: Every identified task is implemented
2. **No MVP Filtering**: Quality over speed
3. **Type-Aware Processing**: Tailored workflows (UI/API/Algorithm/Hybrid)
4. **Phase Distribution**: 30% FOUNDATION, 30% BUILD, 25% ENHANCE, 15% FINALIZE
5. **Validation Gates**: Pre/Post execution verification

## Scripts

```bash
# Development
npm run dev              # Start all services
npm run dev:backend      # Backend only
npm run dev:frontend     # Frontend only

# Database
npm run db:up            # Start MongoDB
npm run db:down          # Stop MongoDB

# Production
npm run build            # Build all packages
npm run start            # Start production servers
```

## Environment Variables

Copy `.env.example` to `.env` in the backend package:

```bash
cp packages/backend/.env.example packages/backend/.env
```

## License

Private - Internal use only
