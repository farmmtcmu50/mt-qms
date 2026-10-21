import { useState } from 'react';
import { NavLink } from 'react-router-dom';
import { ROLE_LABEL } from '../lib/format';
import { useSession } from '../lib/session';
import { Icon } from './ui';

const MAIN = [
  { to: '/', label: 'ภาพรวมความพร้อม', icon: 'M3 13h8V3H3zM13 21h8V11h-8zM3 21h8v-6H3zM13 3v6h8V3z', end: true },
  { to: '/requirements', label: 'ข้อกำหนด 90 ข้อ', icon: 'M9 6h11M9 12h11M9 18h11M4 6h.01M4 12h.01M4 18h.01' },
];
// เมนูที่ยังไม่เปิดใช้: ทำตามแผน 4 ระยะใน spec หัวข้อ 12
const LATER = [
  { label: 'การตรวจประเมิน', phase: 2, icon: 'M9 11l3 3 8-8M20 12v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h9' },
  { label: 'NC / CAR', phase: 2, icon: 'M12 9v4M12 17h.01M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z' },
  { label: 'ปฏิทินงานตามรอบ', phase: 3, icon: 'M8 2v4M16 2v4M3 10h18M5 4h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z' },
];
const REG = [
  { label: 'เอกสาร & Master List', phase: 3, icon: 'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8zM14 2v6h6' },
  { label: 'เครื่องมือ & สอบเทียบ', phase: 3, icon: 'M14.7 6.3a4 4 0 0 0-5.4 5.4L3 18l3 3 6.3-6.3a4 4 0 0 0 5.4-5.4l-2.5 2.5-2.4-.6-.6-2.4z' },
  { label: 'บุคลากร & Competency', phase: 3, icon: 'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM22 21v-2a4 4 0 0 0-3-3.9M16 3.1a4 4 0 0 1 0 7.8' },
  { label: 'ความเสี่ยง & KPI', phase: 4, icon: 'M3 3v18h18M7 15l4-4 3 3 5-6' },
  { label: 'Management Review', phase: 4, icon: 'M17 21v-2a4 4 0 0 0-4-4H5M12 7a4 4 0 1 1-8 0 4 4 0 0 1 8 0zM20 8v6M23 11h-6' },
];

function Later({ label, phase, icon }: { label: string; phase: number; icon: string }) {
  return (
    <span className="nav-link disabled" aria-disabled="true" title={`เปิดใช้ในระยะที่ ${phase}`}>
      <Icon d={icon} />
      <span>{label}</span>
      <span className="soon">ระยะ {phase}</span>
    </span>
  );
}

export function Sidebar() {
  const { me, branches, branchFilter, setBranchFilter, hasRole } = useSession();
  const [open, setOpen] = useState(false);
  const role = me.roles[0];
  return (
    <aside className="sidebar">
      <nav aria-label="เมนูหลัก" className={`nav${open ? '' : ' collapsed'}`}>
        <div className="nav-brand">
          <img src="/mt-logo-full.png" alt="บริษัท เมดิคอลเทรนด์ จำกัด Medical Trend Co., Ltd." />
          <div className="inline">
            <span className="name">MT-QMS</span>
            <span className="chip brand">MOPH LAB 2568</span>
          </div>
          <button type="button" className="btn secondary nav-toggle" aria-expanded={open} onClick={() => setOpen(!open)}>
            {open ? 'ปิดเมนู' : 'เมนู'}
          </button>
        </div>

        <div className="nav-body" onClick={(e) => (e.target as HTMLElement).closest('a') && setOpen(false)}>
          <div className="field" style={{ padding: '0 8px' }}>
            <label htmlFor="branch">สาขาที่ดูอยู่</label>
            <select id="branch" className="select sunken" value={branchFilter} onChange={(e) => setBranchFilter(e.target.value)}>
              {branches.length > 1 && <option value="">ทุกสาขา</option>}
              {branches.map((b) => (
                <option key={b.id} value={b.id}>{b.name_th}</option>
              ))}
            </select>
          </div>

          <div className="nav-group">
            <span className="nav-label">ติดตามมาตรฐาน</span>
            {MAIN.map((m) => (
              <NavLink key={m.to} to={m.to} end={m.end} className={({ isActive }) => `nav-link${isActive ? ' active' : ''}`}>
                <Icon d={m.icon} />
                <span>{m.label}</span>
              </NavLink>
            ))}
            {LATER.map((m) => <Later key={m.label} {...m} />)}
          </div>

          <div className="nav-group">
            <span className="nav-label">ทะเบียน</span>
            {REG.map((m) => <Later key={m.label} {...m} />)}
            {hasRole('QM', 'TOP_MGMT') && (
              <NavLink to="/audit-log" className={({ isActive }) => `nav-link${isActive ? ' active' : ''}`}>
                <Icon d="M12 8v4l3 3M21 12a9 9 0 1 1-9-9 9 9 0 0 1 9 9z" />
                <span>Audit log</span>
              </NavLink>
            )}
          </div>

          <div className="nav-user">
            <div className="avatar" aria-hidden="true">{me.full_name.slice(0, 1)}</div>
            <div className="stack" style={{ gap: 0, minWidth: 0 }}>
              <span style={{ fontWeight: 600 }}>{me.full_name}</span>
              <span className="small muted">
                {me.position ? `${me.position} · ` : ''}
                {role ? ROLE_LABEL[role.role] : ''}
              </span>
            </div>
          </div>
        </div>
      </nav>
    </aside>
  );
}
