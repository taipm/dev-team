import { Routes, Route, Navigate } from 'react-router-dom';
import { AppLayout } from '@/components/layout/AppLayout';
import { DashboardPage } from '@/components/dashboard/DashboardPage';
import { ProjectDetailPage } from '@/components/project/ProjectDetailPage';
import { KanbanPage } from '@/components/kanban/KanbanPage';
import { Notifications } from '@/components/common/Notifications';

export default function App() {
  return (
    <>
      <AppLayout>
        <Routes>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/projects/:projectId" element={<ProjectDetailPage />} />
          <Route path="/projects/:projectId/kanban" element={<KanbanPage />} />
        </Routes>
      </AppLayout>
      <Notifications />
    </>
  );
}
