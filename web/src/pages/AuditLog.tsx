import { useSearchParams } from 'react-router-dom';
import { Card } from '../components/ui';
import type { AuditEntry } from '../lib/api';
import { thDateTime } from '../lib/format';
import { useApi } from '../lib/session';

function pretty(json: string | null) {
  if (!json) return '';
  try {
    return JSON.stringify(JSON.parse(json), null, 1);
  } catch {
    return json;
  }
}

export function AuditLog() {
  const [params] = useSearchParams();
  const qs = params.toString();
  const { data, error } = useApi<{ entries: AuditEntry[] }>(`/audit-log${qs ? `?${qs}` : ''}`);
  return (
    <>
      <header className="page-head">
        <div className="stack" style={{ gap: 6 }}>
          <h1>Audit log</h1>
          <p className="muted" style={{ margin: 0 }}>บันทึกทุกการเขียนและดาวน์โหลด (อ่านอย่างเดียว · ข้อ 12, 57) · แสดง 200 รายการล่าสุด{qs ? ` · ตัวกรอง ${qs}` : ''}</p>
        </div>
      </header>
      {error && <div className="alert error">{error}</div>}
      <Card>
        <div className="scroll-x">
          <table className="table" style={{ minWidth: 900 }}>
            <thead>
              <tr><th>เวลา</th><th>ผู้ทำ</th><th>การกระทำ</th><th>รายการ</th><th>ก่อน</th><th>หลัง</th></tr>
            </thead>
            <tbody>
              {(data?.entries ?? []).map((a) => (
                <tr key={a.id}>
                  <td style={{ whiteSpace: 'nowrap' }}>{thDateTime(a.at)}</td>
                  <td>{a.user_name ?? '—'}</td>
                  <td className="mono">{a.action}</td>
                  <td><span className="mono small">{a.entity}</span><br /><span className="small muted">{a.entity_id}</span></td>
                  <td><pre className="small" style={{ margin: 0, whiteSpace: 'pre-wrap', maxWidth: 260 }}>{pretty(a.before_json)}</pre></td>
                  <td><pre className="small" style={{ margin: 0, whiteSpace: 'pre-wrap', maxWidth: 260 }}>{pretty(a.after_json)}</pre></td>
                </tr>
              ))}
            </tbody>
          </table>
          {data && data.entries.length === 0 && <p className="empty">ยังไม่มีรายการ</p>}
        </div>
      </Card>
    </>
  );
}
