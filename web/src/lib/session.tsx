import { createContext, useContext, useEffect, useState, type ReactNode } from 'react';
import { api, errorText, type Branch, type Me, type Role } from './api';

interface Session {
  me: Me;
  branches: Branch[];
  /** '' = ทุกสาขาที่มีสิทธิ์ */
  branchFilter: string;
  setBranchFilter: (id: string) => void;
  branchById: (id: string | null) => Branch | undefined;
  hasRole: (...roles: Role[]) => boolean;
}

const Ctx = createContext<Session | null>(null);
const KEY = 'mtqms.branch';

function readStored() {
  try {
    return localStorage.getItem(KEY) ?? '';
  } catch {
    return '';
  }
}

export function SessionProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<{ me: Me; branches: Branch[] } | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [branchFilter, setFilter] = useState(readStored);

  useEffect(() => {
    Promise.all([api<{ user: Me }>('/me'), api<{ branches: Branch[] }>('/branches')])
      .then(([m, b]) => setState({ me: m.user, branches: b.branches }))
      .catch((e) => setError(errorText(e)));
  }, []);

  if (error) return <div className="main"><div className="alert error">{error}</div></div>;
  if (!state) return <div className="main"><p className="muted">กำลังโหลด…</p></div>;

  const validFilter = state.branches.some((b) => b.id === branchFilter) ? branchFilter : '';
  const value: Session = {
    ...state,
    branchFilter: validFilter,
    setBranchFilter: (id) => {
      setFilter(id);
      try {
        localStorage.setItem(KEY, id);
      } catch {
        /* per-viewer convenience only */
      }
    },
    branchById: (id) => state.branches.find((b) => b.id === id),
    hasRole: (...roles) => state.me.roles.some((r) => roles.includes(r.role)),
  };
  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useSession() {
  const s = useContext(Ctx);
  if (!s) throw new Error('useSession outside SessionProvider');
  return s;
}

/** โหลดข้อมูลจาก API พร้อมสถานะ loading/error และฟังก์ชันโหลดใหม่ */
export function useApi<T>(path: string | null) {
  const [data, setData] = useState<T | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [tick, setTick] = useState(0);
  useEffect(() => {
    if (!path) return;
    let live = true;
    setError(null);
    api<T>(path)
      .then((d) => live && setData(d))
      .catch((e) => live && setError(errorText(e)));
    return () => {
      live = false;
    };
  }, [path, tick]);
  return { data, error, reload: () => setTick((t) => t + 1) };
}
