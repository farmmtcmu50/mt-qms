import { useEffect, useRef, useState, type FormEvent } from 'react';
import { Link, useParams } from 'react-router-dom';
import { FilePreview } from '../components/FilePreview';
import { Card, StatusChip } from '../components/ui';
import { api, errorText, fileUrl, type Criterion, type EvidenceItem, type RequirementDetail as Detail, type ScopeRow } from '../lib/api';
import { BRANCH_SHORT, fileSize, thDate } from '../lib/format';
import { useApi, useSession } from '../lib/session';

type CritState = 'ok' | 'expired' | 'missing';

function critState(items: EvidenceItem[]): CritState {
  if (items.some((e) => !e.expired)) return 'ok';
  return items.length ? 'expired' : 'missing';
}

const MARK: Record<CritState, { mark: string; dot: string; text: string }> = {
  ok: { mark: '✓', dot: 'lvl-good', text: 'status-good' },
  expired: { mark: '⟳', dot: 'lvl-warn', text: 'status-warn' },
  missing: { mark: '!', dot: 'lvl-crit', text: 'status-crit' },
};

export function RequirementDetail() {
  const { itemNo = '' } = useParams();
  const { branches, branchFilter, hasRole } = useSession();
  const { data, error, reload } = useApi<Detail>(`/requirements/${itemNo}`);
  const [tab, setTab] = useState<string>('');
  const [preCrit, setPreCrit] = useState<string>('');
  const [preview, setPreview] = useState<EvidenceItem | null>(null);
  // ไฟล์ติดธง PII เปิดได้เฉพาะ QM / LAB_HEAD (API ตรวจซ้ำ)
  const canOpen = (e: EvidenceItem) => !e.contains_pii || hasRole('QM', 'LAB_HEAD');
  const uploadRef = useRef<HTMLElement>(null);

  useEffect(() => {
    if (!data) return;
    const ids = data.scopes.map((s) => s.branch_id);
    if (!ids.includes(tab)) setTab(ids.includes(branchFilter) ? branchFilter : ids[0] ?? '');
  }, [data, branchFilter, tab]);

  if (error) return <div className="alert error">{error}</div>;
  if (!data) return <p className="muted">กำลังโหลด…</p>;

  const r = data.requirement;
  const scope = data.scopes.find((s) => s.branch_id === tab);
  const branch = branches.find((b) => b.id === tab);
  const readiness = data.readiness[tab];
  // หลักฐานของสาขาที่เลือก + หลักฐานกลาง
  const evidence = data.evidence.filter((e) => e.branch_id === tab || e.branch_id === null);
  const forCrit = (c: Criterion) => evidence.filter((e) => e.criterion_id === c.id);
  const preamble = data.criteria.length > 1 && !/^1\s*\./.test(r.criteria_text) ? r.criteria_text.split('\n')[0] : null;
  const canUpload = data.can.upload_branches === 'ALL' || data.can.upload_branches.includes(tab);

  const attach = (critId: string) => {
    setPreCrit(critId);
    const card = uploadRef.current;
    if (!card) return;
    card.scrollIntoView({ behavior: 'smooth', block: 'center' });
    // ไฮไลต์ฟอร์มให้เห็นว่ากดแล้ว และเปิดหน้าต่างเลือกไฟล์ทันที (ต้องเรียกใน click handler)
    card.classList.remove('flash');
    void card.offsetWidth;
    card.classList.add('flash');
    card.querySelector<HTMLInputElement>('input[type=file]')?.click();
  };

  return (
    <>
      <nav aria-label="ตำแหน่งหน้า" className="crumbs">
        <Link to="/requirements">ข้อกำหนด 90 ข้อ</Link>
        <span aria-hidden="true">›</span>
        {data.parent_section && (
          <>
            <Link to={`/requirements?section=${data.parent_section.code}`}>หมวด {data.parent_section.code} {data.parent_section.title}</Link>
            <span aria-hidden="true">›</span>
          </>
        )}
        <span className="here">ข้อ {r.item_no}</span>
      </nav>

      <header className="page-head" style={{ alignItems: 'flex-start' }}>
        <div className="stack" style={{ flex: '1 1 520px', minWidth: 0 }}>
          <div className="inline">
            <span className="code-tag">MOPH2568 · ข้อ {r.item_no}</span>
            {readiness && (
              <StatusChip status={readiness.status}>
                {readiness.status === 'NA' ? 'N/A ในสาขานี้' : `หลักฐานครบ ${readiness.ok}/${readiness.total} เกณฑ์ · ${readiness.status === 'READY' ? 'พร้อม' : readiness.status === 'PARTIAL' ? 'เสี่ยง Obs' : 'เสี่ยง NC'}`}
              </StatusChip>
            )}
            {r.na_allowed && <span className="chip neutral">ตอบ N/A ได้ตามแนวทาง</span>}
          </div>
          <h1>ข้อ {r.item_no} · {r.section_code} {r.section_title}</h1>
          <p style={{ margin: 0, fontSize: 15, lineHeight: 1.6, color: 'var(--ink-2)', maxWidth: 820 }}>{r.requirement_text}</p>
        </div>
        <div className="inline">
          {data.neighbours.prev && <Link className="btn" to={`/requirements/${data.neighbours.prev}`}>‹ ข้อ {data.neighbours.prev}</Link>}
          {data.neighbours.next && <Link className="btn" to={`/requirements/${data.neighbours.next}`}>ข้อ {data.neighbours.next} ›</Link>}
        </div>
      </header>

      <div role="tablist" aria-label="เลือกสาขา" className="tabs">
        {data.scopes.map((s) => {
          const b = branches.find((x) => x.id === s.branch_id);
          const rd = data.readiness[s.branch_id];
          return (
            <button key={s.branch_id} type="button" role="tab" className="tab" aria-selected={s.branch_id === tab} onClick={() => setTab(s.branch_id)}>
              {BRANCH_SHORT[s.branch_code] ?? b?.name_th}
              <span className={`count${rd?.status === 'READY' ? ' lvl-good' : ''}`}>{s.applicable ? `${rd?.ok ?? 0}/${rd?.total ?? 0}` : 'N/A'}</span>
            </button>
          );
        })}
      </div>

      <div className="row">
        <Card
          className="grow"
          id="crit-title"
          title={
            <div className="stack" style={{ gap: 4 }}>
              <h2 id="crit-title">เกณฑ์การตรวจประเมิน{data.criteria.length > 1 ? ` · ${data.criteria.length} เกณฑ์ย่อย` : ''}</h2>
              {preamble && <span className="caption">{preamble}</span>}
            </div>
          }
          aside={<span className="caption">สาขา: {branch?.name_th}</span>}
        >
          {scope && !scope.applicable && (
            <div className="alert info">ข้อนี้ตั้งเป็น N/A สำหรับสาขานี้ · เหตุผล: {scope.na_reason}</div>
          )}
          <div>
            {data.criteria.map((c) => {
              const items = forCrit(c);
              const st = critState(items);
              const latest = items.find((e) => !e.expired) ?? items[0];
              const [title, ...detail] = c.text.split('\n');
              return (
                <div className="criterion" key={c.id}>
                  <span className={`dot ${MARK[st].dot}`} aria-hidden="true">{MARK[st].mark}</span>
                  <div className="body">
                    <span className="title">{data.criteria.length > 1 ? `(${c.seq}) ` : ''}{title}</span>
                    {detail.length > 0 && <span className="caption pre">{detail.join('\n')}</span>}
                  </div>
                  <div className="aside">
                    {items.map((e) => (
                      <button
                        key={e.id}
                        type="button"
                        className={`ev-chip${e.expired ? ' expired' : ''}`}
                        title={canOpen(e) ? `ดูเอกสาร: ${e.title}` : 'มีข้อมูลส่วนบุคคล เปิดได้เฉพาะ QM / หัวหน้าห้องปฏิบัติการ'}
                        disabled={!canOpen(e)}
                        onClick={() => setPreview(e)}
                      >
                        {e.title}
                      </button>
                    ))}
                    {st !== 'ok' && canUpload && scope?.applicable && (
                      <button type="button" className="btn attach" onClick={() => attach(c.id)}>+ แนบหลักฐาน</button>
                    )}
                    <span className={MARK[st].text}>
                      {st === 'ok' && `มีหลักฐาน · อัปโหลด ${thDate(latest.uploaded_at)}${latest.valid_until ? ` · ใช้ได้ถึง ${thDate(latest.valid_until)}` : ''}`}
                      {st === 'expired' && `หลักฐานหมดอายุ ${thDate(latest.valid_until)}`}
                      {st === 'missing' && 'ยังไม่มีหลักฐาน'}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
          {r.remark && (
            <div className="note pre">
              <strong style={{ fontWeight: 600 }}>หมายเหตุ (ตามแนวทาง):</strong> {r.remark}
            </div>
          )}
          <EvidenceList items={evidence} canDelete={canUpload} onChange={reload} requirementId={r.id} criteria={data.criteria} canOpen={canOpen} onPreview={setPreview} />
          {preview && <FilePreview item={preview} onClose={() => setPreview(null)} />}
        </Card>

        <aside className="side">
          {canUpload && scope?.applicable !== false && (
            <UploadCard
              key={`${tab}:${r.id}`}
              sectionRef={uploadRef}
              requirementId={r.id}
              branchId={tab}
              criteria={data.criteria}
              preCrit={preCrit}
              allowShared={data.can.upload_branches === 'ALL' && branches.length > 1}
              onDone={() => {
                setPreCrit('');
                reload();
              }}
            />
          )}
          {data.can.edit_scope && scope && <ScopeCard key={scope.branch_id + r.id} requirementId={r.id} naAllowed={r.na_allowed} scope={scope} onDone={reload} />}
          <Card compact title="ประวัติผลประเมินข้อนี้" id="hist-title">
            <p className="empty">ผลการตรวจประเมินรายข้อจะแสดงเมื่อเปิดใช้ Assessment engine (ระยะที่ 2)</p>
            {data.can.edit_scope && <Link to={`/audit-log?id=${r.id}`} className="small">ดู audit log ของข้อนี้</Link>}
          </Card>
        </aside>
      </div>
    </>
  );
}

function EvidenceList({ items, canDelete, onChange, requirementId, criteria, canOpen, onPreview }: {
  items: EvidenceItem[]; canDelete: boolean; onChange: () => void; requirementId: string; criteria: Criterion[];
  canOpen: (e: EvidenceItem) => boolean; onPreview: (e: EvidenceItem) => void;
}) {
  const [err, setErr] = useState<string | null>(null);
  const [editing, setEditing] = useState<string | null>(null);
  if (items.length === 0) return null;
  const rowKey = (e: EvidenceItem) => `${e.id}:${e.criterion_id}`;
  const remove = async (e: EvidenceItem) => {
    if (!confirm(`ยกเลิกหลักฐาน "${e.title}"?\nไฟล์จะยังถูกเก็บไว้ตามระยะเก็บรักษา และบันทึกใน audit log`)) return;
    try {
      await api(`/evidence/${e.id}`, { method: 'DELETE' });
      onChange();
    } catch (x) {
      setErr(errorText(x));
    }
  };
  return (
    <div className="stack" style={{ marginTop: 12 }}>
      <h3>หลักฐานที่ผูกกับข้อนี้ ({items.length})</h3>
      {err && <div className="alert error">{err}</div>}
      <div className="scroll-x">
        <table className="table" style={{ minWidth: 560 }}>
          <thead>
            <tr><th>ชื่อหลักฐาน</th><th>ขอบเขต</th><th>ใช้ได้ถึง</th><th>อัปโหลด</th><th /></tr>
          </thead>
          <tbody>
            {items.map((e) =>
              editing === rowKey(e) ? (
                <tr key={rowKey(e)}>
                  <td colSpan={5}>
                    <EvidenceEditForm
                      item={e}
                      requirementId={requirementId}
                      criteria={criteria}
                      onCancel={() => setEditing(null)}
                      onSaved={() => {
                        setEditing(null);
                        onChange();
                      }}
                    />
                  </td>
                </tr>
              ) : (
                <tr key={rowKey(e)}>
                  <td>
                    <button type="button" className="link-btn" disabled={!canOpen(e)} onClick={() => onPreview(e)}>{e.title}</button>
                    <div className="small muted">{fileSize(e.size_bytes)}{e.contains_pii ? ' · มีข้อมูลส่วนบุคคล' : ''}</div>
                  </td>
                  <td>{e.branch_id ? 'สาขานี้' : 'ทุกสาขา'}</td>
                  <td className={e.expired ? 'status-warn' : ''}>{e.valid_until ? thDate(e.valid_until) : '—'}</td>
                  <td>{thDate(e.uploaded_at)}<div className="small muted">{e.uploaded_by_name}</div></td>
                  <td>
                    <div className="inline" style={{ gap: 6, flexWrap: 'nowrap', justifyContent: 'flex-end' }}>
                      <button type="button" className="btn secondary" disabled={!canOpen(e)} onClick={() => onPreview(e)}>ดูเอกสาร</button>
                      {canOpen(e) && <a className="btn secondary" href={fileUrl(e.id)}>ดาวน์โหลด</a>}
                      {canDelete && (
                        <>
                          <button type="button" className="btn secondary" onClick={() => setEditing(rowKey(e))}>แก้ไข</button>
                          <button type="button" className="btn secondary danger" onClick={() => remove(e)}>ยกเลิก</button>
                        </>
                      )}
                    </div>
                  </td>
                </tr>
              ),
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function EvidenceEditForm({ item, requirementId, criteria, onCancel, onSaved }: {
  item: EvidenceItem; requirementId: string; criteria: Criterion[]; onCancel: () => void; onSaved: () => void;
}) {
  const { hasRole } = useSession();
  const [title, setTitle] = useState(item.title);
  const [validUntil, setValidUntil] = useState(item.valid_until ?? '');
  const [pii, setPii] = useState(item.contains_pii);
  const [crit, setCrit] = useState(item.criterion_id ?? '');
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<string | null>(null);
  // เอาธงข้อมูลส่วนบุคคลออกได้เฉพาะ QM / หัวหน้าห้องปฏิบัติการ (API ตรวจซ้ำ)
  const canUnflag = hasRole('QM', 'LAB_HEAD');

  const save = async (ev: FormEvent) => {
    ev.preventDefault();
    const body: Record<string, unknown> = {};
    if (title.trim() !== item.title) body.title = title.trim();
    if ((validUntil || null) !== item.valid_until) body.valid_until = validUntil || null;
    if (pii !== item.contains_pii) body.contains_pii = pii;
    if ((crit || null) !== item.criterion_id) {
      body.relink = { requirement_id: requirementId, from_criterion_id: item.criterion_id, to_criterion_id: crit || null };
    }
    if (Object.keys(body).length === 0) return onCancel();
    setBusy(true);
    setErr(null);
    try {
      await api(`/evidence/${item.id}`, { method: 'PATCH', headers: { 'content-type': 'application/json' }, body: JSON.stringify(body) });
      onSaved();
    } catch (x) {
      setErr(errorText(x));
    } finally {
      setBusy(false);
    }
  };

  return (
    <form className="stack edit-form" style={{ gap: 10 }} onSubmit={save} aria-label={`แก้ไขหลักฐาน ${item.title}`}>
      <div className="edit-grid">
        <div className="field">
          <label htmlFor={`t-${item.id}`}>ชื่อหลักฐาน</label>
          <input id={`t-${item.id}`} className="input" value={title} maxLength={200} required onChange={(e) => setTitle(e.target.value)} />
        </div>
        <div className="field">
          <label htmlFor={`v-${item.id}`}>ใช้ได้ถึงวันที่ (เว้นว่าง = ไม่มีวันหมดอายุ)</label>
          <input id={`v-${item.id}`} type="date" className="input" value={validUntil} onChange={(e) => setValidUntil(e.target.value)} />
        </div>
        <div className="field">
          <label htmlFor={`c-${item.id}`}>ผูกกับเกณฑ์ย่อย</label>
          <select id={`c-${item.id}`} className="select" value={crit} onChange={(e) => setCrit(e.target.value)}>
            <option value="">ทั้งข้อ (ไม่ระบุเกณฑ์ย่อย)</option>
            {criteria.map((c) => (
              <option key={c.id} value={c.id}>({c.seq}) {c.text.split('\n')[0].slice(0, 80)}</option>
            ))}
          </select>
        </div>
      </div>
      <label className="check">
        <input type="checkbox" checked={pii} disabled={item.contains_pii && !canUnflag} onChange={(e) => setPii(e.target.checked)} />
        มีข้อมูลส่วนบุคคลของผู้ป่วย (ปิดชื่อ/HN แล้ว)
        {item.contains_pii && !canUnflag && <span className="small muted">· เอาธงออกได้เฉพาะ QM / หัวหน้าห้องปฏิบัติการ</span>}
      </label>
      <p className="small muted" style={{ margin: 0 }}>ตัวไฟล์แก้ไขไม่ได้ ถ้าไฟล์ผิดให้อัปโหลดหลักฐานใหม่แล้วกด "ยกเลิก" ฉบับเดิม · ทุกการแก้บันทึกใน audit log</p>
      {err && <div className="alert error">{err}</div>}
      <div className="inline" style={{ gap: 8 }}>
        <button type="submit" className="btn primary secondary" disabled={busy || !title.trim()}>{busy ? 'กำลังบันทึก…' : 'บันทึก'}</button>
        <button type="button" className="btn secondary" onClick={onCancel}>ยกเลิกการแก้ไข</button>
      </div>
    </form>
  );
}

function UploadCard(props: {
  sectionRef: React.RefObject<HTMLElement | null>;
  requirementId: string;
  branchId: string;
  criteria: Criterion[];
  preCrit: string;
  allowShared: boolean;
  onDone: () => void;
}) {
  const [file, setFile] = useState<File | null>(null);
  const [crit, setCrit] = useState(props.preCrit || (props.criteria.length === 1 ? props.criteria[0].id : ''));
  const [title, setTitle] = useState('');
  const [validUntil, setValidUntil] = useState('');
  const [shared, setShared] = useState(false);
  const [pii, setPii] = useState(false);
  const [busy, setBusy] = useState(false);
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null);
  const [over, setOver] = useState(false);
  const fileInput = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (props.preCrit) setCrit(props.preCrit);
  }, [props.preCrit]);

  const submit = async (ev: FormEvent) => {
    ev.preventDefault();
    if (!file) return setMsg({ ok: false, text: 'กรุณาเลือกไฟล์' });
    const f = new FormData();
    f.set('file', file);
    f.set('requirement_id', props.requirementId);
    f.set('branch_id', shared ? '' : props.branchId);
    if (crit) f.set('criterion_id', crit);
    if (title.trim()) f.set('title', title.trim());
    if (validUntil) f.set('valid_until', validUntil);
    if (pii) f.set('contains_pii', '1');
    setBusy(true);
    setMsg(null);
    try {
      await api('/evidence', { method: 'POST', body: f });
      setFile(null);
      setTitle('');
      setValidUntil('');
      setPii(false);
      if (fileInput.current) fileInput.current.value = '';
      setMsg({ ok: true, text: 'บันทึกหลักฐานแล้ว' });
      props.onDone();
    } catch (e) {
      setMsg({ ok: false, text: errorText(e) });
    } finally {
      setBusy(false);
    }
  };

  return (
    <section ref={props.sectionRef} className="card compact" aria-labelledby="up-title">
      <h3 id="up-title">แนบหลักฐานใหม่</h3>
      <form className="stack" style={{ gap: 12 }} onSubmit={submit}>
        <label
          htmlFor="up"
          className={`drop${over ? ' over' : ''}`}
          onDragOver={(e) => {
            e.preventDefault();
            setOver(true);
          }}
          onDragLeave={() => setOver(false)}
          onDrop={(e) => {
            e.preventDefault();
            setOver(false);
            if (e.dataTransfer.files[0]) setFile(e.dataTransfer.files[0]);
          }}
        >
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" style={{ color: 'var(--brand-navy)' }}>
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12" />
          </svg>
          <span style={{ fontWeight: 500 }}>{file ? file.name : 'ลากไฟล์มาวาง หรือคลิกเพื่อเลือก'}</span>
          <span className="small muted">PDF, JPG, PNG, XLSX, DOCX · ไม่เกิน 25 MB</span>
        </label>
        <input id="up" ref={fileInput} type="file" className="visually-hidden" accept=".pdf,.jpg,.jpeg,.png,.xlsx,.docx" onChange={(e) => setFile(e.target.files?.[0] ?? null)} />
        <div className="field">
          <label htmlFor="crit">ผูกกับเกณฑ์ย่อย</label>
          <select id="crit" className="select" value={crit} onChange={(e) => setCrit(e.target.value)}>
            <option value="">ทั้งข้อ (ไม่ระบุเกณฑ์ย่อย)</option>
            {props.criteria.map((c) => (
              <option key={c.id} value={c.id}>({c.seq}) {c.text.split('\n')[0].slice(0, 80)}</option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="ev-title">ชื่อหลักฐาน</label>
          <input id="ev-title" className="input" value={title} placeholder="ใช้ชื่อไฟล์ถ้าไม่ระบุ" onChange={(e) => setTitle(e.target.value)} />
        </div>
        <div className="field">
          <label htmlFor="valid">ใช้ได้ถึงวันที่ (ถ้ามี)</label>
          <input id="valid" type="date" className="input" value={validUntil} onChange={(e) => setValidUntil(e.target.value)} />
        </div>
        {props.allowShared && (
          <label className="check"><input type="checkbox" checked={shared} onChange={(e) => setShared(e.target.checked)} /> หลักฐานกลาง ใช้ร่วมทุกสาขา</label>
        )}
        <label className="check"><input type="checkbox" checked={pii} onChange={(e) => setPii(e.target.checked)} /> มีข้อมูลส่วนบุคคลของผู้ป่วย (ปิดชื่อ/HN แล้ว)</label>
        {msg && <div className={`alert ${msg.ok ? 'ok' : 'error'}`}>{msg.text}</div>}
        <button type="submit" className="btn primary" disabled={busy || !file}>{busy ? 'กำลังอัปโหลด…' : 'บันทึกหลักฐาน'}</button>
      </form>
    </section>
  );
}

function ScopeCard({ requirementId, naAllowed, scope, onDone }: { requirementId: string; naAllowed: boolean; scope: ScopeRow; onDone: () => void }) {
  const [na, setNa] = useState(!scope.applicable);
  const [reason, setReason] = useState(scope.na_reason ?? '');
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null);
  if (!naAllowed && scope.applicable) return null;
  const save = async (ev: FormEvent) => {
    ev.preventDefault();
    try {
      await api(`/requirements/${requirementId}/scope/${scope.branch_id}`, {
        method: 'PATCH',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ applicable: !na, na_reason: na ? reason : null }),
      });
      setMsg({ ok: true, text: 'บันทึกแล้ว' });
      onDone();
    } catch (e) {
      setMsg({ ok: false, text: errorText(e) });
    }
  };
  return (
    <Card compact title="ขอบเขตสาขา (QM)" id="scope-title">
      <form className="stack" style={{ gap: 10 }} onSubmit={save}>
        <label className="check"><input type="checkbox" checked={na} onChange={(e) => setNa(e.target.checked)} /> ไม่เกี่ยวข้องกับสาขานี้ (N/A)</label>
        {na && (
          <div className="field">
            <label htmlFor="na-reason">เหตุผล</label>
            <textarea id="na-reason" className="textarea" value={reason} onChange={(e) => setReason(e.target.value)} required />
          </div>
        )}
        {msg && <div className={`alert ${msg.ok ? 'ok' : 'error'}`}>{msg.text}</div>}
        <button type="submit" className="btn secondary">บันทึกขอบเขต</button>
      </form>
    </Card>
  );
}
