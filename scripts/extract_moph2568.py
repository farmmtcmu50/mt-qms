import fitz, json, re, sys
pdf, out = sys.argv[1], sys.argv[2]   # docs/MOPH-LAB-2568.pdf, migrations/0002_seed_moph2568.sql
d = fitz.open(pdf)
COLS = [(0,128),(128,262),(262,418),(418,999)]
HEAD = ('ลำดับ','ที่','ข้อกำหนด','เกณฑ์การตรวจประเมิน','หมายเหตุ')
def col(x):
    for i,(a,b) in enumerate(COLS):
        if a <= x < b: return i
# gather every line across pages with a global y (page*1000 + y)
L = []
for pno in range(9, 51):
    for b in d[pno].get_text('dict')['blocks']:
        for l in b.get('lines', []):
            t = ''.join(s['text'] for s in l['spans'])
            if not t.strip(): continue
            x0,y0,x1,y1 = l['bbox']
            if y0 < 70 or y0 > 712: continue
            if y0 < 140 and t.strip() in HEAD: continue
            if pno == 9 and y0 < 200 and ('8.1 เกณฑ์' in t or 'Supplementary' in t): continue
            L.append((pno*1000 + y0, x0, x1, t, pno+1))
L.sort(key=lambda r:(r[0], r[1]))
markers, content, last = [], [], 0   # markers: (gy, kind, value, extra)
for gy,x0,x1,t,pg in L:
    if t.strip() == '8.2 ภาคผนวก': break
    c = col(x0)
    m = re.fullmatch(r'\s*(\d{1,2})\.?\s*(.*?)\s*', t)
    if c == 0 and m and (not m.group(2) or (last > 0 and int(m.group(1)) == last+1)):
        last = int(m.group(1)); markers.append((gy,'item',last,pg))
        if m.group(2): content.append((gy+0.01, 1, m.group(2)+' '))
        continue
    if c == 0 and m:
        markers.append((gy,'sec',t.strip(),pg)); continue
    if c == 0: print('UNASSIGNED', pg, repr(t), file=sys.stderr); continue
    content.append((gy, c, t))
items, sections, cursec = [], [], None
for mk in markers:
    if mk[1]=='sec': cursec = mk[2]; sections.append(cursec)
    else: items.append({'item_no': mk[2], 'section': cursec, 'page': mk[3], 'gy': mk[0], 'cols': [[],[],[]]})
TOL = 4
for gy,c,t in content:
    owner = None
    for it in items:
        if it['gy'] <= gy + TOL: owner = it
        else: break
    if owner is None: print('ORPHAN', repr(t), file=sys.stderr); continue
    owner['cols'][c-1].append(t)
def join(ls):
    s=''; prev_sp=False
    for t in ls:
        st = t.strip()
        if not s: s = st
        elif re.match(r'(•|\d+\s*\.(?!\d)|\d+\)|[-–]\s|\(\d+\)|\*)', st): s += '\n' + st
        else: s += (' ' if prev_sp else '') + st
        prev_sp = t.endswith(' ') or t.endswith(' ')
    s = s.replace('ํา', 'ำ')
    s = re.sub('[ \\t]*[\\uf000-\\uf8ff][ \\t]*', '\\n• ', s)
    s = re.sub('\\n+', '\\n', s)
    return '\n'.join(re.sub(r'[ \t]+', ' ', x).strip() for x in s.split('\n')).strip()
res = [{'item_no': it['item_no'], 'section': it['section'], 'page': it['page'],
        'requirement': join(it['cols'][0]), 'criteria': join(it['cols'][1]), 'remark': join(it['cols'][2])} for it in items]

# ---------- SQL seed ----------
NA_ALLOWED = {23, 24, 25, 58, 77}            # CLAUDE.md / spec หัวข้อ 4 (M1)
FREQ_12 = {8, 67, 88, 90}                     # spec หัวข้อ 5: frequency_months = 12
def q(s):
    return "NULL" if s is None or s == '' else "'" + s.replace("'", "''") + "'"
def split_criteria(text):
    # แตกเกณฑ์ย่อยจากเลขลำดับในต้นฉบับ:
    #  - ขึ้นต้นด้วย "1." → แยกตามเลข "N."
    #  - ประโยคนำบรรทัดเดียวแล้วตามด้วย "(1)…(n)" → แยกตาม "(n)" (เช่น ข้อ 6)
    #  - นอกนั้น = เกณฑ์เดียว
    lines = text.split('\n')
    if re.match(r'1\s*\.(?!\d)', text): pat = r'\d+\s*\.(?!\d)'
    elif len(lines) > 1 and lines[1].startswith('(1)') and sum(l.startswith('(1)') for l in lines) == 1: pat = r'\(\d+\)'
    else: return [text]
    parts, cur = [], []
    for line in lines:
        if re.match(pat, line) and cur: parts.append('\n'.join(cur)); cur = []
        cur.append(line)
    parts.append('\n'.join(cur))
    if pat.startswith(r'\('): parts = parts[1:]          # ตัดประโยคนำ (อยู่ใน criteria_text แล้ว)
    return [re.sub(r'^(\d+\s*\.|\(\d+\))\s*', '', p) for p in parts]
sec_rows, seen = [], set()
for title in sections:
    code, name = title.split(' ', 1)
    code = code.rstrip('.')
    if code in seen: continue
    seen.add(code); sec_rows.append((code, name.strip()))
def sort_key(code):
    a = [int(x) for x in code.split('.')]; return a[0]*100 + (a[1] if len(a) > 1 else 0)
o = ["-- Migration 0002: 12 หมวด / 90 ข้อ / เกณฑ์ย่อย MOPH LAB 2568 (G 0715050 ฉบับปรับปรุงครั้งที่ 3, หัวข้อ 8.1)",
     "-- สร้างอัตโนมัติด้วย scripts/extract_moph2568.py จากข้อความฝังใน docs/MOPH-LAB-2568.pdf — ห้ามแก้ด้วยมือ",
     "-- หมายเหตุ: สัญลักษณ์ bullet ของต้นฉบับ (ฟอนต์ Wingdings) แปลงเป็น '•' ทั้งหมด; คำสะกดตามต้นฉบับทุกตัว",
     ""]
for code, name in sorted(sec_rows, key=lambda r: sort_key(r[0])):
    o.append(f"INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ({q('sec-'+code)}, 'MOPH2568', {q(code)}, {q(name)}, {sort_key(code)});")
o.append("")
for it in res:
    n = it['item_no']; rid = f"req-{n:03d}"
    code = it['section'].split(' ', 1)[0].rstrip('.')
    o.append(f"-- ข้อ {n} (PDF หน้า {it['page']})")
    o.append(f"INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES "
             f"({q(rid)}, 'MOPH2568', {n}, {q('sec-'+code)}, {q(it['requirement'])}, {q(it['criteria'])}, {q(it['remark'])}, {1 if n in NA_ALLOWED else 0}, {12 if n in FREQ_12 else 'NULL'});")
    for k, c in enumerate(split_criteria(it['criteria']), 1):
        o.append(f"INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ({q(f'crit-{n:03d}-{k}')}, {q(rid)}, {k}, {q(c)}, NULL);")
open(out, 'w').write('\n'.join(o) + '\n')
print('sections', len(sec_rows), 'items', len(res), 'criteria', sum(len(split_criteria(i['criteria'])) for i in res))
