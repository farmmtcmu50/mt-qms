import { Link, useSearchParams } from 'react-router-dom';
import { Card, StatusChip } from '../components/ui';
import type { ItemStatus, RequirementListItem, Section } from '../lib/api';
import { BRANCH_SHORT } from '../lib/format';
import { useApi, useSession } from '../lib/session';

const FILTERS: { key: string; label: string; match: (s: ItemStatus) => boolean }[] = [
  { key: '', label: 'ทั้งหมด', match: () => true },
  { key: 'gap', label: 'เสี่ยง NC / Obs', match: (s) => s === 'MISSING' || s === 'PARTIAL' },
  { key: 'ready', label: 'หลักฐานครบ', match: (s) => s === 'READY' },
  { key: 'na', label: 'N/A', match: (s) => s === 'NA' },
];

export function Requirements() {
  const { branches, branchFilter } = useSession();
  const [params, setParams] = useSearchParams();
  const section = params.get('section') ?? '';
  const status = params.get('status') ?? '';
  const branch = params.get('branch') ?? branchFilter;
  const list = useApi<{ items: RequirementListItem[] }>(`/requirements${branch ? `?branch=${branch}` : ''}`);
  const sections = useApi<{ sections: Section[] }>('/sections');
  const cols = branch ? branches.filter((b) => b.id === branch) : branches;
  const filter = FILTERS.find((f) => f.key === status) ?? FILTERS[0];

  const set = (k: string, v: string) => {
    const p = new URLSearchParams(params);
    if (v) p.set(k, v);
    else p.delete(k);
    setParams(p, { replace: true });
  };

  const items = (list.data?.items ?? []).filter(
    (r) =>
      (!section || r.section_code === section || r.section_code.startsWith(section + '.')) &&
      cols.some((b) => r.branches[b.id] && filter.match(r.branches[b.id].status)),
  );

  return (
    <>
      <header className="page-head">
        <div className="stack" style={{ gap: 6 }}>
          <h1>ข้อกำหนด 90 ข้อ</h1>
          <p className="muted" style={{ margin: 0 }}>เกณฑ์การตรวจประเมิน MOPH LAB 2568 (G 0715050 ฉบับปรับปรุงครั้งที่ 3) · 12 หมวด</p>
        </div>
      </header>

      <div className="inline">
        <div className="field" style={{ minWidth: 240 }}>
          <label htmlFor="f-sec">หมวด</label>
          <select id="f-sec" className="select" value={section} onChange={(e) => set('section', e.target.value)}>
            <option value="">ทุกหมวด</option>
            {(sections.data?.sections ?? []).filter((s) => !s.code.includes('.')).map((s) => (
              <option key={s.code} value={s.code}>{s.code}. {s.title}</option>
            ))}
          </select>
        </div>
        <div className="field" style={{ minWidth: 200 }}>
          <label htmlFor="f-br">สาขา</label>
          <select id="f-br" className="select" value={branch} onChange={(e) => set('branch', e.target.value)}>
            {branches.length > 1 && <option value="">ทุกสาขา</option>}
            {branches.map((b) => <option key={b.id} value={b.id}>{b.name_th}</option>)}
          </select>
        </div>
        <div className="field">
          <span className="label">สถานะ</span>
          <div className="inline" role="group" aria-label="กรองตามสถานะ" style={{ gap: 6 }}>
            {FILTERS.map((f) => (
              <button key={f.key} type="button" className={`btn secondary${f.key === status ? ' primary' : ''}`} aria-pressed={f.key === status} onClick={() => set('status', f.key)}>
                {f.label}
              </button>
            ))}
          </div>
        </div>
      </div>

      {list.error && <div className="alert error">{list.error}</div>}

      <Card>
        <div className="scroll-x">
          <table className="table" style={{ minWidth: 720 }}>
            <thead>
              <tr>
                <th scope="col">ข้อ</th>
                <th scope="col">ข้อกำหนด</th>
                {cols.map((b) => <th scope="col" key={b.id}>{BRANCH_SHORT[b.code] ?? b.code}</th>)}
              </tr>
            </thead>
            <tbody>
              {items.map((r) => (
                <tr key={r.id}>
                  <td className="mono"><Link to={`/requirements/${r.item_no}`}>{r.item_no}</Link></td>
                  <td>
                    <Link to={`/requirements/${r.item_no}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                      <span className="small muted">{r.section_code} {r.section_title}</span>
                      <br />
                      {r.requirement_text}
                    </Link>
                  </td>
                  {cols.map((b) => {
                    const x = r.branches[b.id];
                    return (
                      <td key={b.id} style={{ whiteSpace: 'nowrap' }}>
                        {x && <StatusChip status={x.status}>{x.status === 'NA' ? 'N/A' : `${x.ok}/${x.total}`}</StatusChip>}
                      </td>
                    );
                  })}
                </tr>
              ))}
            </tbody>
          </table>
          {list.data && items.length === 0 && <p className="empty">ไม่มีข้อที่ตรงกับตัวกรอง</p>}
        </div>
      </Card>
    </>
  );
}
