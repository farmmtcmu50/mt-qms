import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter, Link, Outlet, Route, Routes } from 'react-router-dom';
import { Sidebar } from './components/Sidebar';
import { SessionProvider } from './lib/session';
import { AuditLog } from './pages/AuditLog';
import { Dashboard } from './pages/Dashboard';
import { RequirementDetail } from './pages/RequirementDetail';
import { Requirements } from './pages/Requirements';
import './styles/app.css';

function Layout() {
  return (
    <div className="shell">
      <Sidebar />
      <main className="main">
        <Outlet />
      </main>
    </div>
  );
}

function NotFound() {
  return (
    <div className="stack">
      <h1>ไม่พบหน้านี้</h1>
      <Link to="/">กลับหน้าภาพรวม</Link>
    </div>
  );
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <SessionProvider>
        <Routes>
          <Route element={<Layout />}>
            <Route index element={<Dashboard />} />
            <Route path="requirements" element={<Requirements />} />
            <Route path="requirements/:itemNo" element={<RequirementDetail />} />
            <Route path="audit-log" element={<AuditLog />} />
            <Route path="*" element={<NotFound />} />
          </Route>
        </Routes>
      </SessionProvider>
    </BrowserRouter>
  </StrictMode>,
);
