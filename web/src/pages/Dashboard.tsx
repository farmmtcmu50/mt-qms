import { Link } from 'react-router-dom';
import { Card, ProgressBar, StatTile } from '../components/ui';
import type { Overview, ReadinessDashboard, Section } from '../lib/api';
import { BRANCH_SHORT, daysUntil, pctLevel, thDate } from '../lib/format';
import { useApi, useSession } from '../lib/session';

export function Dashboard() {
  const { branches, branchFilter, branchById } = useSession();
  const q = branchFilter ? `?branch=${branchFilter}` : '';
  const readiness = useApi<ReadinessDashboard>(`/dashboard/readiness${q}`);
  const overview = useApi<Overview>('/dashboard/overview');
  const sections = useApi<{ sections: Section[] }>('/sections');

  const cols = branchFilter ? branches.filter((b) => b.id === branchFilter) : branches;
  const top = (sections.data?.sections ?? []).filter((s) => !s.code.includes('.'));
  const cell = (section: string, branchId: string) => readiness.data?.cells.find((c) => c.section === section && c.branch_id === branchId);
  const expiring = (overview.data?.expiring ?? []).filter((e) => !branchFilter || e.branch_id === branchFilter || e.branch_id === null);
  const overall = readiness.data?.overall;
  // หลายสาขา = นับรายข้อรายสาขา (90 ข้อ × จำนวนสาขา)
  const unit = cols.length > 1 ? `ข้อ×สาขา (${cols.length} สาขา)` : 'ข้อ';

  return (
    <>
      <header className="page-head">
        <div className="stack" style={{ gap: 6 }}>
          <h1 style={{ fontSize: 28 }}>ภาพรวมความพร้อม</h1>
          <p className="muted" style={{ margin: 0 }}>
            ถ้าผู้ตรวจมาพรุ่งนี้ สาขาไหนเสี่ยงข้อไหน{overview.data ? ` · ข้อมูล ณ ${thDate(overview.data.today)}` : ''}
          </p>
        </div>
        <Link to="/requirements" className="btn primary">ดูข้อกำหนด 90 ข้อ</Link>
      </header>

      {(readiness.error || overview.error) && <div className="alert error">{readiness.error ?? overview.error}</div>}

      <section aria-label="ตัวชี้วัดหลัก" className="tiles">
        <StatTile
          label={cols.length === 1 ? `Readiness · ${cols[0].name_th}` : 'Readiness รวม (ทุกสาขา)'}
          value={overall?.pct == null ? '—' : `${overall.pct}%`}
          tone="brand"
          foot={overall ? `หลักฐานครบ ${overall.ready} ÷ ที่ใช้ได้ (ไม่รวม N/A) ${overall.applicable} ${unit}` : 'ข้อที่หลักฐานครบ ÷ (90 − N/A)'}
        >
          <ProgressBar pct={overall?.pct ?? 0} />
        </StatTile>
        <StatTile
          label="ข้อที่เสี่ยง NC / Obs"
          value={overall ? overall.missing + overall.partial : '—'}
          foot={overall ? `ไม่มีหลักฐาน ${overall.missing} · หลักฐานไม่ครบ ${overall.partial} · N/A ${overall.na} · หน่วย: ${unit}` : undefined}
          to="/requirements?status=gap"
        />
        <StatTile
          label="หลักฐานหมดอายุใน 30 วัน"
          value={overview.data ? expiring.length : '—'}
          tone="warn"
          foot='ข้อที่จะกลับเป็น "ขาดหลักฐาน" ถ้าไม่ต่ออายุ'
        />
        <StatTile label="NC / Obs และงานตามรอบ" value="ระยะที่ 2–3" pending foot="บอร์ด NC/CAR เปิดใช้ในระยะที่ 2 · ปฏิทินงานในระยะที่ 3" />
      </section>

      <div className="row">
        <Card
          className="grow"
          id="hm-title"
          title={
            <div className="stack" style={{ gap: 4 }}>
              <h2 id="hm-title">ความพร้อมรายหมวด × สาขา</h2>
              <span className="caption">% ของข้อที่หลักฐานครบทุกเกณฑ์ย่อย · คลิกช่องเพื่อดูข้อที่ขาด</span>
            </div>
          }
          aside={
            <div className="legend">
              <span><i className="lvl-good" />≥ 90%</span>
              <span><i className="lvl-fair" />70–89%</span>
              <span><i className="lvl-warn" />50–69% เสี่ยง Obs</span>
              <span><i className="lvl-crit" />&lt; 50% เสี่ยง NC</span>
            </div>
          }
        >
          <div className="scroll-x">
            <table className="heatmap">
              <thead>
                <tr>
                  <th scope="col" style={{ textAlign: 'left' }}>หมวด (ข้อ)</th>
                  {cols.map((b) => <th scope="col" key={b.id}>{BRANCH_SHORT[b.code] ?? b.code}</th>)}
                </tr>
              </thead>
              <tbody>
                {top.map((s) => (
                  <tr key={s.code}>
                    <th scope="row">
                      <span className="mono small muted" style={{ marginRight: 6 }}>{s.code}</span>
                      {s.title} <span className="small muted">({s.first_item}–{s.last_item})</span>
                    </th>
                    {cols.map((b) => {
                      const c = cell(s.code, b.id);
                      const pct = c?.pct ?? null;
                      return (
                        <td key={b.id} className={`lvl-${pctLevel(pct)}`}>
                          <Link to={`/requirements?section=${s.code}&branch=${b.id}`} aria-label={`หมวด ${s.code} ${b.name_th}`}>
                            {pct === null ? (c ? 'N/A' : '…') : `${pct}%`}
                          </Link>
                        </td>
                      );
                    })}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>

        <div className="side">
          <Card compact title="หลักฐานใกล้หมดอายุ" id="ev-title">
            {overview.data && expiring.length === 0 && <p className="empty">ไม่มีหลักฐานที่จะหมดอายุใน 30 วัน</p>}
            {expiring.map((e) => {
              const first = e.item_nos?.split(',')[0];
              return (
                <div className="list-row" key={e.id}>
                  <span className="stack" style={{ gap: 2, minWidth: 0 }}>
                    {first ? <Link to={`/requirements/${first}`} style={{ fontWeight: 500 }}>{e.title}</Link> : <span style={{ fontWeight: 500 }}>{e.title}</span>}
                    <span className="muted">
                      {e.item_nos ? `ข้อ ${e.item_nos.split(',').join(', ')} · ` : ''}
                      {e.branch_id ? BRANCH_SHORT[branchById(e.branch_id)?.code ?? ''] ?? '' : 'ทุกสาขา'}
                    </span>
                  </span>
                  <span className="status-warn" style={{ whiteSpace: 'nowrap', fontSize: 13 }}>
                    {(() => {
                      const d = daysUntil(e.valid_until, overview.data!.today);
                      return d === 0 ? 'วันนี้' : `อีก ${d} วัน`;
                    })()}
                  </span>
                </div>
              );
            })}
          </Card>
          <Card compact title="NC ที่ต้องติดตาม" id="nc-title">
            <p className="empty">บอร์ด NC/CAR จะเปิดใช้ในระยะที่ 2 (Assessment engine + NC/CAR workflow)</p>
          </Card>
        </div>
      </div>
    </>
  );
}
