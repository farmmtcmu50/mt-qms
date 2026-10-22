import { useEffect, useRef } from 'react';
import { fileUrl, type EvidenceItem } from '../lib/api';
import { fileSize, thDate } from '../lib/format';

const PDF = 'application/pdf';
const IMAGES = ['image/jpeg', 'image/png'];

export const canPreviewInline = (mime: string) => mime === PDF || IMAGES.includes(mime);

/** ดูเอกสารหลักฐานในหน้าเว็บ (PDF / รูปภาพ) — ไฟล์โหลดผ่าน Worker และถูกบันทึกใน audit log */
export function FilePreview({ item, onClose }: { item: EvidenceItem; onClose: () => void }) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const d = ref.current;
    if (d && !d.open) d.showModal();
  }, []);
  const src = fileUrl(item.id, true);

  return (
    <dialog ref={ref} className="preview" aria-labelledby="pv-title" onClose={onClose} onCancel={onClose}>
      <header className="preview-head">
        <div className="stack" style={{ gap: 2, minWidth: 0 }}>
          <h3 id="pv-title" className="preview-title">{item.title}</h3>
          <span className="small muted">
            {fileSize(item.size_bytes)} · อัปโหลด {thDate(item.uploaded_at)}
            {item.valid_until ? ` · ใช้ได้ถึง ${thDate(item.valid_until)}` : ''}
            {item.contains_pii ? ' · มีข้อมูลส่วนบุคคล' : ''}
          </span>
        </div>
        <div className="inline" style={{ gap: 6 }}>
          <a className="btn secondary" href={src} target="_blank" rel="noreferrer">เปิดในแท็บใหม่</a>
          <a className="btn secondary" href={fileUrl(item.id)}>ดาวน์โหลด</a>
          <button type="button" className="btn secondary" onClick={() => ref.current?.close()} autoFocus>ปิด</button>
        </div>
      </header>
      <div className="preview-body">
        {item.mime === PDF && <iframe title={item.title} src={src} />}
        {IMAGES.includes(item.mime) && <img src={src} alt={item.title} />}
        {!canPreviewInline(item.mime) && (
          <div className="preview-empty">
            <p>เบราว์เซอร์แสดงไฟล์ชนิดนี้ (XLSX / DOCX) ในหน้าเว็บไม่ได้</p>
            <a className="btn primary" href={fileUrl(item.id)}>ดาวน์โหลดเพื่อเปิดดู</a>
          </div>
        )}
      </div>
    </dialog>
  );
}
