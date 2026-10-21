import type { ReactNode } from 'react';
import { Link } from 'react-router-dom';
import type { ItemStatus } from '../lib/api';
import { STATUS } from '../lib/format';

export function Card({ title, aside, children, compact, id, className }: {
  title?: ReactNode; aside?: ReactNode; children: ReactNode; compact?: boolean; id?: string; className?: string;
}) {
  return (
    <section className={`card${compact ? ' compact' : ''}${className ? ' ' + className : ''}`} aria-labelledby={id}>
      {(title || aside) && (
        <div className="card-head">
          {typeof title === 'string' ? (compact ? <h3 id={id}>{title}</h3> : <h2 id={id}>{title}</h2>) : title}
          {aside}
        </div>
      )}
      {children}
    </section>
  );
}

export function StatTile({ label, value, tone, foot, to, children, pending }: {
  label: string; value: ReactNode; tone?: 'brand' | 'warn'; foot?: ReactNode; to?: string; children?: ReactNode; pending?: boolean;
}) {
  const inner = (
    <>
      <span className="caption">{label}</span>
      <span className={`value${tone ? ' ' + tone : ''}`}>{value}</span>
      {children}
      {foot && <span className="small muted">{foot}</span>}
    </>
  );
  const cls = `tile${pending ? ' pending' : ''}`;
  return to ? <Link to={to} className={cls}>{inner}</Link> : <div className={cls}>{inner}</div>;
}

export function StatusChip({ status, children }: { status: ItemStatus; children?: ReactNode }) {
  const s = STATUS[status];
  return <span className={`chip ${s.tone}`}>{children ?? s.label}</span>;
}

export function ProgressBar({ pct }: { pct: number }) {
  return (
    <div className="bar" role="progressbar" aria-valuenow={pct} aria-valuemin={0} aria-valuemax={100}>
      <div style={{ width: `${pct}%` }} />
    </div>
  );
}

export function Icon({ d, size = 18 }: { d: string; size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d={d} />
    </svg>
  );
}
