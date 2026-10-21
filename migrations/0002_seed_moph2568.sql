-- Migration 0002: 12 หมวด / 90 ข้อ / เกณฑ์ย่อย MOPH LAB 2568 (G 0715050 ฉบับปรับปรุงครั้งที่ 3, หัวข้อ 8.1)
-- สร้างอัตโนมัติด้วย scripts/extract_moph2568.py จากข้อความฝังใน docs/MOPH-LAB-2568.pdf — ห้ามแก้ด้วยมือ
-- หมายเหตุ: สัญลักษณ์ bullet ของต้นฉบับ (ฟอนต์ Wingdings) แปลงเป็น '•' ทั้งหมด; คำสะกดตามต้นฉบับทุกตัว

INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-1', 'MOPH2568', '1', 'องค์กรและการบริหาร', 100);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-2', 'MOPH2568', '2', 'ระบบเอกสารคุณภาพ', 200);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-2.1', 'MOPH2568', '2.1', 'เอกสารคุณภาพ', 201);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-2.2', 'MOPH2568', '2.2', 'บันทึกคุณภาพ', 202);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-3', 'MOPH2568', '3', 'บุคลากร', 300);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-4', 'MOPH2568', '4', 'สถานที่และสภาวะแวดล้อม', 400);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-4.1', 'MOPH2568', '4.1', 'สถานที่', 401);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-4.2', 'MOPH2568', '4.2', 'สภาวะแวดล้อม', 402);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-5', 'MOPH2568', '5', 'การจัดซื้อและใช้บริการจากภายนอก', 500);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-6', 'MOPH2568', '6', 'เครื่องมือและวัสดุวิทยาศาสตร์', 600);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-6.1', 'MOPH2568', '6.1', 'เครื่องมือ', 601);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-6.2', 'MOPH2568', '6.2', 'วัสดุวิทยาศาสตร์', 602);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-7', 'MOPH2568', '7', 'การควบคุมกระบวนการ', 700);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-7.1', 'MOPH2568', '7.1', 'กระบวนการก่อนการทดสอบ', 701);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-7.2', 'MOPH2568', '7.2', 'กระบวนการทดสอบ', 702);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-7.3', 'MOPH2568', '7.3', 'กระบวนการหลังการทดสอบ', 703);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-8', 'MOPH2568', '8', 'การประกันคุณภาพ', 800);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-8.1', 'MOPH2568', '8.1', 'การควบคุมคุณภาพภายใน (Internal Quality Control, IQC)', 801);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-8.2', 'MOPH2568', '8.2', 'การประเมินคุณภาพจากองค์กรภายนอก (External Quality Assessment), EQA)', 802);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9', 'MOPH2568', '9', 'ความปลอดภัยในห้องปฏิบัติการ', 900);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.1', 'MOPH2568', '9.1', 'การบริหารจัดการความปลอดภัย', 901);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.2', 'MOPH2568', '9.2', 'ความปลอดภัยด้านอัคคีภัย', 902);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.3', 'MOPH2568', '9.3', 'อันตรายทางกายภาพและสารเคมี', 903);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.4', 'MOPH2568', '9.4', 'อุบัติการณ์และเหตุฉุกเฉิน', 904);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.5', 'MOPH2568', '9.5', 'ความปลอดภัยส่วนบุคคลและการปฏิบัติงาน', 905);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.6', 'MOPH2568', '9.6', 'ความปลอดภัยทางชีวภาพ', 906);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-9.7', 'MOPH2568', '9.7', 'การจัดการขยะ', 907);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-10', 'MOPH2568', '10', 'การจัดการเหตุการณ์', 1000);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-10.1', 'MOPH2568', '10.1', 'ข้อร้องเรียน (Complaints)', 1001);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-10.2', 'MOPH2568', '10.2', 'สิ่งที่ไม่สอดคล้องกับข้อกำหนด (Nonconformities)', 1002);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-10.3', 'MOPH2568', '10.3', 'การจัดการความเสี่ยง (Risk Management)', 1003);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-11', 'MOPH2568', '11', 'กระบวนการพัฒนาอย่างต่อเนื่อง', 1100);
INSERT INTO req_sections (id, std_code, code, title, sort) VALUES ('sec-12', 'MOPH2568', '12', 'การประเมินผล (Evaluation)', 1200);

-- ข้อ 1 (PDF หน้า 10)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-001', 'MOPH2568', 1, 'sec-1', 'ห้องปฏิบัติการหรือองค์กรที่มีห้องปฏิบัติการอยู่ในสังกัดมีการดำเนินกิจกรรมอย่างถูกต้องตามกฎหมาย', 'มีหลักฐานการขออนุญาตจัดตั้งสถานพยาบาล/ห้องปฏิบัติการ
*ห้องปฏิบัติการภาครัฐถือว่าเป็นหน่วยงานที่ถูกต้องตามกฎหมาย', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-001-1', 'req-001', 1, 'มีหลักฐานการขออนุญาตจัดตั้งสถานพยาบาล/ห้องปฏิบัติการ
*ห้องปฏิบัติการภาครัฐถือว่าเป็นหน่วยงานที่ถูกต้องตามกฎหมาย', NULL);
-- ข้อ 2 (PDF หน้า 10)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-002', 'MOPH2568', 2, 'sec-1', 'ห้องปฏิบัติการมีการจัดโครงสร้างการบริหารองค์กรที่ทำให้มั่นใจว่าห้องปฏิบัติการสามารถดำเนินงานให้เป็นไปตามระบบคุณภาพที่กำหนดไว้', '1. โครงสร้างการบริหารที่มีห้องปฏิบัติการอยู่ในสังกัดต้องแสดงให้เห็นความเชื่อมโยงของห้องปฏิบัติการและหน่วยสนับสนุนที่เกี่ยวข้อง กับการดำเนินงานตามระบบคุณภาพ
• สายการบังคับบัญชา
• สายประสานงาน
2. มีผังโครงสร้างการบริหารของห้องปฏิบัติการซึ่งแสดงการจัดแบ่งงานภายในห้องปฏิบัติการ
3. มีผังโครงสร้างสายงานความรับผิดชอบของห้องปฏิบัติการแสดงความสัมพันธ์ระหว่างบุคลากร', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-002-1', 'req-002', 1, 'โครงสร้างการบริหารที่มีห้องปฏิบัติการอยู่ในสังกัดต้องแสดงให้เห็นความเชื่อมโยงของห้องปฏิบัติการและหน่วยสนับสนุนที่เกี่ยวข้อง กับการดำเนินงานตามระบบคุณภาพ
• สายการบังคับบัญชา
• สายประสานงาน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-002-2', 'req-002', 2, 'มีผังโครงสร้างการบริหารของห้องปฏิบัติการซึ่งแสดงการจัดแบ่งงานภายในห้องปฏิบัติการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-002-3', 'req-002', 3, 'มีผังโครงสร้างสายงานความรับผิดชอบของห้องปฏิบัติการแสดงความสัมพันธ์ระหว่างบุคลากร', NULL);
-- ข้อ 3 (PDF หน้า 10)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-003', 'MOPH2568', 3, 'sec-1', 'ห้องปฏิบัติการมีการกำหนดวิสัยทัศน์ พันธกิจ นโยบายคุณภาพ วัตถุประสงค์คุณภาพ และดัชนีชี้วัดคุณภาพ', '1 . ผู้บริหารสูงสุดของห้องปฏิบัติการต้องเป็นผู้กำหนดนโยบายคุณภาพ ซึ่งอย่างน้อยต้องครอบคลุม
• ขอบเขตการให้บริการ
• มาตรฐานบริการ
• การรักษาความลับและความเป็นกลาง
• ความปลอดภัยของผู้รับบริการและผู้ให้บริการ
• การพัฒนาอย่างต่อเนื่อง
• การสนับสนุนทรัพยากร
2. มีการจัดทำวัตถุประสงค์ด้านคุณภาพที่สอดคล้องกับนโยบายคุณภาพและต้องวัดได้
3. มีการจัดทำคู่มือคุณภาพ ซึ่งครอบคลุม
• นโยบายและวัตถุประสงค์คุณภาพ
• โครงสร้างองค์กร
• หน้าที่ความรับผิดชอบของผู้บริหารสูงสุดและตำแหน่งงานตามโครงสร้างองค์กร
• แนวทางการดำเนินงานตาม 12 ข้อกำหนดที่ระบุในมาตรฐานนี้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-003-1', 'req-003', 1, 'ผู้บริหารสูงสุดของห้องปฏิบัติการต้องเป็นผู้กำหนดนโยบายคุณภาพ ซึ่งอย่างน้อยต้องครอบคลุม
• ขอบเขตการให้บริการ
• มาตรฐานบริการ
• การรักษาความลับและความเป็นกลาง
• ความปลอดภัยของผู้รับบริการและผู้ให้บริการ
• การพัฒนาอย่างต่อเนื่อง
• การสนับสนุนทรัพยากร', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-003-2', 'req-003', 2, 'มีการจัดทำวัตถุประสงค์ด้านคุณภาพที่สอดคล้องกับนโยบายคุณภาพและต้องวัดได้', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-003-3', 'req-003', 3, 'มีการจัดทำคู่มือคุณภาพ ซึ่งครอบคลุม
• นโยบายและวัตถุประสงค์คุณภาพ
• โครงสร้างองค์กร
• หน้าที่ความรับผิดชอบของผู้บริหารสูงสุดและตำแหน่งงานตามโครงสร้างองค์กร
• แนวทางการดำเนินงานตาม 12 ข้อกำหนดที่ระบุในมาตรฐานนี้', NULL);
-- ข้อ 4 (PDF หน้า 11)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-004', 'MOPH2568', 4, 'sec-1', 'ห้องปฏิบัติการมีการจัดทำแนวทางในการรักษาความลับ สิทธิของผู้ป่วย และความเป็นกลาง', 'มีวิธีปฏิบัติในการรักษาความลับ สิทธิของผู้ป่วย และความเป็นกลาง', 'ดำเนินการตราม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-004-1', 'req-004', 1, 'มีวิธีปฏิบัติในการรักษาความลับ สิทธิของผู้ป่วย และความเป็นกลาง', NULL);
-- ข้อ 5 (PDF หน้า 11)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-005', 'MOPH2568', 5, 'sec-1', 'ห้องปฏิบัติการมีแนวทางในการสื่อสารทั้งภายในและภายนอกห้องปฏิบัติการที่เกี่ยวข้องกับระบบบริหารคุณภาพห้องปฏิบัติการ เพื่อให้มั่นใจว่ากระบวนการสื่อสารเหมาะสม เป็นที่ยอมรับระหว่าง ห้องปฏิบัติการกับผู้รับบริการและผู้มีส่วนได้ส่วนเสีย', 'มีวิธีปฏิบัติในการสื่อสารที่มีประสิทธิภาพ โดยกำหนดข้อมูลที่จำเป็น และช่องทางการสื่อสารที่เหมาะสมสำหรับผู้รับบริการ และผู้มีส่วนได้ส่านเสีย', 'วิธีปฏิบัติอย่างน้อยต้องการกำหนด
1.ช่องทางในการสื่อสาร
2.ข้อมูลที่จะสื่อสาร
3.สื่อสารไปให้ใคร (ผู้รับการสื่อสาร)', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-005-1', 'req-005', 1, 'มีวิธีปฏิบัติในการสื่อสารที่มีประสิทธิภาพ โดยกำหนดข้อมูลที่จำเป็น และช่องทางการสื่อสารที่เหมาะสมสำหรับผู้รับบริการ และผู้มีส่วนได้ส่านเสีย', NULL);
-- ข้อ 6 (PDF หน้า 12)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-006', 'MOPH2568', 6, 'sec-2.1', 'ห้องปฏิบัติการต้องมีระบบควบคุมเอกสารที่จัดทำภายในห้องปฏิบัติการและเอกสารจากภายนอกที่นำมาใช้ในการดำเนินงานของระบบคุณภาพทั้งหมด', 'มีวิธีปฏิบัติในการควบคุมเอกสารซึ่ง ต้องครอบคลุมขั้นตอนดังนี้
(1) การจำแนกระดับเอกสาร
(2) รูปแบบเอกสาร
• องค์ประกอบของเอกสาร ได้แก่หน้าปก, บันทึกการแก้ไข, สารบัญ, เนื้อเรื่อง และภาคผนวก
• รูปหน้าแต่ละหน้าของเอกสารแต่ละระดับ
(3) การให้รหัส
(4) ผู้รับผิดชอบในการ จัดทำ และอนุมัติใช้
(5) ขั้นตอน การจัดทำเอกสารใหม่, การแก้ไข และ ยกเลิก
• การชี้บ่งการแก้ไข และการแก้ไขด้วยลายมือ
(6) การแจกจ่าย
• ผู้ใช้งานและ หน่วยตรวจประเมิน
(7) การเก็บรักษา
(8) การควบคุมและการเข้าถึงเอกสาร
• Master list, Controlled copy และการเข้าถึงโดยบุคคลภายนอก
(9) การทบทวนเอกสาร', '• มีบัญชีรายชื่อเอกสาร ควบคุมที่เป็นปัจจุบัน
• การชี้บ่งเอกสารควบคุม', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-1', 'req-006', 1, 'การจำแนกระดับเอกสาร', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-2', 'req-006', 2, 'รูปแบบเอกสาร
• องค์ประกอบของเอกสาร ได้แก่หน้าปก, บันทึกการแก้ไข, สารบัญ, เนื้อเรื่อง และภาคผนวก
• รูปหน้าแต่ละหน้าของเอกสารแต่ละระดับ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-3', 'req-006', 3, 'การให้รหัส', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-4', 'req-006', 4, 'ผู้รับผิดชอบในการ จัดทำ และอนุมัติใช้', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-5', 'req-006', 5, 'ขั้นตอน การจัดทำเอกสารใหม่, การแก้ไข และ ยกเลิก
• การชี้บ่งการแก้ไข และการแก้ไขด้วยลายมือ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-6', 'req-006', 6, 'การแจกจ่าย
• ผู้ใช้งานและ หน่วยตรวจประเมิน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-7', 'req-006', 7, 'การเก็บรักษา', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-8', 'req-006', 8, 'การควบคุมและการเข้าถึงเอกสาร
• Master list, Controlled copy และการเข้าถึงโดยบุคคลภายนอก', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-006-9', 'req-006', 9, 'การทบทวนเอกสาร', NULL);
-- ข้อ 7 (PDF หน้า 13)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-007', 'MOPH2568', 7, 'sec-2.1', 'ห้องปฏิบัติการมีการแจกจ่ายเอกสารไปยังพื้นที่ที่ต้องการใช้งานและเป็นฉบับปัจจุบัน', 'มีบัญชีรายชื่อเอกสาร (Master list) และมีวิธีการแจกจ่ายเอกสารฉบับปัจจุบันทั้งเอกสารที่เป็น Hard copy / Electronic', '-มีหลักฐานการแจกจ่ายเอกสารฉบับปัจจุบัน -สุ่มตรวจสอบเอกสารทีใช้งานเป็นฉบับปัจจุบันตรงกับที่ระบุใน master list', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-007-1', 'req-007', 1, 'มีบัญชีรายชื่อเอกสาร (Master list) และมีวิธีการแจกจ่ายเอกสารฉบับปัจจุบันทั้งเอกสารที่เป็น Hard copy / Electronic', NULL);
-- ข้อ 8 (PDF หน้า 13)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-008', 'MOPH2568', 8, 'sec-2.1', 'เอกสารคุณภาพต้องได้รับการทบทวนอย่างน้อยปีละหนึ่งครั้ง', 'มีบันทึกการทบทวนเอกสารคุณภาพ', NULL, 0, 12);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-008-1', 'req-008', 1, 'มีบันทึกการทบทวนเอกสารคุณภาพ', NULL);
-- ข้อ 9 (PDF หน้า 13)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-009', 'MOPH2568', 9, 'sec-2.1', 'เอกสารคุณภาพที่ยกเลิกต้องมีการชี้บ่งและนำออกจากพื้นที่ที่ใช้งาน', 'มีวิธีการชี้บ่งเอกสารที่ยกเลิกแล้วและการเก็บรักษาตามระยะเวลาที่กำหนด', 'ฉบับที่ยกเลิกล่าสุดต้องเก็บไม่น้อยกว่าระยะเวลาที่ให้การรับรอง (4 ปี)', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-009-1', 'req-009', 1, 'มีวิธีการชี้บ่งเอกสารที่ยกเลิกแล้วและการเก็บรักษาตามระยะเวลาที่กำหนด', NULL);
-- ข้อ 10 (PDF หน้า 13)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-010', 'MOPH2568', 10, 'sec-2.1', 'การเก็บรักษาเอกสารคุณภาพ ต้องสามารถป้องกัน การเข้าถึง การแก้ไขหรือเปลี่ยนแปลงโดยผู้ที่ไม่ได้รับอนุญาต', 'ตรวจสอบวิธีการเก็บรักษาเอกสารต้นฉบับ Hard copy / Electronic', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-010-1', 'req-010', 1, 'ตรวจสอบวิธีการเก็บรักษาเอกสารต้นฉบับ Hard copy / Electronic', NULL);
-- ข้อ 11 (PDF หน้า 13)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-011', 'MOPH2568', 11, 'sec-2.2', 'ห้องปฏิบัติการต้องมีแนวทางในการควบคุมบันทึกคุณภาพทั้งที่อยู่ในรูปแบบเอกสาร และหรืออิเล็กทรอนิกส์ เพื่อให้มั่นใจว่าบันทึกกิจกรรมการดำเนินงานของห้องปฏิบัติการทั้งหมด จะได้รับการจัดทำ แก้ไข จัดเก็บในสถานที่ที่เหมาะสมตามระยะเวลาที่กำหนดไว้ และสามารถนำกลับมาใช้ได้เมื่อมีความจำเป็น', 'มีวิธีปฏิบัติในการควบคุมบันทึกคุณภาพ ซึ่งต้องครอบคลุมขั้นตอน
• การจัดทำ
• การแก้ไข
• การจัดเก็บ
• การเข้าถึง
• การตรวจสอบและการทำลาย', 'กรณีจัดเก็บเป็น Electronic ต้องมีการสำรองข้อมูลไว้', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-011-1', 'req-011', 1, 'มีวิธีปฏิบัติในการควบคุมบันทึกคุณภาพ ซึ่งต้องครอบคลุมขั้นตอน
• การจัดทำ
• การแก้ไข
• การจัดเก็บ
• การเข้าถึง
• การตรวจสอบและการทำลาย', NULL);
-- ข้อ 12 (PDF หน้า 14)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-012', 'MOPH2568', 12, 'sec-2.2', 'การแก้ไขบันทึกคุณภาพต้องระบุวันที่เวลาที่แก้ไขและบุคคลผู้แก้ไข ต้องสามารถทวนสอบไปยังต้นฉบับ ทั้งต้นฉบับและข้อมูลที่แก้ไข/fileที่แก้ต้องถูกเก็บรักษาไว้', 'ตรวจสอบบันทึกคุณภาพที่ได้รับการแก้ไข ในกรณี Hard copy ยังคงเห็นข้อมูลเดิม แต่ในกรณี Electronic ต้องดูว่ายังเก็บข้อมูลเดิมไว้', 'กรณีเก็บแบบ electronic ซึ่งเมื่อมีการแก้ไขแล้ว จะทับข้อมูลเดิม ต้องมีวิธีบันทึกให้สามารถสอบกลับไปยังข้อมูลเก่าได้', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-012-1', 'req-012', 1, 'ตรวจสอบบันทึกคุณภาพที่ได้รับการแก้ไข ในกรณี Hard copy ยังคงเห็นข้อมูลเดิม แต่ในกรณี Electronic ต้องดูว่ายังเก็บข้อมูลเดิมไว้', NULL);
-- ข้อ 13 (PDF หน้า 14)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-013', 'MOPH2568', 13, 'sec-2.2', 'ห้องปฏิบัติการมีการกำหนด ระยะเวลาเก็บรักษาบันทึกคุณภาพต่างๆที่เกี่ยวข้องกับระบบคุณภาพ โดยพิจารณาจากข้อกำหนดระบบคุณภาพ ความต้องการของผู้รับบริการและตามที่กฎ ระเบียบระบุ', 'มีระบุระยะเวลาการเก็บรักษาบันทึกคุณภาพต่างๆ', 'ตามข้อกำหนดของหน่วยรับรอง (4 ปี)', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-013-1', 'req-013', 1, 'มีระบุระยะเวลาการเก็บรักษาบันทึกคุณภาพต่างๆ', NULL);
-- ข้อ 14 (PDF หน้า 14)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-014', 'MOPH2568', 14, 'sec-2.2', 'ห้องปฏิบัติการต้องจัดหาสถานที่ที่มีสิ่งอำนวยความสะดวก สภาพแวดล้อมที่เหมาะสมสำหรับ การจัดเก็บบันทึกคุณภาพ เพื่อป้องกัน ความเสียหาย เสื่อมสภาพ สูญหาย หรือการเข้าถึงโดยผู้ที่ไม่ได้รับอนุญาต', '1. ตรวจสอบการเข้าถึงบันทึกคุณภาพ โดยสุ่มบันทึกที่ต้องการให้ค้นหา
2. ตรวจสอบสถานที่ที่จัดเก็บบันทึกคุณภาพ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-014-1', 'req-014', 1, 'ตรวจสอบการเข้าถึงบันทึกคุณภาพ โดยสุ่มบันทึกที่ต้องการให้ค้นหา', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-014-2', 'req-014', 2, 'ตรวจสอบสถานที่ที่จัดเก็บบันทึกคุณภาพ', NULL);
-- ข้อ 15 (PDF หน้า 15)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-015', 'MOPH2568', 15, 'sec-3', 'ห้องปฏิบัติการต้องมีการบริหารจัดการบุคลากรให้มีจำนวนเพียงพอและมีคุณสมบัติเหมาะสมกับกิจกรรมที่ให้บริการ', 'มีวิธีปฏิบัติในการบริหารจัดการบุคลากร ซึ่งมีรายละเอียดครอบคลุม
• การกำหนดความต้องการ
• การจัดหา
• การมอบหมายหน้าที่ความรับผิดชอบ
• การฝึกอบรมบุคลากรใหม่
• การพัฒนาบุคลากร การประเมิน Competency', 'การมอบหมายหน้าที่ครอบคลุม POCT', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-015-1', 'req-015', 1, 'มีวิธีปฏิบัติในการบริหารจัดการบุคลากร ซึ่งมีรายละเอียดครอบคลุม
• การกำหนดความต้องการ
• การจัดหา
• การมอบหมายหน้าที่ความรับผิดชอบ
• การฝึกอบรมบุคลากรใหม่
• การพัฒนาบุคลากร การประเมิน Competency', NULL);
-- ข้อ 16 (PDF หน้า 15)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-016', 'MOPH2568', 16, 'sec-3', 'ห้องปฏิบัติการมีการจัดอัตรากำลังให้เหมาะสมกับปริมาณงาน และสามารถตอบสนองความต้องการของผู้รับบริการได้อย่างมีประสิทธิภาพ', '1. มีวิธีปฏิบัติในการวิเคราะห์อัตรากำลัง โดยใช้วิธีการวิเคราะห์ที่สะท้อนภาระงานที่ปฏิบัติจริง เช่น TAT ข้อร้องเรียน ผลสำรวจความพึงพอใจ
2. มีบันทึกแนวทางแก้ไขเมื่อพบว่าอัตรากำลังไม่เพียงพอ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-016-1', 'req-016', 1, 'มีวิธีปฏิบัติในการวิเคราะห์อัตรากำลัง โดยใช้วิธีการวิเคราะห์ที่สะท้อนภาระงานที่ปฏิบัติจริง เช่น TAT ข้อร้องเรียน ผลสำรวจความพึงพอใจ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-016-2', 'req-016', 2, 'มีบันทึกแนวทางแก้ไขเมื่อพบว่าอัตรากำลังไม่เพียงพอ', NULL);
-- ข้อ 17 (PDF หน้า 15)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-017', 'MOPH2568', 17, 'sec-3', 'บุคลากรได้รับการพัฒนาความรู้ความสามารถอย่างต่อเนื่องและเหมาะสมกับกิจกรรมที่ให้บริการ รวมถึง POCT', '1. มีวิธีปฏิบัติในการค้นหา Training need
2. มีการจัดทำแผนฝึกอบรมบุคลากรประจำปี
3. มีบันทึกการฝึกอบรมตามแผน', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-017-1', 'req-017', 1, 'มีวิธีปฏิบัติในการค้นหา Training need', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-017-2', 'req-017', 2, 'มีการจัดทำแผนฝึกอบรมบุคลากรประจำปี', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-017-3', 'req-017', 3, 'มีบันทึกการฝึกอบรมตามแผน', NULL);
-- ข้อ 18 (PDF หน้า 15)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-018', 'MOPH2568', 18, 'sec-3', 'ห้องปฏิบัติการมีการประเมินความสามารถ (Competency) บุคลากรทุกระดับในการปฏิบัติงาน', 'มีวิธีปฏิบัติในการประเมิน Competency ของบุคลากรทุกระดับ ซึ่งต้องครอบคลุม
• การกำหนดประเภทของงานที่ต้องการประเมิน โดยแยกตามตำแหน่งและระดับของบุคลากร
• จัดทำแผนการประเมิน โดยระบุ
- ความรู้ ความสามารถและทักษะที่ต้องการ
- วิธีการ
- ความถี่
- ผู้รับผิดชอบ ผู้รับผิดชอบดำเนินการประเมินโดยกำหนดเกณฑ์การประเมิน และแบบบันทึกผลประเมินให้สอดคล้องกับวิธีการที่กำหนดไว้ในแผน', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-018-1', 'req-018', 1, 'มีวิธีปฏิบัติในการประเมิน Competency ของบุคลากรทุกระดับ ซึ่งต้องครอบคลุม
• การกำหนดประเภทของงานที่ต้องการประเมิน โดยแยกตามตำแหน่งและระดับของบุคลากร
• จัดทำแผนการประเมิน โดยระบุ
- ความรู้ ความสามารถและทักษะที่ต้องการ
- วิธีการ
- ความถี่
- ผู้รับผิดชอบ ผู้รับผิดชอบดำเนินการประเมินโดยกำหนดเกณฑ์การประเมิน และแบบบันทึกผลประเมินให้สอดคล้องกับวิธีการที่กำหนดไว้ในแผน', NULL);
-- ข้อ 19 (PDF หน้า 16)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-019', 'MOPH2568', 19, 'sec-3', 'ห้องปฏิบัติการมีการจัดทำบันทึกบุคลากร ประกอบด้วย ประวัติการศึกษา ใบประกอบวิชาชีพ หน้าที่รับผิดชอบ ประสบการณ์ ผลการประเมินความสามารถในการปฏิบัติงาน (Competency) การรับวัคซีน ประวัติการเกิดอุบัติเหตุจากการทำงาน ผลการตรวจสุขภาพ', 'มีบันทึกบุคลากร หรือแบบฟอร์ม ประกอบด้วย
• ประวัติการศึกษา และฝึกอบรม
• ใบประกอบวิชาชีพ(ถ้ามี)
• หน้าที่รับผิดชอบ
• ประสบการณ์
• ผลการประเมินความสามารถในการปฏิบัติงาน(Competency)
• ประวัติการรับวัคซีน
• ประวัติการเกิดอุบัติเหตุจากการทำงาน
• ผลการตรวจสุขภาพ
• ความสามารถพิเศษ (ถ้ามี)', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-019-1', 'req-019', 1, 'มีบันทึกบุคลากร หรือแบบฟอร์ม ประกอบด้วย
• ประวัติการศึกษา และฝึกอบรม
• ใบประกอบวิชาชีพ(ถ้ามี)
• หน้าที่รับผิดชอบ
• ประสบการณ์
• ผลการประเมินความสามารถในการปฏิบัติงาน(Competency)
• ประวัติการรับวัคซีน
• ประวัติการเกิดอุบัติเหตุจากการทำงาน
• ผลการตรวจสุขภาพ
• ความสามารถพิเศษ (ถ้ามี)', NULL);
-- ข้อ 20 (PDF หน้า 17)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-020', 'MOPH2568', 20, 'sec-4.1', 'ห้องปฏิบัติการต้องจัดหาพื้นที่ให้เพียงพอ เหมาะสมกับการดำเนินกิจกรรมของห้องปฏิบัติการ เพื่อให้มั่นใจว่าผู้รับบริการและเจ้าหน้าที่ห้องปฏิบัติการจะได้รับความสะดวกและความปลอดภัย', '1. มีการจัดแบ่งพื้นที่ตามกิจกรรมของห้องปฏิบัติการ ได้แก่
• บริการผู้ป่วยนอก
• ดำเนินงานห้องปฏิบัติการ (รับสิ่งส่งตรวจ, เตรียมสิ่งส่งตรวจ, วิเคราะห์สิ่งส่งตรวจ, รายงานผล, เก็บสิ่งส่งตรวจหลังการวิเคราะห์)
• ดำเนินงานด้านเอกสาร
• คลังวัสดุวิทยาศาสตร์
• สวัสดิการเจ้าหน้าที่
• รับบริจาคโลหิต (ถ้ามี)
2. มีการชี้บ่งให้ชัดเจนและถูกต้องตาม Biosafety level', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-020-1', 'req-020', 1, 'มีการจัดแบ่งพื้นที่ตามกิจกรรมของห้องปฏิบัติการ ได้แก่
• บริการผู้ป่วยนอก
• ดำเนินงานห้องปฏิบัติการ (รับสิ่งส่งตรวจ, เตรียมสิ่งส่งตรวจ, วิเคราะห์สิ่งส่งตรวจ, รายงานผล, เก็บสิ่งส่งตรวจหลังการวิเคราะห์)
• ดำเนินงานด้านเอกสาร
• คลังวัสดุวิทยาศาสตร์
• สวัสดิการเจ้าหน้าที่
• รับบริจาคโลหิต (ถ้ามี)', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-020-2', 'req-020', 2, 'มีการชี้บ่งให้ชัดเจนและถูกต้องตาม Biosafety level', NULL);
-- ข้อ 21 (PDF หน้า 17)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-021', 'MOPH2568', 21, 'sec-4.1', 'พื้นที่บริการผู้ป่วยนอกต้องออกแบบให้สะดวกในการเข้ารับบริการของผู้ป่วย เด็ก ผู้สูงอายุ และผู้พิการ', '1. มีการจัดพื้นที่บริการผู้ป่วยนอก ประกอบด้วยพื้นที่ ดังนี้
• เก็บสิ่งส่งตรวจโดยเจ้าหน้าที่ห้องปฏิบัติการ ได้แก่ เจาะเลือด Skin Scraping สิ่งส่งตรวจจากระบบทางเดินหายใจ
• เก็บสิ่งส่งตรวจโดยผู้ป่วย ได้แก่ ปัสสาวะ อุจจาระ เสมหะ น้ำอสุจิ
• พื้นที่พักรอคอยของผู้ป่วย ญาติ และผู้ติดตาม (ผู้นั่งรถเข็นและเปลนอน)
2. มีระบบจัดการให้เกิดความปลอดภัยและความเป็นส่วนตัว', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-021-1', 'req-021', 1, 'มีการจัดพื้นที่บริการผู้ป่วยนอก ประกอบด้วยพื้นที่ ดังนี้
• เก็บสิ่งส่งตรวจโดยเจ้าหน้าที่ห้องปฏิบัติการ ได้แก่ เจาะเลือด Skin Scraping สิ่งส่งตรวจจากระบบทางเดินหายใจ
• เก็บสิ่งส่งตรวจโดยผู้ป่วย ได้แก่ ปัสสาวะ อุจจาระ เสมหะ น้ำอสุจิ
• พื้นที่พักรอคอยของผู้ป่วย ญาติ และผู้ติดตาม (ผู้นั่งรถเข็นและเปลนอน)', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-021-2', 'req-021', 2, 'มีระบบจัดการให้เกิดความปลอดภัยและความเป็นส่วนตัว', NULL);
-- ข้อ 22 (PDF หน้า 18)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-022', 'MOPH2568', 22, 'sec-4.1', 'พื้นที่ดำเนินงานของห้องปฏิบัติการต้องออกแบบให้เหมาะสมกับขั้นตอนของการปฏิบัติงาน ตั้งแต่ขั้นตอนการรับสิ่งส่งตรวจ การเตรียมสิ่งส่งตรวจ การตรวจวิเคราะห์ การรายงานผล และการเก็บตัวอย่างหลังการวิเคราะห์', '1. มีการจัดวางเครื่องมือและอุปกรณ์ สอดคล้องกับ ขั้นตอนการปฏิบัติงาน (Workflow)
2. มีการแยกพื้นที่ ดังนี้
• เก็บสิ่งส่งตรวจก่อนและหลังการตรวจวิเคราะห์
• เก็บอุปกรณ์และน้ำยาตรวจวิเคราะห์ ต้องแยกตู้เย็นในการเก็บรักษาน้ำยาและสิ่งส่งตรวจเพื่อป้องกันการปนเปื้อน', 'กรณีที่มีความจำเป็นต้องเก็บน้ำยาและสิ่งส่งตรวจในตู้เย็นเดียวกัน ต้องเก็บแยกชั้นและมีระบบป้องกันการปนเปื้อนระหว่างน้ำยากับสิ่งส่งตรวจ', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-022-1', 'req-022', 1, 'มีการจัดวางเครื่องมือและอุปกรณ์ สอดคล้องกับ ขั้นตอนการปฏิบัติงาน (Workflow)', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-022-2', 'req-022', 2, 'มีการแยกพื้นที่ ดังนี้
• เก็บสิ่งส่งตรวจก่อนและหลังการตรวจวิเคราะห์
• เก็บอุปกรณ์และน้ำยาตรวจวิเคราะห์ ต้องแยกตู้เย็นในการเก็บรักษาน้ำยาและสิ่งส่งตรวจเพื่อป้องกันการปนเปื้อน', NULL);
-- ข้อ 23 (PDF หน้า 18)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-023', 'MOPH2568', 23, 'sec-4.1', 'บริเวณเจาะเก็บเลือดจากผู้บริจาคเลือด ต้องแยกออกจากห้องปฏิบัติการ มีอุปกรณ์ที่เพียงพอ สะดวก และปลอดภัย ต่อผู้บริจาค รวมทั้งมีชุดปฐมพยาบาลเบื้องต้นสำหรับผู้รับบริการและผู้ปฏิบัติงาน ตามมาตรฐานศูนย์บริการโลหิตแห่งชาติ', '1. มีบริเวณสำหรับให้ผู้บริจาคเลือดนั่งรอ ไม่แออัด สะอาด มีการระบายอากาศดี
2. มีการใช้ถุงมือขณะปฏิบัติงาน เมื่อใช้แล้วให้ถอดทิ้งไม่นำมาใช้ซ้ำ
3. จัดให้มีถังขยะติดเชื้อสำหรับผู้บริจาคเลือด ทิ้งสำลี และ พลาสเตอร์', '(ตอบ n/a กรณีไม่ได้ดำเนินการ)', 1, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-023-1', 'req-023', 1, 'มีบริเวณสำหรับให้ผู้บริจาคเลือดนั่งรอ ไม่แออัด สะอาด มีการระบายอากาศดี', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-023-2', 'req-023', 2, 'มีการใช้ถุงมือขณะปฏิบัติงาน เมื่อใช้แล้วให้ถอดทิ้งไม่นำมาใช้ซ้ำ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-023-3', 'req-023', 3, 'จัดให้มีถังขยะติดเชื้อสำหรับผู้บริจาคเลือด ทิ้งสำลี และ พลาสเตอร์', NULL);
-- ข้อ 24 (PDF หน้า 18)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-024', 'MOPH2568', 24, 'sec-4.1', 'สถานที่เก็บสิ่งส่งตรวจจากทางเดินหายใจและการเก็บเสมหะ มีอ่างล้างมือ สบู่หรือน้ำยาฆ่าเชื้อ และถังขยะติดเชื้อ และมีระบบความปลอดภัยป้องกันการแพร่กระจายเชื้อ มีเอกสารคำแนะนำในการเก็บเสมหะสำหรับผู้รับบริการ', '1. มีแนวทางการเก็บเสมหะ
2. สถานที่เก็บสิ่งส่งตรวจทางเดินหายใจและการเก็บเสมหะ มีระบบความปลอดภัยตามมาตรฐาน IC ของโรงพยาบาล
3. มีอ่างล้างมือ และสบู่เหลวหรือน้ำยาฆ่าเชื้อ
4. มีถังขยะติดเชื้อ', '(ตอบ n/a กรณีไม่มีการให้บริการ)', 1, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-024-1', 'req-024', 1, 'มีแนวทางการเก็บเสมหะ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-024-2', 'req-024', 2, 'สถานที่เก็บสิ่งส่งตรวจทางเดินหายใจและการเก็บเสมหะ มีระบบความปลอดภัยตามมาตรฐาน IC ของโรงพยาบาล', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-024-3', 'req-024', 3, 'มีอ่างล้างมือ และสบู่เหลวหรือน้ำยาฆ่าเชื้อ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-024-4', 'req-024', 4, 'มีถังขยะติดเชื้อ', NULL);
-- ข้อ 25 (PDF หน้า 19)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-025', 'MOPH2568', 25, 'sec-4.1', 'ห้องน้ำที่ใช้เก็บสิ่งส่งตรวจของผู้รับบริการ ต้องมีความสะอาด สะดวก และแยกสัดส่วนของผู้รับบริการหญิง-ชาย และเหมาะสมสำหรับผู้พิการรวมถึงผู้ติดตาม มีเอกสารคำแนะนำในการเก็บตัวอย่างปัสสาวะและอุจจาระสำหรับผู้รับบริการ', '1. มีห้องน้ำที่ใช้เก็บสิ่งส่งตรวจของผู้รับบริการ สะอาด สะดวก
2. มีการแยกสัดส่วนการเก็บสิ่งส่งตรวจของผู้รับบริการหญิง-ชาย และเหมาะสมสำหรับผู้พิการรวมถึงผู้ติดตาม
3. มีเอกสารคำแนะนำในการเก็บตัวอย่างปัสสาวะและอุจจาระสำหรับผู้รับบริการ', '(ตอบ n/a กรณีไม่มีการให้บริการ)', 1, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-025-1', 'req-025', 1, 'มีห้องน้ำที่ใช้เก็บสิ่งส่งตรวจของผู้รับบริการ สะอาด สะดวก', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-025-2', 'req-025', 2, 'มีการแยกสัดส่วนการเก็บสิ่งส่งตรวจของผู้รับบริการหญิง-ชาย และเหมาะสมสำหรับผู้พิการรวมถึงผู้ติดตาม', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-025-3', 'req-025', 3, 'มีเอกสารคำแนะนำในการเก็บตัวอย่างปัสสาวะและอุจจาระสำหรับผู้รับบริการ', NULL);
-- ข้อ 26 (PDF หน้า 19)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-026', 'MOPH2568', 26, 'sec-4.1', 'ห้องปฏิบัติการมีการควบคุมการเข้าออก เพื่อป้องกันการเข้าถึงข้อมูล เครื่องมือ รวมถึงความมั่นคงและความปลอดภัยทางชีวภาพ โดยผู้ที่ไม่ได้รับมอบหมายหรือไม่ได้รับอนุญาต เช่น การนำเชื้อออกโดยไม่รับอนุญาต', 'มีระบบควบคุมการเข้าออกห้องปฏิบัติการ', 'การเข้าถึง ข้อมูล เครื่องมือ รวมถึงความมั่นคงและความปลอดภัยทางชีวภาพ(Biosecurity) และการนำเชื้อออกโดยไม่รับอนุญาต', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-026-1', 'req-026', 1, 'มีระบบควบคุมการเข้าออกห้องปฏิบัติการ', NULL);
-- ข้อ 27 (PDF หน้า 19)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-027', 'MOPH2568', 27, 'sec-4.1', 'พื้นที่และสภาวะแวดล้อมการให้บริการทดสอบนอกสถานที่ตั้งของห้องปฏิบัติการ ได้แก่ การทดสอบ ณ จุดดูแลผู้ป่วย (POCT: Point-of-care Testing) ต้องมีสภาวะแวดล้อมที่เหมาะสมตามคำแนะนำของผู้ผลิต และไม่มีผลกระทบต่อความถูกต้องของผลตรวจ มีความสะดวกและปลอดภัยต่อผู้รับบริการและผู้ปฏิบัติงาน', '1. กำหนดสถานที่ในการวางเครื่องมือและพื้นที่ปฏิบัติงานโดยคำนึงถึงความปลอดภัยและความเหมาะสมตามคำแนะนำของบริษัทผู้ผลิต
2. ดูแลรักษาความสะอาดพื้นที่ปฏิบัติงานอย่างสม่ำเสมอ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-027-1', 'req-027', 1, 'กำหนดสถานที่ในการวางเครื่องมือและพื้นที่ปฏิบัติงานโดยคำนึงถึงความปลอดภัยและความเหมาะสมตามคำแนะนำของบริษัทผู้ผลิต', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-027-2', 'req-027', 2, 'ดูแลรักษาความสะอาดพื้นที่ปฏิบัติงานอย่างสม่ำเสมอ', NULL);
-- ข้อ 28 (PDF หน้า 20)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-028', 'MOPH2568', 28, 'sec-4.2', 'ห้องปฏิบัติการมีแสงสว่างเพียงพอและเหมาะสมต่อการปฏิบัติงาน', 'มีแสงสว่างเพียงพอครบทุกพื้นที่ปฏิบัติงาน', 'โดยเฉพาะในบริเวณที่ต้องอ่านผลด้วยตาเปล่า เช่นrapid test & hematocrit มีดวงไฟเฉพาะหรือไม่ รวมถึงจุดเจาะเลือด', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-028-1', 'req-028', 1, 'มีแสงสว่างเพียงพอครบทุกพื้นที่ปฏิบัติงาน', NULL);
-- ข้อ 29 (PDF หน้า 20)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-029', 'MOPH2568', 29, 'sec-4.2', 'ห้องปฏิบัติการมีระบบระบายอากาศ และมีการควบคุมการแพร่กระจายเชื้อและอันตรายจากสารเคมี โดยเฉพาะในการปฏิบัติงานที่มีความเสี่ยง', '1. มีระบบระบายอากาศและควบคุมการแพร่กระจายของสารเคมีที่เหมาะสม เช่น พัดลมดูดอากาศ หรือตู้ดูดควัน (Fume hood)
2. มีระบบควบคุมการแพร่กระจายเชื้อที่เหมาะสม เช่น ตู้ชีวนิรภัย (Biosafety cabinet)', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-029-1', 'req-029', 1, 'มีระบบระบายอากาศและควบคุมการแพร่กระจายของสารเคมีที่เหมาะสม เช่น พัดลมดูดอากาศ หรือตู้ดูดควัน (Fume hood)', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-029-2', 'req-029', 2, 'มีระบบควบคุมการแพร่กระจายเชื้อที่เหมาะสม เช่น ตู้ชีวนิรภัย (Biosafety cabinet)', NULL);
-- ข้อ 30 (PDF หน้า 20)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-030', 'MOPH2568', 30, 'sec-4.2', 'ห้องปฏิบัติการมีการดูแล พื้นที่ปฏิบัติงานให้สะอาด สะดวก ตามหลักวิชาการ', 'มีพื้นที่ปฏิบัติงานสะอาดและถูกต้องตามหลักวิชาการ โดยนำหลัก 5 ส. มาใช้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-030-1', 'req-030', 1, 'มีพื้นที่ปฏิบัติงานสะอาดและถูกต้องตามหลักวิชาการ โดยนำหลัก 5 ส. มาใช้', NULL);
-- ข้อ 31 (PDF หน้า 20)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-031', 'MOPH2568', 31, 'sec-4.2', '- ห้องปฏิบัติการมีการควบคุมสภาวะแวดล้อมที่มีผลกระทบต่อคุณภาพการทดสอบ ได้แก่ อุณหภูมิและความชื้นของห้องปฏิบัติการ ห้องเก็บน้ำยาและวัสดุวิทยาศาสตร์คงคลัง อุณหภูมิของตู้เย็นเก็บสิ่งส่งตรวจ ตู้เย็นเก็บเลือดผู้บริจาคโลหิต น้ำยา สารควบคุมคุณภาพ และตู้อบเพาะเชื้อ
- ห้องปฏิบัติการต้องกำหนดเกณฑ์ที่ใช้ในการควบคุมและบันทึกสภาวะแวดล้อมที่ต้องควบคุม', '1.มีบันทึกสภาวะแวดล้อมที่มีผลกระทบต่อคุณภาพการทดสอบ
(1) บันทึกการควบคุมอุณหภูมิ
(2) บันทึกความชื้น
(3) กรณีไม่อยู่ในเกณฑ์กำหนด มีวิธี/แนวทางแก้ไข
2.มีบันทึกการควบคุมอุณหภูมิ
• ตู้เย็นเก็บสิ่งส่งตรวจ
• ตู้เย็นเก็บเลือดผู้บริจาคโลหิต กรณีห้องปฏิบัติการมีการขนส่งเลือดจากการเบิกจากหน่วยงานภายนอก ต้องมีหลักฐานการควบคุมอุณหภูมิในการขนส่ง
• ตู้เย็นเก็บน้ำยา/สารควบคุมคุณภาพ
• ตู้อบเพาะเชื้อ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-031-1', 'req-031', 1, 'มีบันทึกสภาวะแวดล้อมที่มีผลกระทบต่อคุณภาพการทดสอบ
(1) บันทึกการควบคุมอุณหภูมิ
(2) บันทึกความชื้น
(3) กรณีไม่อยู่ในเกณฑ์กำหนด มีวิธี/แนวทางแก้ไข', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-031-2', 'req-031', 2, 'มีบันทึกการควบคุมอุณหภูมิ
• ตู้เย็นเก็บสิ่งส่งตรวจ
• ตู้เย็นเก็บเลือดผู้บริจาคโลหิต กรณีห้องปฏิบัติการมีการขนส่งเลือดจากการเบิกจากหน่วยงานภายนอก ต้องมีหลักฐานการควบคุมอุณหภูมิในการขนส่ง
• ตู้เย็นเก็บน้ำยา/สารควบคุมคุณภาพ
• ตู้อบเพาะเชื้อ', NULL);
-- ข้อ 32 (PDF หน้า 21)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-032', 'MOPH2568', 32, 'sec-4.2', 'ห้องปฏิบัติการต้องจัดหาระบบไฟฟ้าสำรอง เพื่อให้มั่นใจว่าในสถานการณ์ฉุกเฉินที่ระบบไฟฟ้าขัดข้อง การให้บริการจะปฏิบัติได้อย่างต่อเนื่อง โดยไม่กระทบต่อผลการตรวจวิเคราะห์และความปลอดภัยของผู้รับบริการ', '1. มีการกำหนดเครื่องมือที่จำเป็นต้องมีระบบไฟฟ้าสำรอง
2. มีระบบสำรองไฟฟ้า เช่น UPS ระบบไฟฉุกเฉินของหน่วยงาน
3. มีไฟฟ้าสำรองและพร้อมใช้สำหรับเครื่องมือที่กำหนดไว้', 'เครื่องมือที่จำเป็น ได้แก่
• เครื่องตรวจวิเคราะห์อัตโนมัติ รายการทดสอบ Electrolyte, Blood gas, Troponin)
• ตู้เย็นเก็บเลือด (Blood bank refrigerator)
• ตู้เย็นเก็บน้ำยา
• Freezer เก็บเชื้อมาตรฐาน
• Incubator
• Biosafety cabinet
• อื่นๆตามความจำเป็น', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-032-1', 'req-032', 1, 'มีการกำหนดเครื่องมือที่จำเป็นต้องมีระบบไฟฟ้าสำรอง', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-032-2', 'req-032', 2, 'มีระบบสำรองไฟฟ้า เช่น UPS ระบบไฟฉุกเฉินของหน่วยงาน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-032-3', 'req-032', 3, 'มีไฟฟ้าสำรองและพร้อมใช้สำหรับเครื่องมือที่กำหนดไว้', NULL);
-- ข้อ 33 (PDF หน้า 21)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-033', 'MOPH2568', 33, 'sec-5', 'ห้องปฏิบัติการต้องมีวิธีปฏิบัติในการซื้อสินค้าและบริการจากภายนอก เพื่อให้มั่นใจว่า เครื่องมือ อุปกรณ์ น้ำยา วัสดุสิ้นเปลือง และบริการ ซึ่งมีผลกระทบต่อคุณภาพการตรวจวิเคราะห์ จะได้รับการจัดหาให้มีคุณภาพตามความต้องการใช้งาน', 'มีวิธีปฏิบัติในการจัดซื้อและใช้บริการจากภายนอก ซึ่งต้องมีขั้นตอนครอบคลุม
• การคัดเลือกและประเมินผู้ขาย
• การจัดซื้อ
• การตรวจรับ
• การจัดเก็บ
• การควบคุม
• เกณฑ์ในการคัดเลือกผู้ขายรายใหม่
• เกณฑ์ในการประเมินและทบทวนบัญชีรายชื่อผู้ขาย', 'บริการจากภายนอก ได้แก่
• สอบเทียบเครื่องมือ
• การใช้ห้องปฏิบัติการภายนอก
• ผู้ให้บริการ EQA program
• ผู้บริการระบบLIS', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-033-1', 'req-033', 1, 'มีวิธีปฏิบัติในการจัดซื้อและใช้บริการจากภายนอก ซึ่งต้องมีขั้นตอนครอบคลุม
• การคัดเลือกและประเมินผู้ขาย
• การจัดซื้อ
• การตรวจรับ
• การจัดเก็บ
• การควบคุม
• เกณฑ์ในการคัดเลือกผู้ขายรายใหม่
• เกณฑ์ในการประเมินและทบทวนบัญชีรายชื่อผู้ขาย', NULL);
-- ข้อ 34 (PDF หน้า 22)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-034', 'MOPH2568', 34, 'sec-5', 'ห้องปฏิบัติการมีการกำหนด ผู้รับผิดชอบในการกำหนดคุณสมบัติและคัดเลือก เครื่องมือ น้ำยา และวัสดุสิ้นเปลือง ให้สอดคล้องกับความต้องการใช้งานของห้องปฏิบัติการ', 'วิธีปฏิบัติในการจัดซื้อต้องกำหนดผู้รับผิดชอบในการกำหนดคุณสมบัติ และคัดเลือกเครื่องมือ น้ำยา และวัสดุสิ้นเปลือง', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-034-1', 'req-034', 1, 'วิธีปฏิบัติในการจัดซื้อต้องกำหนดผู้รับผิดชอบในการกำหนดคุณสมบัติ และคัดเลือกเครื่องมือ น้ำยา และวัสดุสิ้นเปลือง', NULL);
-- ข้อ 35 (PDF หน้า 22)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-035', 'MOPH2568', 35, 'sec-5', 'ห้องปฏิบัติการมีการทวนสอบคุณภาพของน้ำยา และวัสดุสิ้นเปลืองที่มีผลกระทบต่อคุณภาพบริการ ก่อนนำไปใช้งาน', 'มีวิธีปฏิบัติในการตรวจสอบคุณภาพน้ำยาก่อนนำไปใช้งาน ซึ่งต้องครอบคลุมทุก Lot และทุกการจัดส่ง (Shipment)', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-035-1', 'req-035', 1, 'มีวิธีปฏิบัติในการตรวจสอบคุณภาพน้ำยาก่อนนำไปใช้งาน ซึ่งต้องครอบคลุมทุก Lot และทุกการจัดส่ง (Shipment)', NULL);
-- ข้อ 36 (PDF หน้า 22)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-036', 'MOPH2568', 36, 'sec-5', 'ห้องปฏิบัติการต้องมั่นใจว่า การใช้บริการตรวจวิเคราะห์จากห้องปฏิบัติการภายนอก จะได้รับผลการตรวจวิเคราะห์ที่ถูกต้อง เชื่อถือได้ และส่งถึงผู้รับบริการภายในเวลาที่กำหนด', 'มีวิธีปฏิบัติในการใช้บริการตรวจวิเคราะห์จากห้องปฏิบัติการภายนอกซึ่งต้องมีขั้นตอนครอบคลุม
• การคัดเลือกและการจัดทำบัญชีรายชื่อห้องปฏิบัติการที่ผ่านการคัดเลือก
• การส่งสิ่งส่งตรวจ
• การรับผลการตรวจวิเคราะห์
• การส่งผลการตรวจให้ผู้รับบริการ
• การประเมินทบทวนการให้บริการของห้องปฏิบัติการภายนอก', '• มีบัญชีรายชื่อห้องปฏิบัติการที่ผ่านการคัดเลือก
• มีผลการประเมินห้องปฏิบัติการภายนอก', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-036-1', 'req-036', 1, 'มีวิธีปฏิบัติในการใช้บริการตรวจวิเคราะห์จากห้องปฏิบัติการภายนอกซึ่งต้องมีขั้นตอนครอบคลุม
• การคัดเลือกและการจัดทำบัญชีรายชื่อห้องปฏิบัติการที่ผ่านการคัดเลือก
• การส่งสิ่งส่งตรวจ
• การรับผลการตรวจวิเคราะห์
• การส่งผลการตรวจให้ผู้รับบริการ
• การประเมินทบทวนการให้บริการของห้องปฏิบัติการภายนอก', NULL);
-- ข้อ 37 (PDF หน้า 23)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-037', 'MOPH2568', 37, 'sec-5', 'ห้องปฏิบัติการต้องคัดเลือกและจัดทำบัญชีรายชื่อของผู้ขายสินค้า และผู้ให้บริการที่ผ่านการคัดเลือก', '1. มีผลการคัดเลือกผู้ขายสินค้าและผู้ให้บริการ
2. มีบัญชีรายชื่อผู้ขายสินค้าและผู้ให้บริการ', '• บริการสอบเทียบเครื่องมือ
• บริการระบบ LIS หรือ Software ต่างๆ
• บริการEQA program', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-037-1', 'req-037', 1, 'มีผลการคัดเลือกผู้ขายสินค้าและผู้ให้บริการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-037-2', 'req-037', 2, 'มีบัญชีรายชื่อผู้ขายสินค้าและผู้ให้บริการ', NULL);
-- ข้อ 38 (PDF หน้า 23)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-038', 'MOPH2568', 38, 'sec-5', 'ห้องปฏิบัติการต้องประเมินทบทวนการให้บริการของผู้ขายสินค้า และผู้ให้บริการ', '1. มีเกณฑ์การประเมินทบทวน ที่ครอบคลุมกิจกรรมบริการของผู้ขายและผู้ให้บริการ
2. มีผลการประเมินทบทวน', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-038-1', 'req-038', 1, 'มีเกณฑ์การประเมินทบทวน ที่ครอบคลุมกิจกรรมบริการของผู้ขายและผู้ให้บริการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-038-2', 'req-038', 2, 'มีผลการประเมินทบทวน', NULL);
-- ข้อ 39 (PDF หน้า 23)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-039', 'MOPH2568', 39, 'sec-6.1', 'ห้องปฏิบัติการต้องจัดทำแนวทางหรือวิธีปฏิบัติในการบริหารจัดการเครื่องมือเพื่อให้มีเครื่องมือเพียงพอเหมาะสมและพร้อมใช้งาน', '1. มีแนวทางปฏิบัติในการบริหารจัดการเครื่องมือครอบคลุมขั้นตอน
• การกำหนดความต้องการ
• การคัดเลือกเครื่องมือ
• การจัดหาเครื่องมือ
• การจัดการเครื่องมือใหม่
• การจัดทำประวัติเครื่องมือ
• การจัดทำแผนสอบเทียบและหรือบำรุงรักษาเครื่องมือ
• การทวนสอบผลสอบเทียบ
• การจัดเก็บและดูแลรักษา
• การซ่อมเมื่อเครื่องมือชำรุด
2. มีการชี้บ่งสถานะเครื่องมือ เพื่อป้องกันการใช้เครื่องมือที่ไม่พร้อมใช้งาน เช่น เครื่องมือชำรุด เครื่องมือไม่ได้รับการสอบเทียบตามแผน และผลการสอบเทียบไม่ผ่านเกณฑ์ที่กำหนด', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-039-1', 'req-039', 1, 'มีแนวทางปฏิบัติในการบริหารจัดการเครื่องมือครอบคลุมขั้นตอน
• การกำหนดความต้องการ
• การคัดเลือกเครื่องมือ
• การจัดหาเครื่องมือ
• การจัดการเครื่องมือใหม่
• การจัดทำประวัติเครื่องมือ
• การจัดทำแผนสอบเทียบและหรือบำรุงรักษาเครื่องมือ
• การทวนสอบผลสอบเทียบ
• การจัดเก็บและดูแลรักษา
• การซ่อมเมื่อเครื่องมือชำรุด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-039-2', 'req-039', 2, 'มีการชี้บ่งสถานะเครื่องมือ เพื่อป้องกันการใช้เครื่องมือที่ไม่พร้อมใช้งาน เช่น เครื่องมือชำรุด เครื่องมือไม่ได้รับการสอบเทียบตามแผน และผลการสอบเทียบไม่ผ่านเกณฑ์ที่กำหนด', NULL);
-- ข้อ 40 (PDF หน้า 24)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-040', 'MOPH2568', 40, 'sec-6.1', 'ห้องปฏิบัติการต้องมีการจัดทำประวัติเครื่องมือที่ใช้ในการตรวจวิเคราะห์และเครื่องมือที่เกี่ยวข้องซึ่งมีผลกระทบต่อการตรวจวิเคราะห์', 'มีบันทึกประวัติเครื่องมือซึ่งประกอบด้วย
1) รายละเอียดของเครื่องมือที่สามารถสอบกลับไปยังเครื่องมือแต่ละเครื่องได้ ซึ่งได้แก่ รหัสหรือหมายเลขครุภัณฑ์ รุ่น ยี่ห้อ บริษัทผู้ผลิต ผู้แทนจำหน่ายและคุณลักษณะเฉพาะ
2) บันทึกการบำรุงรักษา/สอบเทียบ/การซ่อม/การปรับแต่งหรือการปรับแก้
3) บันทึกความผิดปกติหรือปัญหาที่พบขณะใช้งานและการแก้ไข
4) ผลการประเมิน Performance ก่อนนำมาใช้งานตามความจำเป็น', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-040-1', 'req-040', 1, 'มีบันทึกประวัติเครื่องมือซึ่งประกอบด้วย
1) รายละเอียดของเครื่องมือที่สามารถสอบกลับไปยังเครื่องมือแต่ละเครื่องได้ ซึ่งได้แก่ รหัสหรือหมายเลขครุภัณฑ์ รุ่น ยี่ห้อ บริษัทผู้ผลิต ผู้แทนจำหน่ายและคุณลักษณะเฉพาะ
2) บันทึกการบำรุงรักษา/สอบเทียบ/การซ่อม/การปรับแต่งหรือการปรับแก้
3) บันทึกความผิดปกติหรือปัญหาที่พบขณะใช้งานและการแก้ไข
4) ผลการประเมิน Performance ก่อนนำมาใช้งานตามความจำเป็น', NULL);
-- ข้อ 41 (PDF หน้า 24)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-041', 'MOPH2568', 41, 'sec-6.1', 'ห้องปฏิบัติการมีคู่มือการใช้เครื่องมือและผู้ใช้เครื่องมือต้องผ่านการฝึกอบรม', '1.มีคู่มือหรือวิธีปฏิบัติในการใช้เครื่องและการบำรุงรักษา
2. มีหลักฐานการฝึกอบรมและการประเมินผลการใช้เครื่องมือตรวจวิเคราะห์สิ่งส่งตรวจของผู้ใช้เครื่องทุกคน เช่น ใบรับรองความสามารถ หรือประกาศนียบัตรผ่านหลักสูตร หรือผลประเมินการใช้เครื่อง', 'เนื้อหาครอบคลุม หัวข้อดังนี้
• วัตถุประสงค์
• หลักการของเครื่อง
• องค์ประกอบของเครื่อง
• วิธีการใช้
• การสอบเทียบ
• การบำรุงรักษา
• ข้อควรระวังในการใช้งาน การติดตั้ง และการเคลื่อนย้าย
• เอกสารที่ใช้บันทึกข้อมูล
• เอกสารอ้างอิง
• ภาคผนวก: คุณลักษณะเฉพาะ(Specification) และ การแก้ไขปัญหา (Troubleshoot)', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-041-1', 'req-041', 1, 'มีคู่มือหรือวิธีปฏิบัติในการใช้เครื่องและการบำรุงรักษา', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-041-2', 'req-041', 2, 'มีหลักฐานการฝึกอบรมและการประเมินผลการใช้เครื่องมือตรวจวิเคราะห์สิ่งส่งตรวจของผู้ใช้เครื่องทุกคน เช่น ใบรับรองความสามารถ หรือประกาศนียบัตรผ่านหลักสูตร หรือผลประเมินการใช้เครื่อง', NULL);
-- ข้อ 42 (PDF หน้า 25)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-042', 'MOPH2568', 42, 'sec-6.1', 'ห้องปฏิบัติการต้องมีการสอบเทียบและหรือบำรุงรักษาเครื่องมือตามความจำเป็น ในการใช้งาน', '1.มีบัญชีรายการเครื่องมือที่ต้องสอบเทียบและหรือบำรุงรักษาโดยอย่างน้อยต้องระบุ ชื่อ ยี่ห้อ/รุ่น Serial No. รหัส/หมายเลขทะเบียน ความต้องการสอบเทียบ/บำรุงรักษา ความถี่ ช่วงค่าที่ใช้งาน parameter ที่ต้องการสอบเทียบ MPE และผู้ดำเนินการ
2. มีแผนสอบเทียบและบำรุงรักษาตามบัญชีรายการที่กำหนด
3. มีผลการสอบเทียบและบำรุงรักษาเครื่องมือ
4. มีบันทึกผลการทวนสอบผลสอบเทียบเครื่องมือและสรุปผลรวมถึงการแก้ไขกรณีที่ผลไม่ผ่านเกณฑ์ที่กำหนดไว้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-042-1', 'req-042', 1, 'มีบัญชีรายการเครื่องมือที่ต้องสอบเทียบและหรือบำรุงรักษาโดยอย่างน้อยต้องระบุ ชื่อ ยี่ห้อ/รุ่น Serial No. รหัส/หมายเลขทะเบียน ความต้องการสอบเทียบ/บำรุงรักษา ความถี่ ช่วงค่าที่ใช้งาน parameter ที่ต้องการสอบเทียบ MPE และผู้ดำเนินการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-042-2', 'req-042', 2, 'มีแผนสอบเทียบและบำรุงรักษาตามบัญชีรายการที่กำหนด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-042-3', 'req-042', 3, 'มีผลการสอบเทียบและบำรุงรักษาเครื่องมือ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-042-4', 'req-042', 4, 'มีบันทึกผลการทวนสอบผลสอบเทียบเครื่องมือและสรุปผลรวมถึงการแก้ไขกรณีที่ผลไม่ผ่านเกณฑ์ที่กำหนดไว้', NULL);
-- ข้อ 43 (PDF หน้า 26)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-043', 'MOPH2568', 43, 'sec-6.1', 'ห้องปฏิบัติการต้องมีการจัดวางเครื่องมือต่างๆ ให้เหมาะสมและ ถูกต้องตามหลักวิชาการ เพื่อป้องกันผลกระทบในขณะการใช้เครื่องมือ และการปนเปื้อนหรือการชำรุดเสียหาย', '1. การจัดวางเครื่องมือที่มีผลกระทบต่อกันขณะใช้เครื่องต้องแยกออกจากกัน
2. ตรวจสอบการจัดวางเครื่องมือเหล่านี้ ได้แก่ BSC, Fume Hood, Autoclave, Centrifuge, Mixer, Microscope, Autopipette, Volumetric pipette และ อื่นๆ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-043-1', 'req-043', 1, 'การจัดวางเครื่องมือที่มีผลกระทบต่อกันขณะใช้เครื่องต้องแยกออกจากกัน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-043-2', 'req-043', 2, 'ตรวจสอบการจัดวางเครื่องมือเหล่านี้ ได้แก่ BSC, Fume Hood, Autoclave, Centrifuge, Mixer, Microscope, Autopipette, Volumetric pipette และ อื่นๆ', NULL);
-- ข้อ 44 (PDF หน้า 26)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-044', 'MOPH2568', 44, 'sec-6.2', 'ห้องปฏิบัติการต้องจัดทำแนวทางหรือวิธีปฏิบัติในการบริหารจัดการน้ำยา สารเคมี วัสดุวิทยาศาสตร์ และมีการบริหารจัดการวัสดุคงคลัง (Stock)', '1. มีแนวทางปฏิบัติในการบริหารจัดการน้ำยา สารเคมี และวัสดุวิทยาศาสตร์ ครอบคลุมขั้นตอน
• การกำหนดความต้องการ
• การคัดเลือกน้ำยา
• การจัดหาน้ำยา
• การตรวจรับน้ำยา
• การตรวจสอบคุณภาพของน้ำยา
• การจัดเก็บน้ำยา (หมดอายุก่อนใช้ก่อน)
2. มีการจัดการวัสดุคงคลัง มีการแยกและหรือชี้บ่งน้ำยาหรือวัสดุที่ตรวจรับแล้วและยังไม่ตรวจรับ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-044-1', 'req-044', 1, 'มีแนวทางปฏิบัติในการบริหารจัดการน้ำยา สารเคมี และวัสดุวิทยาศาสตร์ ครอบคลุมขั้นตอน
• การกำหนดความต้องการ
• การคัดเลือกน้ำยา
• การจัดหาน้ำยา
• การตรวจรับน้ำยา
• การตรวจสอบคุณภาพของน้ำยา
• การจัดเก็บน้ำยา (หมดอายุก่อนใช้ก่อน)', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-044-2', 'req-044', 2, 'มีการจัดการวัสดุคงคลัง มีการแยกและหรือชี้บ่งน้ำยาหรือวัสดุที่ตรวจรับแล้วและยังไม่ตรวจรับ', NULL);
-- ข้อ 45 (PDF หน้า 27)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-045', 'MOPH2568', 45, 'sec-7.1', 'ห้องปฏิบัติการต้องจัดทำข้อมูลในการให้บริการที่มีรายละเอียดเพียงพอ และเข้าถึงได้ เพื่อให้ผู้ใช้บริการทราบถึงขอบเขตของกิจกรรมบริการและข้อกำหนดของห้องปฏิบัติการ โดยพิจารณาจาก ทรัพยากร และความสามารถของห้องปฏิบัติการ', 'มีคู่มือการให้บริการทางห้องปฏิบัติการที่มีรายละเอียดครอบคลุม
• วิธีการชี้บ่งผู้ป่วยหรือผู้ใช้บริการก่อนเก็บสิ่งส่งตรวจ
• รายการทดสอบที่เปิดให้บริการ (ตรวจได้เองและส่งต่อ)
• วิธีการทดสอบ
• ตำแหน่งที่ตั้ง วันเวลาให้บริการ ทั้งในและนอกเวลาราชการ
• ข้อมูลการติดต่อ
• คำแนะนำในการส่งตรวจ
• การเตรียมผู้ป่วย
• วิธีการขอส่งตรวจทางเอกสาร ทางระบบอิเล็กทรอนิกส์ ทางวาจา หรือโทรศัพท์ รวมทั้งการสั่งตรวจเพิ่มเติม
• ชนิดและปริมาณของสิ่งส่งตรวจ
• ภาชนะบรรจุสิ่งส่งตรวจ สารที่เติม ลำดับการเก็บสิ่งส่งตรวจ ชนิดต่างๆอาหารเลี้ยงเชื้อ
• วิธีการเก็บสิ่งส่งตรวจ
• ช่วงเวลาจำเพาะที่เก็บสิ่งส่งตรวจ ระยะเวลา และอุณหภูมิเหมาะสม ในการนำส่งสิ่งส่งตรวจ
• เกณฑ์การรับ และปฏิเสธสิ่งส่งตรวจ
• การเก็บรักษาสิ่งส่งตรวจก่อนการตรวจวิเคราะห์
• ระยะเวลาการรายงานผล (turnaround time) ทั้งกรณีปกติ และผลด่วน
• วิธีการรายงานผลทางเอกสาร ทางระบบอิเล็กทรอนิกส์ และทางโทรศัพท์ วิธีการรายงานผลด่วน การรายงานผลค่าวิกฤติ การรายงานผล กรณีจำเป็นต้องวิเคราะห์สิ่งส่งตรวจที่ไม่เป็นไปตามเกณฑ์การรับสิ่งส่งตรวจ
• ปัจจัยที่มีผลต่อการแปลผล
• ระยะเวลา และวิธีการเก็บสิ่งส่งตรวจหลังการทดสอบ
• ระยะเวลาในการขอเพิ่มรายการส่งตรวจในสิ่งส่งตรวจเดิมที่ส่งมาก่อนหน้านี้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-045-1', 'req-045', 1, 'มีคู่มือการให้บริการทางห้องปฏิบัติการที่มีรายละเอียดครอบคลุม
• วิธีการชี้บ่งผู้ป่วยหรือผู้ใช้บริการก่อนเก็บสิ่งส่งตรวจ
• รายการทดสอบที่เปิดให้บริการ (ตรวจได้เองและส่งต่อ)
• วิธีการทดสอบ
• ตำแหน่งที่ตั้ง วันเวลาให้บริการ ทั้งในและนอกเวลาราชการ
• ข้อมูลการติดต่อ
• คำแนะนำในการส่งตรวจ
• การเตรียมผู้ป่วย
• วิธีการขอส่งตรวจทางเอกสาร ทางระบบอิเล็กทรอนิกส์ ทางวาจา หรือโทรศัพท์ รวมทั้งการสั่งตรวจเพิ่มเติม
• ชนิดและปริมาณของสิ่งส่งตรวจ
• ภาชนะบรรจุสิ่งส่งตรวจ สารที่เติม ลำดับการเก็บสิ่งส่งตรวจ ชนิดต่างๆอาหารเลี้ยงเชื้อ
• วิธีการเก็บสิ่งส่งตรวจ
• ช่วงเวลาจำเพาะที่เก็บสิ่งส่งตรวจ ระยะเวลา และอุณหภูมิเหมาะสม ในการนำส่งสิ่งส่งตรวจ
• เกณฑ์การรับ และปฏิเสธสิ่งส่งตรวจ
• การเก็บรักษาสิ่งส่งตรวจก่อนการตรวจวิเคราะห์
• ระยะเวลาการรายงานผล (turnaround time) ทั้งกรณีปกติ และผลด่วน
• วิธีการรายงานผลทางเอกสาร ทางระบบอิเล็กทรอนิกส์ และทางโทรศัพท์ วิธีการรายงานผลด่วน การรายงานผลค่าวิกฤติ การรายงานผล กรณีจำเป็นต้องวิเคราะห์สิ่งส่งตรวจที่ไม่เป็นไปตามเกณฑ์การรับสิ่งส่งตรวจ
• ปัจจัยที่มีผลต่อการแปลผล
• ระยะเวลา และวิธีการเก็บสิ่งส่งตรวจหลังการทดสอบ
• ระยะเวลาในการขอเพิ่มรายการส่งตรวจในสิ่งส่งตรวจเดิมที่ส่งมาก่อนหน้านี้', NULL);
-- ข้อ 46 (PDF หน้า 28)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-046', 'MOPH2568', 46, 'sec-7.1', 'ห้องปฏิบัติการต้องสื่อสารข้อมูลในการให้บริการของห้องปฏิบัติการ ไปยังผู้รับบริการ และต้องมีการทบทวนข้อมูลการให้บริการของห้องปฏิบัติการเป็นระยะ เพื่อให้ยังคงสามารถให้บริการที่เป็นไปตามต้องการของผู้รับบริการ', '1. มีการแจกจ่ายคู่มือหรือส่งข้อตกลงไปยังผู้รับบริการ หรือแจกจ่ายอยู่ในรูปอิเล็กทรอนิกส์
2. มีบันทึกการทบทวนข้อมูลการให้บริการของห้องปฏิบัติการ
3. มีคู่มือที่เป็นปัจจุบัน', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-046-1', 'req-046', 1, 'มีการแจกจ่ายคู่มือหรือส่งข้อตกลงไปยังผู้รับบริการ หรือแจกจ่ายอยู่ในรูปอิเล็กทรอนิกส์', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-046-2', 'req-046', 2, 'มีบันทึกการทบทวนข้อมูลการให้บริการของห้องปฏิบัติการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-046-3', 'req-046', 3, 'มีคู่มือที่เป็นปัจจุบัน', NULL);
-- ข้อ 47 (PDF หน้า 29)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-047', 'MOPH2568', 47, 'sec-7.1', 'กรณีห้องปฏิบัติการมีการเปลี่ยนแปลงข้อมูลในการให้บริการ ต้องแจ้งให้ผู้รับบริการทราบ', 'มีวิธีการแจ้งการเปลี่ยนแปลงไปยังผู้รับบริการ', 'มีหลักฐานที่สอดคล้องกับวิธีการตามที่กำหนดไว้', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-047-1', 'req-047', 1, 'มีวิธีการแจ้งการเปลี่ยนแปลงไปยังผู้รับบริการ', NULL);
-- ข้อ 48 (PDF หน้า 29)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-048', 'MOPH2568', 48, 'sec-7.1', 'ห้องปฏิบัติการมีคู่มือการเก็บสิ่งส่งตรวจที่มีรายละเอียดเพียงพอเพื่อให้มั่นใจว่าสิ่งส่งตรวจจะได้รับการเก็บอย่างถูกต้องและสมบูรณ์', 'มีคู่มือการเก็บสิ่งส่งตรวจ ที่มีรายละเอียดครอบคลุม
• การขอคำยินยอม (Consent) ถ้าจำเป็นในบางรายการทดสอบเช่น Anti-HIV และสิ่งส่งตรวจจากผู้ป่วย Rape case
• การเตรียมผู้ป่วย
• วิธีการเก็บสิ่งส่งตรวจประเภทต่างๆ
• การเก็บรักษาสิ่งส่งตรวจ หากยังไม่ได้ส่งตรวจ
• การขนส่งสิ่งส่งตรวจ (Transportation)
• การทิ้งขยะ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-048-1', 'req-048', 1, 'มีคู่มือการเก็บสิ่งส่งตรวจ ที่มีรายละเอียดครอบคลุม
• การขอคำยินยอม (Consent) ถ้าจำเป็นในบางรายการทดสอบเช่น Anti-HIV และสิ่งส่งตรวจจากผู้ป่วย Rape case
• การเตรียมผู้ป่วย
• วิธีการเก็บสิ่งส่งตรวจประเภทต่างๆ
• การเก็บรักษาสิ่งส่งตรวจ หากยังไม่ได้ส่งตรวจ
• การขนส่งสิ่งส่งตรวจ (Transportation)
• การทิ้งขยะ', NULL);
-- ข้อ 49 (PDF หน้า 29)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-049', 'MOPH2568', 49, 'sec-7.1', 'ใบคำขอส่งตรวจ (Request) ไม่ว่าจะเป็นHard copy หรือ Electronic ต้องมีข้อมูลที่เพียงพอเพื่อให้มั่นใจว่า จะสามารถดำเนินการตรวจวิเคราะห์ได้ตามต้องการ และสอบกลับได้ถึงเจ้าของสิ่งส่งตรวจ', 'ใบคำขอส่งตรวจ ต้องมีข้อมูลอย่างน้อย
• ชื่อ-สกุล
• หมายเลขระบุผู้ป่วย
• เพศ
• อายุ และ/หรือ วัน เดือน ปี เกิด
• รายการทดสอบที่ขอส่งตรวจ
• ชนิดและ/หรือตำแหน่งที่เก็บสิ่งส่งตรวจ
• วันเวลาที่เก็บสิ่งส่งตรวจ
• หน่วยงานหรือผู้ส่งตรวจที่สามารถติดต่อได้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-049-1', 'req-049', 1, 'ใบคำขอส่งตรวจ ต้องมีข้อมูลอย่างน้อย
• ชื่อ-สกุล
• หมายเลขระบุผู้ป่วย
• เพศ
• อายุ และ/หรือ วัน เดือน ปี เกิด
• รายการทดสอบที่ขอส่งตรวจ
• ชนิดและ/หรือตำแหน่งที่เก็บสิ่งส่งตรวจ
• วันเวลาที่เก็บสิ่งส่งตรวจ
• หน่วยงานหรือผู้ส่งตรวจที่สามารถติดต่อได้', NULL);
-- ข้อ 50 (PDF หน้า 30)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-050', 'MOPH2568', 50, 'sec-7.1', 'ห้องปฏิบัติการมีการชี้บ่งบนภาชนะบรรจุสิ่งส่งตรวจอย่างน้อย ชื่อ-สกุล HN หรือหมายเลขบัตรประชาชน โดยต้องมี Two identification และต้องสามารถสอบกลับได้ถึงเจ้าของสิ่งส่งตรวจได้ชัดเจน', '1.มีการติดฉลากบ่งชี้ผู้ป่วยชัดเจน รวมทั้งกรณีมีสิ่งส่งตรวจชนิดเดียวกัน แต่มีหลายชิ้น หลายตำแหน่งหรือหลายหลอด จากผู้ป่วยคนเดียวกัน
2. มีกระบวนการที่มั่นใจได้ว่าส่วนของสิ่งส่งตรวจที่แบ่งจาก Primary tube ไปยัง Secondary tube สามารถทวนสอบกลับได้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-050-1', 'req-050', 1, 'มีการติดฉลากบ่งชี้ผู้ป่วยชัดเจน รวมทั้งกรณีมีสิ่งส่งตรวจชนิดเดียวกัน แต่มีหลายชิ้น หลายตำแหน่งหรือหลายหลอด จากผู้ป่วยคนเดียวกัน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-050-2', 'req-050', 2, 'มีกระบวนการที่มั่นใจได้ว่าส่วนของสิ่งส่งตรวจที่แบ่งจาก Primary tube ไปยัง Secondary tube สามารถทวนสอบกลับได้', NULL);
-- ข้อ 51 (PDF หน้า 30)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-051', 'MOPH2568', 51, 'sec-7.1', 'ห้องปฏิบัติการต้องจัดทำวิธีปฏิบัติในการตรวจรับสิ่งส่งตรวจ', 'มีวิธีปฏิบัติในการตรวจรับสิ่งส่งตรวจ ซึ่งต้องครอบคลุม
• การตรวจสอบความครบถ้วนสมบูรณ์ของสิ่งส่งตรวจ
• เกณฑ์การรับสิ่งส่งตรวจ
• การบ่งชี้สิ่งส่งตรวจเพื่อการตรวจวิเคราะห์
• การบันทึกการรับสิ่งส่งตรวจ
• การรับสิ่งส่งตรวจที่ไม่เป็นไปตามเกณฑ์
• การบันทึกการแก้ไขสิ่งส่งตรวจที่ไม่เป็นไปตามเกณฑ์', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-051-1', 'req-051', 1, 'มีวิธีปฏิบัติในการตรวจรับสิ่งส่งตรวจ ซึ่งต้องครอบคลุม
• การตรวจสอบความครบถ้วนสมบูรณ์ของสิ่งส่งตรวจ
• เกณฑ์การรับสิ่งส่งตรวจ
• การบ่งชี้สิ่งส่งตรวจเพื่อการตรวจวิเคราะห์
• การบันทึกการรับสิ่งส่งตรวจ
• การรับสิ่งส่งตรวจที่ไม่เป็นไปตามเกณฑ์
• การบันทึกการแก้ไขสิ่งส่งตรวจที่ไม่เป็นไปตามเกณฑ์', NULL);
-- ข้อ 52 (PDF หน้า 31)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-052', 'MOPH2568', 52, 'sec-7.1', 'ห้องปฏิบัติการมีบันทึกการรับสิ่งส่งตรวจ ไม่ว่าจะเป็นHard copy หรือElectronic ที่สามารถสอบกลับได้ถึง วัน เวลา ผู้รับ สภาพสิ่งส่งตรวจ และการแก้ไขในกรณีที่สิ่งส่งตรวจไม่เหมาะสม', 'มีบันทึกการรับสิ่งส่งตรวจ ระบุวันที่ เวลา และชื่อผู้รับสิ่งส่งตรวจ ในกรณีที่ต้องรับสิ่งส่งตรวจที่อาจไม่เป็นไปตามเกณฑ์ ไม่เหมาะสม หรือไม่สามารถเก็บทดแทนได้ ต้องระบุรายละเอียดปัญหา และข้อควรระวังในการแปลผลไว้ในรายงานผลการทดสอบ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-052-1', 'req-052', 1, 'มีบันทึกการรับสิ่งส่งตรวจ ระบุวันที่ เวลา และชื่อผู้รับสิ่งส่งตรวจ ในกรณีที่ต้องรับสิ่งส่งตรวจที่อาจไม่เป็นไปตามเกณฑ์ ไม่เหมาะสม หรือไม่สามารถเก็บทดแทนได้ ต้องระบุรายละเอียดปัญหา และข้อควรระวังในการแปลผลไว้ในรายงานผลการทดสอบ', NULL);
-- ข้อ 53 (PDF หน้า 31)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-053', 'MOPH2568', 53, 'sec-7.2', 'ห้องปฏิบัติการต้องเลือกวิธีการทดสอบที่ผ่านการตรวจสอบความใช้ได้ของวิธี (Method Validation) ว่าเป็นไปตามความต้องการใช้งานทางคลินิก และจัดทำวิธีทดสอบให้มีรายละเอียดเพียงพอเหมาะสมในการใช้ปฏิบัติงาน เพื่อให้มั่นใจว่าจะทำให้ได้ผลที่เชื่อถือได้', 'มีวิธีปฏิบัติงานในการทดสอบรายการตรวจวิเคราะห์ทุกรายการ ซึ่งอย่างน้อยต้องครอบคลุม
• วัตถุประสงค์
• หลักการ
• เครื่องมือ/วัสดุ/น้ำยา
• สิ่งส่งตรวจ
• วิธีปฏิบัติ
• การควบคุมคุณภาพ
• การรายงานผล
• ค่า Reference interval (RI)
• ค่าวิกฤต
• ข้อควรระวัง
• เอกสารอ้างอิง
*กรณีที่จัดทำเป็น Card file เนื้อหาต้องสอดคล้องกับวิธีปฏิบัติงานฉบับสมบูรณ์', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-053-1', 'req-053', 1, 'มีวิธีปฏิบัติงานในการทดสอบรายการตรวจวิเคราะห์ทุกรายการ ซึ่งอย่างน้อยต้องครอบคลุม
• วัตถุประสงค์
• หลักการ
• เครื่องมือ/วัสดุ/น้ำยา
• สิ่งส่งตรวจ
• วิธีปฏิบัติ
• การควบคุมคุณภาพ
• การรายงานผล
• ค่า Reference interval (RI)
• ค่าวิกฤต
• ข้อควรระวัง
• เอกสารอ้างอิง
*กรณีที่จัดทำเป็น Card file เนื้อหาต้องสอดคล้องกับวิธีปฏิบัติงานฉบับสมบูรณ์', NULL);
-- ข้อ 54 (PDF หน้า 32)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-054', 'MOPH2568', 54, 'sec-7.2', 'ห้องปฏิบัติการต้องมีการทวนสอบ (Method Verification) วิธีการทดสอบ ซึ่งผ่านการทำ Validation มาแล้ว ก่อนนำมาใช้ในการให้บริการตรวจวิเคราะห์สิ่งส่งตรวจจากผู้ป่วย ในกรณีต่อไปนี้
(1) เปลี่ยนวิธีตรวจวิเคราะห์ใหม่
(2) เปลี่ยนวิธีและเครื่องมือ
(3) เปลี่ยนบริษัทน้ำยา
(4) เปลี่ยน Version ของน้ำยา
(5) เปิดให้บริการรายการตรวจวิเคราะห์ใหม่', 'มีรายงานผลการทวนสอบ วิธีการตรวจวิเคราะห์ที่นำมาใช้ ซึ่งอย่างน้อยต้องระบุ
• วัตถุประสงค์
• ผู้รับผิดชอบ
• performance characteristics
• เครื่องมือ วัสดุ อุปกรณ์ และ ตัวอย่าง
• วิธีการ
• เกณฑ์ที่ใช้ในการทวนสอบ
• ผลการทวน
• สรุปผลของการทวนสอบ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-054-1', 'req-054', 1, 'มีรายงานผลการทวนสอบ วิธีการตรวจวิเคราะห์ที่นำมาใช้ ซึ่งอย่างน้อยต้องระบุ
• วัตถุประสงค์
• ผู้รับผิดชอบ
• performance characteristics
• เครื่องมือ วัสดุ อุปกรณ์ และ ตัวอย่าง
• วิธีการ
• เกณฑ์ที่ใช้ในการทวนสอบ
• ผลการทวน
• สรุปผลของการทวนสอบ', NULL);
-- ข้อ 55 (PDF หน้า 32)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-055', 'MOPH2568', 55, 'sec-7.3', 'ห้องปฏิบัติการต้องจัดทำระบบรายงานผลการทดสอบที่มีความถูกต้อง ชัดเจน สอดคล้องกับขั้นตอนการทดสอบ และมีข้อมูลที่จำเป็นในการแปลผลการทดสอบ', 'มีวิธีปฏิบัติในการรายงานผล ซึ่งครอบคลุมขั้นตอน
• การกำหนดข้อมูลและรูปแบบของการรายงานผล
• การจัดทำรายงานผล
• การตรวจสอบผล
• การจัดส่งผล
• การแก้ไขเปลี่ยนแปลงผล
• การเก็บรักษา
• การแจ้งผลทางโทรศัพท์', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-055-1', 'req-055', 1, 'มีวิธีปฏิบัติในการรายงานผล ซึ่งครอบคลุมขั้นตอน
• การกำหนดข้อมูลและรูปแบบของการรายงานผล
• การจัดทำรายงานผล
• การตรวจสอบผล
• การจัดส่งผล
• การแก้ไขเปลี่ยนแปลงผล
• การเก็บรักษา
• การแจ้งผลทางโทรศัพท์', NULL);
-- ข้อ 56 (PDF หน้า 33)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-056', 'MOPH2568', 56, 'sec-7.3', 'ห้องปฏิบัติการต้องมีขั้นตอนในการตรวจสอบผลการทดสอบก่อนที่จะส่งให้ผู้รับบริการโดยผู้ที่ได้รับมอบหมาย', 'วิธีปฏิบัติในการตรวจสอบรายงานผล ซึ่งต้องระบุ
• ผู้รับผิดชอบ
• วิธีการ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-056-1', 'req-056', 1, 'วิธีปฏิบัติในการตรวจสอบรายงานผล ซึ่งต้องระบุ
• ผู้รับผิดชอบ
• วิธีการ', NULL);
-- ข้อ 57 (PDF หน้า 33)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-057', 'MOPH2568', 57, 'sec-7.3', '1.ห้องปฏิบัติการต้องมีวิธีปฏิบัติในการรายงานผลที่ครอบคลุม
(1) ผลปกติ
(2) ผลที่เป็นความลับ
(3) ผลด่วน
(4) ผลที่เป็นค่าวิกฤต
(5) ผลจากห้องปฏิบัติการภายนอก
(6)การเลือกผลการทดสอบและการรายงานผลอัตโนมัติ (Autoverification) ถ้ามี
2.ห้องปฏิบัติการมีวิธีการชี้บ่งรายงานผลที่ได้รับการแก้ไข และสามารถสอบกลับได้ถึงรายงานผลฉบับเดิม', '1.มีวิธีปฏิบัติในการรายงานผลที่ครอบคลุม
(1) ผลปกติ
(2) ผลที่เป็นความลับ
(3) ผลด่วน
(4) ผลที่เป็นค่าวิกฤต
(5) ผลจากห้องปฏิบัติการภายนอก
(6)การเลือกผลการทดสอบและการรายงานผลอัตโนมัติ (Autoverification) ถ้ามี
2.มีวิธีปฏิบัติในการแก้ไขผล', 'ผลที่เก็บในระบบ electronic เมื่อแก้ไขและ save ทับผลเก่า ต้องมีระบบการบันทึกให้สอบกลับไปยังผลเก่าได้', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-057-1', 'req-057', 1, 'มีวิธีปฏิบัติในการรายงานผลที่ครอบคลุม
(1) ผลปกติ
(2) ผลที่เป็นความลับ
(3) ผลด่วน
(4) ผลที่เป็นค่าวิกฤต
(5) ผลจากห้องปฏิบัติการภายนอก
(6)การเลือกผลการทดสอบและการรายงานผลอัตโนมัติ (Autoverification) ถ้ามี', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-057-2', 'req-057', 2, 'มีวิธีปฏิบัติในการแก้ไขผล', NULL);
-- ข้อ 58 (PDF หน้า 33)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-058', 'MOPH2568', 58, 'sec-7.3', 'ในกรณีห้องปฏิบัติการใช้ระบบอัตโนมัติในการเลือก ทบทวน ปล่อยและรายงานผล(Autoverification) เกณฑ์ที่ใช้ต้องได้รับการทวนสอบก่อนใช้งานและทบทวนเป็นระยะ และเมื่อมีการเปลี่ยนแปลงเกณฑ์ ต้องมีการทวนสอบซ้ำ', '1.มีวิธีปฏิบัติในการใช้ระบบอัตโนมัติรายงานผล ซึ่งต้องควบคุมขั้นตอน
• การคัดเลือกรายการทดสอบ
• การจัดทำเกณฑ์
• การตรวจสอบ
• การทบทวนหรือทวนสอบเมื่อมีการเปลี่ยนเกณฑ์
• การระงับผลอย่างรวดเร็ว
2. ระบบต้องสามารถระบุผลที่ถูกคัดเลือกเพื่อทบทวนแบบปกติ รวมทั้ง วัน เวลาที่เลือก และทบทวนรวมทั้งผู้ทบทวน', '(ตอบ N/A กรณีไม่มี)', 1, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-058-1', 'req-058', 1, 'มีวิธีปฏิบัติในการใช้ระบบอัตโนมัติรายงานผล ซึ่งต้องควบคุมขั้นตอน
• การคัดเลือกรายการทดสอบ
• การจัดทำเกณฑ์
• การตรวจสอบ
• การทบทวนหรือทวนสอบเมื่อมีการเปลี่ยนเกณฑ์
• การระงับผลอย่างรวดเร็ว', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-058-2', 'req-058', 2, 'ระบบต้องสามารถระบุผลที่ถูกคัดเลือกเพื่อทบทวนแบบปกติ รวมทั้ง วัน เวลาที่เลือก และทบทวนรวมทั้งผู้ทบทวน', NULL);
-- ข้อ 59 (PDF หน้า 34)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-059', 'MOPH2568', 59, 'sec-7.3', 'ห้องปฏิบัติการมีการจัดเก็บรายงานผล รวมทั้งข้อมูลต่างๆที่เกี่ยวข้องในรายงานผล ที่เป็นระบบเอกสารหรือระบบelectronic ที่สามารถสืบค้นได้เมื่อต้องการตามระยะเวลาที่กำหนด หากมีการนำระบบ electronicมาใช้ต้องเป็นระบบที่มีประสิทธิภาพและเหมาะสมกับการปฏิบัติงาน มีการป้องกันการเข้าถึงโดยผู้ที่ไม่ได้รับอนุญาต', '1. มีการจัดเก็บรายงานผลรวมทั้งข้อมูลต่างๆที่เกี่ยวข้องในรายงานผลที่เหมาะสม
2. การจัดเก็บในระบบ electronic ต้องมีระบบสำรองข้อมูล
3. มีกำหนดระยะเวลาในการเก็บ
4. มีการป้องกันการเข้าถึงโดยผู้ที่ไม่ได้รับอนุญาต', 'แตกต่างกันตามประเภทของรายงานผลให้สอดคล้องกับเอกสารคุณภาพ เช่น รายงานผลทางคดีความ', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-059-1', 'req-059', 1, 'มีการจัดเก็บรายงานผลรวมทั้งข้อมูลต่างๆที่เกี่ยวข้องในรายงานผลที่เหมาะสม', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-059-2', 'req-059', 2, 'การจัดเก็บในระบบ electronic ต้องมีระบบสำรองข้อมูล', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-059-3', 'req-059', 3, 'มีกำหนดระยะเวลาในการเก็บ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-059-4', 'req-059', 4, 'มีการป้องกันการเข้าถึงโดยผู้ที่ไม่ได้รับอนุญาต', NULL);
-- ข้อ 60 (PDF หน้า 34)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-060', 'MOPH2568', 60, 'sec-7.3', 'ห้องปฏิบัติการต้องมีวิธีปฏิบัติในการกำหนดระยะเวลาและสภาวะการเก็บรักษาสิ่งส่งตรวจหลังการตรวจวิเคราะห์เพื่อให้สามารถทวนสอบกลับไปยังแหล่งของสิ่งส่งตรวจและมีความเหมาะสมในกรณีที่ขอตรวจเพิ่ม', 'มีวิธีปฏิบัติในการจัดเก็บสิ่งส่งตรวจหลังการตรวจวิเคราะห์ ซึ่งอย่างน้อยต้องครอบคลุม
• วิธีการเก็บรักษา
• ระยะเวลา
• สภาวะการเก็บรักษา
• การทิ้งและทำลาย', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-060-1', 'req-060', 1, 'มีวิธีปฏิบัติในการจัดเก็บสิ่งส่งตรวจหลังการตรวจวิเคราะห์ ซึ่งอย่างน้อยต้องครอบคลุม
• วิธีการเก็บรักษา
• ระยะเวลา
• สภาวะการเก็บรักษา
• การทิ้งและทำลาย', NULL);
-- ข้อ 61 (PDF หน้า 35)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-061', 'MOPH2568', 61, 'sec-8.1', 'ห้องปฏิบัติการต้องจัดทำวิธีปฏิบัติในการควบคุมคุณภาพภายในของรายการทดสอบที่เปิดให้บริการ
- รายการทดสอบที่ไม่สามารถหาสารควบคุมคุณภาพที่เหมาะสม หรือไม่มีสารควบคุมคุณภาพ ต้องมีการเลือกใช้วิธีปฏิบัติอื่นๆที่เหมาะสมเพื่อสร้างความมั่นใจว่าผลการทดสอบเชื่อถือได้ (Moving average of patient data, Retested of retained patient sample, Compare patient sample with another method )', '-มีวิธีปฏิบัติในการควบคุมคุณภาพภายในของรายการทดสอบที่เปิดให้บริการ อย่างน้อยต้องครอบคลุมการกำหนด
• ชนิดของสารควบคุมคุณภาพ
• จำนวนระดับสารควบคุมคุณภาพ
• ความถี่
• เกณฑ์การควบคุม ทั้งการทดสอบเชิงคุณภาพ และการทดสอบเชิงปริมาณ
• การตรวจสอบผล
• กรณีที่ผลออกนอกเกณฑ์การควบคุม ต้องมีการวิเคราะห์หาสาเหตุและแก้ไข -มีวิธีปฏิบัติที่เหมาะสมสำหรับรายการทดสอบที่ไม่มีหรือไม่สามารถหาสารควบคุมคุณภาพที่เหมาะสมได้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-061-1', 'req-061', 1, '-มีวิธีปฏิบัติในการควบคุมคุณภาพภายในของรายการทดสอบที่เปิดให้บริการ อย่างน้อยต้องครอบคลุมการกำหนด
• ชนิดของสารควบคุมคุณภาพ
• จำนวนระดับสารควบคุมคุณภาพ
• ความถี่
• เกณฑ์การควบคุม ทั้งการทดสอบเชิงคุณภาพ และการทดสอบเชิงปริมาณ
• การตรวจสอบผล
• กรณีที่ผลออกนอกเกณฑ์การควบคุม ต้องมีการวิเคราะห์หาสาเหตุและแก้ไข -มีวิธีปฏิบัติที่เหมาะสมสำหรับรายการทดสอบที่ไม่มีหรือไม่สามารถหาสารควบคุมคุณภาพที่เหมาะสมได้', NULL);
-- ข้อ 62 (PDF หน้า 35)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-062', 'MOPH2568', 62, 'sec-8.1', 'ห้องปฏิบัติการต้องดำเนินการควบคุมคุณภาพภายใน (Internal Quality Control, IQC) เพื่อติดตามผลของการตรวจวิเคราะห์ทุกรายการทดสอบที่เปิดให้บริการตามวิธีปฏิบัติที่กำหนดไว้
- มีกระบวนการป้องกันการปล่อยผลในกรณีที่ IQC ไม่ผ่านเกณฑ์', '1.การทำและบันทึกผลการควบคุมคุณภาพภายใน (IQC) ต้องสอดคล้องกับวิธีการทดสอบ
2. มีบันทึกปฏิบัติการแก้ไขปัญหา กรณีผลการควบคุมคุณภาพภายใน (IQC) ไม่เป็นไปตามเกณฑ์ที่กำหนด
3. วิธีการบันทึกผล IQC สำหรับการทดสอบเชิงปริมาณ ต้องสามารถ ตรวจจับ reagent & calibrator lot variation ได้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-062-1', 'req-062', 1, 'การทำและบันทึกผลการควบคุมคุณภาพภายใน (IQC) ต้องสอดคล้องกับวิธีการทดสอบ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-062-2', 'req-062', 2, 'มีบันทึกปฏิบัติการแก้ไขปัญหา กรณีผลการควบคุมคุณภาพภายใน (IQC) ไม่เป็นไปตามเกณฑ์ที่กำหนด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-062-3', 'req-062', 3, 'วิธีการบันทึกผล IQC สำหรับการทดสอบเชิงปริมาณ ต้องสามารถ ตรวจจับ reagent & calibrator lot variation ได้', NULL);
-- ข้อ 63 (PDF หน้า 36)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-063', 'MOPH2568', 63, 'sec-8.2', 'ห้องปฏิบัติการมีการเข้าร่วมโปรแกรมการประเมินคุณภาพการตรวจวิเคราะห์จากองค์กรภายนอก (External Quality Assessment) ทุกรายการทดสอบที่เปิดให้บริการ เมื่อไม่มีโปรแกรม EQA หรือมีแต่ไม่เหมาะสม ห้องปฏิบัติการต้องหาวิธีทางเลือกมาติดตามประสิทธิภาพของวิธีการตรวจวิเคราะห์', '1. มีวิธีปฏิบัติในการเข้าร่วมโปรแกรมการประเมินคุณภาพการตรวจวิเคราะห์จากองค์กรภายนอก ( External Quality Assessment) รายละเอียดต้องครอบคลุม
• การเลือก EQA program
• การจัดทำแผน
• การรับตัวอย่าง
• การวิเคราะห์ตัวอย่าง
• การส่งรายงานผล
• การรับผลการประเมิน
• การตรวจสอบผลการประเมิน
• กรณีผลการประเมินไม่ผ่านเกณฑ์ ต้องวิเคราะห์หาสาเหตุและดำเนินการแก้ไข
2. มีการจัดทำวิธีปฏิบัติของวิธีทางเลือกของรายการทดสอบที่ไม่มีEQAหรือมีแต่ไม่เหมาะสม', '- ตัวอย่าง EQA ต้องดำเนินการตรวจโดยผู้ปฏิบัติงานประจำตั้งแต่กระบวนการก่อนวิเคราะห์ วิเคราะห์ และหลังวิเคราะห์', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-063-1', 'req-063', 1, 'มีวิธีปฏิบัติในการเข้าร่วมโปรแกรมการประเมินคุณภาพการตรวจวิเคราะห์จากองค์กรภายนอก ( External Quality Assessment) รายละเอียดต้องครอบคลุม
• การเลือก EQA program
• การจัดทำแผน
• การรับตัวอย่าง
• การวิเคราะห์ตัวอย่าง
• การส่งรายงานผล
• การรับผลการประเมิน
• การตรวจสอบผลการประเมิน
• กรณีผลการประเมินไม่ผ่านเกณฑ์ ต้องวิเคราะห์หาสาเหตุและดำเนินการแก้ไข', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-063-2', 'req-063', 2, 'มีการจัดทำวิธีปฏิบัติของวิธีทางเลือกของรายการทดสอบที่ไม่มีEQAหรือมีแต่ไม่เหมาะสม', NULL);
-- ข้อ 64 (PDF หน้า 36)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-064', 'MOPH2568', 64, 'sec-8.2', 'ห้องปฏิบัติการที่มีการตรวจวิเคราะห์รายการทดสอบเดียวกัน โดยใช้เครื่องมือที่แตกต่างกัน หรือใช้วิธีการวิเคราะห์ที่แตกต่างกัน ต้องมีการเปรียบเทียบผลการตรวจวิเคราะห์ ระหว่างเครื่องมือ หรือวิธีตรวจวิเคราะห์ที่ใช้ โดยมีการจัดทำวิธีปฏิบัติในการเปรียบเทียบผล', '1.มีวิธีปฏิบัติในการเปรียบเทียบผลการตรวจวิเคราะห์ ซึ่งมีรายละเอียดครอบคลุมอย่างน้อย
• ความถี่ในการทำ
• วิธีการ
• เกณฑ์การประเมินผล
• กรณีที่ผลการประเมินไม่ผ่านเกณฑ์ ต้องพิจารณาผลกระทบต่อช่วงค่าอ้างอิง และค่าการตัดสินใจทางคลินิก พร้อมทั้งดำเนินการแก้ไข และแจ้งให้ผู้รับบริการทราบ
2.มีบันทึกผลการเปรียบเทียบผลการตรวจวิเคราะห์', 'ความถี่อย่างน้อยปีละ 1 ครั้ง', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-064-1', 'req-064', 1, 'มีวิธีปฏิบัติในการเปรียบเทียบผลการตรวจวิเคราะห์ ซึ่งมีรายละเอียดครอบคลุมอย่างน้อย
• ความถี่ในการทำ
• วิธีการ
• เกณฑ์การประเมินผล
• กรณีที่ผลการประเมินไม่ผ่านเกณฑ์ ต้องพิจารณาผลกระทบต่อช่วงค่าอ้างอิง และค่าการตัดสินใจทางคลินิก พร้อมทั้งดำเนินการแก้ไข และแจ้งให้ผู้รับบริการทราบ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-064-2', 'req-064', 2, 'มีบันทึกผลการเปรียบเทียบผลการตรวจวิเคราะห์', NULL);
-- ข้อ 65 (PDF หน้า 37)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-065', 'MOPH2568', 65, 'sec-9.1', 'ห้องปฏิบัติการต้องกำหนดนโยบายและผู้รับผิดชอบในการบริหารจัดการความปลอดภัยของห้องปฏิบัติการ', '1. มีนโยบายความปลอดภัยของห้องปฏิบัติการซึ่งสอดคล้องกับนโยบายความปลอดภัยขององค์กร/หน่วยงานที่สังกัด
2. มีผู้รับผิดชอบซึ่งได้รับมอบหมาย/แต่งตั้งให้มีหน้าที่อย่างน้อยดังนี้
• จัดทำเอกสารที่เกี่ยวข้องกับความปลอดภัย
• ส่งเสริมในการนำนโยบายความปลอดภัยไปสู่การปฏิบัติ
• จัดให้มีการอบรมด้านความปลอดภัยแก่บุคลากรตามความเหมาะสมและจำเป็น
• จัดให้มีการตรวจติดตามความปลอดภัย
• ทบทวนเอกสาร/คู่มือที่เกี่ยวข้อง', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-065-1', 'req-065', 1, 'มีนโยบายความปลอดภัยของห้องปฏิบัติการซึ่งสอดคล้องกับนโยบายความปลอดภัยขององค์กร/หน่วยงานที่สังกัด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-065-2', 'req-065', 2, 'มีผู้รับผิดชอบซึ่งได้รับมอบหมาย/แต่งตั้งให้มีหน้าที่อย่างน้อยดังนี้
• จัดทำเอกสารที่เกี่ยวข้องกับความปลอดภัย
• ส่งเสริมในการนำนโยบายความปลอดภัยไปสู่การปฏิบัติ
• จัดให้มีการอบรมด้านความปลอดภัยแก่บุคลากรตามความเหมาะสมและจำเป็น
• จัดให้มีการตรวจติดตามความปลอดภัย
• ทบทวนเอกสาร/คู่มือที่เกี่ยวข้อง', NULL);
-- ข้อ 66 (PDF หน้า 38)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-066', 'MOPH2568', 66, 'sec-9.1', 'ห้องปฏิบัติการต้องจัดทำคู่มือความปลอดภัยทางห้องปฏิบัติการ และสื่อสารไปบุคลากรทุกระดับใช้เป็นแนวทางปฏิบัติ', 'มีคู่มือความปลอดภัยทางห้องปฏิบัติการซึ่งอย่างน้อยต้องครอบคลุม
• นโยบายความปลอดภัย
• มาตรฐานความปลอดภัยทั่วไป
• การป้องกันและระงับอัคคีภัย
• ความปลอดภัยทางไฟฟ้า
• ความปลอดภัยทางสารเคมี
• อันตรายทางชีวภาพ
• การกำจัดของเสีย
• การปฐมพยาบาลเบื้องต้น
• วิธีปฏิบัติในกรณีเกิดอุบัติเหตุจากการปฏิบัติงาน', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-066-1', 'req-066', 1, 'มีคู่มือความปลอดภัยทางห้องปฏิบัติการซึ่งอย่างน้อยต้องครอบคลุม
• นโยบายความปลอดภัย
• มาตรฐานความปลอดภัยทั่วไป
• การป้องกันและระงับอัคคีภัย
• ความปลอดภัยทางไฟฟ้า
• ความปลอดภัยทางสารเคมี
• อันตรายทางชีวภาพ
• การกำจัดของเสีย
• การปฐมพยาบาลเบื้องต้น
• วิธีปฏิบัติในกรณีเกิดอุบัติเหตุจากการปฏิบัติงาน', NULL);
-- ข้อ 67 (PDF หน้า 38)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-067', 'MOPH2568', 67, 'sec-9.1', 'ห้องปฏิบัติการต้องมีการตรวจติดตามระบบความปลอดภัยอย่างน้อยปีละ 1 ครั้ง', 'มีผลการตรวจติดตามด้านความปลอดภัย', 'จัดทำ checklist การตรวจติดตาม (ตัวอย่าง ในภาคผนวก)', 0, 12);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-067-1', 'req-067', 1, 'มีผลการตรวจติดตามด้านความปลอดภัย', NULL);
-- ข้อ 68 (PDF หน้า 38)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-068', 'MOPH2568', 68, 'sec-9.2', 'ห้องปฏิบัติการต้องจัดทำแผนป้องกันและระงับอัคคีภัย เพื่อให้มั่นใจว่ามีระบบในการป้องกันและจัดการเมื่อเกิดอัคคีภัย', '1. มีแผนป้องกันและระงับอัคคีภัยซึ่งสอดคล้องกับแผนขององค์กร/หน่วยงานที่สังกัด
2. มีอุปกรณ์ดับเพลิง เพียงพอ เหมาะสม และพร้อมใช้งาน
3. มีระบบสัญญาณเตือนภัย
4. มีป้ายทางออกฉุกเฉิน(ตามมาตรฐาน) และแผนผังเส้นทางหนีไฟ', 'มาตรฐานป้ายทางออกฉุกเฉิน ระบุในภาคผนวก', 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-068-1', 'req-068', 1, 'มีแผนป้องกันและระงับอัคคีภัยซึ่งสอดคล้องกับแผนขององค์กร/หน่วยงานที่สังกัด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-068-2', 'req-068', 2, 'มีอุปกรณ์ดับเพลิง เพียงพอ เหมาะสม และพร้อมใช้งาน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-068-3', 'req-068', 3, 'มีระบบสัญญาณเตือนภัย', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-068-4', 'req-068', 4, 'มีป้ายทางออกฉุกเฉิน(ตามมาตรฐาน) และแผนผังเส้นทางหนีไฟ', NULL);
-- ข้อ 69 (PDF หน้า 39)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-069', 'MOPH2568', 69, 'sec-9.3', 'ห้องปฏิบัติการต้องมีแนวทางปฏิบัติเพื่อป้องกันอันตรายทางกายภาพจากอาคารและสถานที่ การใช้อุปกรณ์ไฟฟ้า และอุปกรณ์ที่ก่อให้เกิดความร้อน ความดัน และกลิ่น', '1. มีระบบสายดิน/ระบบป้องกันไฟฟ้ารั่วสำหรับอุปกรณ์ไฟฟ้า
2. ไม่ใช้สายพ่วงเพื่อต่ออุปกรณ์ไฟฟ้าหลายชิ้น
3. ไม่วางเครื่องที่ใช้ไฟฟ้าบริเวณอ่างน้ำ
4. มีสัญลักษณ์หรือป้ายแสดงในจุดที่มีพื้นที่ต่างระดับ
5. มีวิธีปฏิบัติการใช้เครื่อง Autoclave ที่ป้องกันอันตรายจากความร้อนและความดัน
6. กรณีที่ใช้ถังแก๊สต้องมีอุปกรณ์ยึดถังแก๊สที่แข็งแรงป้องกันการล้ม
7. ต้องมีระบบระบายอากาศเพื่อขจัดกลิ่นจากการใช้ Autoclave ในการทำลายเชื้อในอุปกรณ์และสิ่งส่งตรวจก่อนนำไปทิ้ง
8. เครื่องมือขนาดใหญ่ต้องวางให้มีช่องว่างระหว่างเครื่องมือ เพื่อระบายความร้อน สะดวกต่อการปฏิบัติงาน ซ่อมบำรุง และทำความสะอาด', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-1', 'req-069', 1, 'มีระบบสายดิน/ระบบป้องกันไฟฟ้ารั่วสำหรับอุปกรณ์ไฟฟ้า', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-2', 'req-069', 2, 'ไม่ใช้สายพ่วงเพื่อต่ออุปกรณ์ไฟฟ้าหลายชิ้น', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-3', 'req-069', 3, 'ไม่วางเครื่องที่ใช้ไฟฟ้าบริเวณอ่างน้ำ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-4', 'req-069', 4, 'มีสัญลักษณ์หรือป้ายแสดงในจุดที่มีพื้นที่ต่างระดับ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-5', 'req-069', 5, 'มีวิธีปฏิบัติการใช้เครื่อง Autoclave ที่ป้องกันอันตรายจากความร้อนและความดัน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-6', 'req-069', 6, 'กรณีที่ใช้ถังแก๊สต้องมีอุปกรณ์ยึดถังแก๊สที่แข็งแรงป้องกันการล้ม', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-7', 'req-069', 7, 'ต้องมีระบบระบายอากาศเพื่อขจัดกลิ่นจากการใช้ Autoclave ในการทำลายเชื้อในอุปกรณ์และสิ่งส่งตรวจก่อนนำไปทิ้ง', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-069-8', 'req-069', 8, 'เครื่องมือขนาดใหญ่ต้องวางให้มีช่องว่างระหว่างเครื่องมือ เพื่อระบายความร้อน สะดวกต่อการปฏิบัติงาน ซ่อมบำรุง และทำความสะอาด', NULL);
-- ข้อ 70 (PDF หน้า 39)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-070', 'MOPH2568', 70, 'sec-9.3', 'ห้องปฏิบัติการต้องมีแนวทางปฏิบัติเพื่อป้องกันอันตรายจากการใช้สารเคมี', '1. มีการจัดเก็บสารเคมีอย่างเป็นหมวดหมู่
2. สารเคมีที่มีคุณสมบัติติดไฟง่าย ต้องไม่ Stock มากเกินความจำเป็น และต้องไม่วางไว้ใกล้อุปกรณ์ที่ทำให้เกิดประกายไฟ
3. ต้องมี Safety Data Sheet (SDS) และทะเบียนสารเคมีอันตราย
4. การปฏิบัติงานที่มีไอระเหยจากสารเคมีหรือกลิ่นที่ไม่พึงประสงค์ต้องปฏิบัติใน Fume hood
5. มีวิธีปฏิบัติในกรณีเกิดอุบัติเหตุจากสารเคมีหกรดผิวหนังหรือกระเด็นเข้าตา', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-070-1', 'req-070', 1, 'มีการจัดเก็บสารเคมีอย่างเป็นหมวดหมู่', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-070-2', 'req-070', 2, 'สารเคมีที่มีคุณสมบัติติดไฟง่าย ต้องไม่ Stock มากเกินความจำเป็น และต้องไม่วางไว้ใกล้อุปกรณ์ที่ทำให้เกิดประกายไฟ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-070-3', 'req-070', 3, 'ต้องมี Safety Data Sheet (SDS) และทะเบียนสารเคมีอันตราย', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-070-4', 'req-070', 4, 'การปฏิบัติงานที่มีไอระเหยจากสารเคมีหรือกลิ่นที่ไม่พึงประสงค์ต้องปฏิบัติใน Fume hood', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-070-5', 'req-070', 5, 'มีวิธีปฏิบัติในกรณีเกิดอุบัติเหตุจากสารเคมีหกรดผิวหนังหรือกระเด็นเข้าตา', NULL);
-- ข้อ 71 (PDF หน้า 40)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-071', 'MOPH2568', 71, 'sec-9.4', 'ห้องปฏิบัติการต้องจัดหาเครื่องมือ วัสดุอุปกรณ์ และสิ่งอำนวยความสะดวก รวมทั้งวิธีปฏิบัติในการใช้งาน เพื่อตอบสนองต่อเหตุการณ์และเหตุฉุกเฉิน เช่น การหกหล่นของสิ่งส่งตรวจ เชื้อ สารเคมี และบุคลากรได้รับบาดเจ็บจากการปฏิบัติงาน รวมถึงเหตุฉุกเฉินที่เกิดกับผู้รับบริการ', '1. มีเครื่องมือ อุปกรณ์ และสิ่งอำนวยความสะดวก ติดตั้งในพื้นที่ สะดวกต่อการเข้าถึงและพร้อมใช้งาน ประกอบด้วย
• ชุดปฐมพยาบาลเบื้องต้น (First aid kit)
• ชุดทำความสะอาดสำหรับการหกหล่นของสิ่งส่งตรวจหรือเชื้อ (Biological spill kit)
• ชุดทำความสะอาดสำหรับการจัดการกับการหกหล่นของสารเคมี (Chemical spill kit)
• มีอ่างล้างมือเพียงพอและเหมาะสม
• มีอุปกรณ์ล้างตา
2. มีการสุ่มความพร้อมใช้งานและบุคลากรใช้งานได้อย่างถูกต้องตามวิธีปฏิบัติงานที่กำหนดไว้', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-071-1', 'req-071', 1, 'มีเครื่องมือ อุปกรณ์ และสิ่งอำนวยความสะดวก ติดตั้งในพื้นที่ สะดวกต่อการเข้าถึงและพร้อมใช้งาน ประกอบด้วย
• ชุดปฐมพยาบาลเบื้องต้น (First aid kit)
• ชุดทำความสะอาดสำหรับการหกหล่นของสิ่งส่งตรวจหรือเชื้อ (Biological spill kit)
• ชุดทำความสะอาดสำหรับการจัดการกับการหกหล่นของสารเคมี (Chemical spill kit)
• มีอ่างล้างมือเพียงพอและเหมาะสม
• มีอุปกรณ์ล้างตา', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-071-2', 'req-071', 2, 'มีการสุ่มความพร้อมใช้งานและบุคลากรใช้งานได้อย่างถูกต้องตามวิธีปฏิบัติงานที่กำหนดไว้', NULL);
-- ข้อ 72 (PDF หน้า 41)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-072', 'MOPH2568', 72, 'sec-9.5', 'ห้องปฏิบัติการต้องจัดหาเครื่องป้องกันอันตรายส่วนบุคคล (PPE) ที่เหมาะสมและเพียงพอต่อการปฏิบัติงานของบุคลากร', 'มี PPE ได้แก่ ถุงมือ เสื้อกาวน์ รองเท้า หน้ากากอนามัย และหมวกคลุมผม', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-072-1', 'req-072', 1, 'มี PPE ได้แก่ ถุงมือ เสื้อกาวน์ รองเท้า หน้ากากอนามัย และหมวกคลุมผม', NULL);
-- ข้อ 73 (PDF หน้า 41)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-073', 'MOPH2568', 73, 'sec-9.5', 'ห้องปฏิบัติการต้องมีวิธีปฏิบัติในการเลือกและใช้งาน PPE ให้ถูกต้องเหมาะสมกับกิจกรรมในการดำเนินงานของห้องปฏิบัติการ', '1. สวมเสื้อกาวน์ยาวและแขนยาว พร้อมถุงมือ เมื่อปฏิบัติงานในพื้นที่ที่มีโอกาสปนเปื้อนสิ่งส่งตรวจหรือเชื้อโรค ในกรณีสวมเสื้อกาวน์สั้น/ชุดแบบฟอร์มของหน่วยงาน ต้องสวมเสื้อกาวน์ยาวทับทุกครั้ง
2. ถอดเสื้อกาวน์ ถุงมือ และล้างมือก่อนออกจากห้องปฏิบัติการ
3. เก็บเสื้อกาวน์ที่ใช้แล้ว/กำลังใช้งาน แยกออกจากเสื้อกาวน์สะอาด
4. การทำความสะอาดเสื้อกาวน์ที่ใช้แล้วต้องปฏิบัติตามที่หน่วยงานกำหนด ห้ามนำเสื้อกาวน์ที่ใช้แล้วซักรวมกับเสื้อผ้าปกติ
5. การใช้หน้ากากอนามัย N 95 ต้องมีวิธีปฏิบัติในการเลือกและการตรวจสอบประสิทธิภาพ
6. รองเท้าที่ใช้ในห้องปฏิบัติการต้องปิดนิ้วเท้าและหลังเท้า
7. เมื่อถุงมือปนเปื้อนสิ่งส่งตรวจหรือเชื้อโรคขณะปฏิบัติงานต้องเปลี่ยนถุงมือใหม่', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-1', 'req-073', 1, 'สวมเสื้อกาวน์ยาวและแขนยาว พร้อมถุงมือ เมื่อปฏิบัติงานในพื้นที่ที่มีโอกาสปนเปื้อนสิ่งส่งตรวจหรือเชื้อโรค ในกรณีสวมเสื้อกาวน์สั้น/ชุดแบบฟอร์มของหน่วยงาน ต้องสวมเสื้อกาวน์ยาวทับทุกครั้ง', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-2', 'req-073', 2, 'ถอดเสื้อกาวน์ ถุงมือ และล้างมือก่อนออกจากห้องปฏิบัติการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-3', 'req-073', 3, 'เก็บเสื้อกาวน์ที่ใช้แล้ว/กำลังใช้งาน แยกออกจากเสื้อกาวน์สะอาด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-4', 'req-073', 4, 'การทำความสะอาดเสื้อกาวน์ที่ใช้แล้วต้องปฏิบัติตามที่หน่วยงานกำหนด ห้ามนำเสื้อกาวน์ที่ใช้แล้วซักรวมกับเสื้อผ้าปกติ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-5', 'req-073', 5, 'การใช้หน้ากากอนามัย N 95 ต้องมีวิธีปฏิบัติในการเลือกและการตรวจสอบประสิทธิภาพ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-6', 'req-073', 6, 'รองเท้าที่ใช้ในห้องปฏิบัติการต้องปิดนิ้วเท้าและหลังเท้า', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-073-7', 'req-073', 7, 'เมื่อถุงมือปนเปื้อนสิ่งส่งตรวจหรือเชื้อโรคขณะปฏิบัติงานต้องเปลี่ยนถุงมือใหม่', NULL);
-- ข้อ 74 (PDF หน้า 42)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-074', 'MOPH2568', 74, 'sec-9.5', 'ห้องปฏิบัติการต้องจัดให้มีการตรวจสุขภาพประจำปีและควรฉีดวัคซีนให้กับบุคลากรตามความเหมาะสมและจำเป็น', 'มีบันทึกประวัติการตรวจสุขภาพและฉีดวัคซีนของบุคลากร', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-074-1', 'req-074', 1, 'มีบันทึกประวัติการตรวจสุขภาพและฉีดวัคซีนของบุคลากร', NULL);
-- ข้อ 75 (PDF หน้า 42)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-075', 'MOPH2568', 75, 'sec-9.5', 'ห้องปฏิบัติการมีแนวทางปฏิบัติงานของเจ้าหน้าที่ในห้องปฏิบัติการเพื่อให้มีความปลอดภัย', '1. ห้ามรับประทาน ดื่ม สูบ เสริมสวย ในห้องปฏิบัติการ
2. ห้ามใส่ถุงมือเมื่อจับอุปกรณ์ที่ไม่ปนเปื้อนสิ่งส่งตรวจหรือเชื้อโรค
3. กรณีที่มีผมยาวต้องรวบผมให้อยู่พ้นจากเสื้อกาวน์ หรือใส่หมวกคลุมผม
4. เจ้าหน้าที่ที่ปฏิบัติงานในห้องปฏิบัติการจุลชีววิทยาต้องสวมหมวกคลุมผมขณะปฏิบัติงานตรวจวิเคราะห์', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-075-1', 'req-075', 1, 'ห้ามรับประทาน ดื่ม สูบ เสริมสวย ในห้องปฏิบัติการ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-075-2', 'req-075', 2, 'ห้ามใส่ถุงมือเมื่อจับอุปกรณ์ที่ไม่ปนเปื้อนสิ่งส่งตรวจหรือเชื้อโรค', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-075-3', 'req-075', 3, 'กรณีที่มีผมยาวต้องรวบผมให้อยู่พ้นจากเสื้อกาวน์ หรือใส่หมวกคลุมผม', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-075-4', 'req-075', 4, 'เจ้าหน้าที่ที่ปฏิบัติงานในห้องปฏิบัติการจุลชีววิทยาต้องสวมหมวกคลุมผมขณะปฏิบัติงานตรวจวิเคราะห์', NULL);
-- ข้อ 76 (PDF หน้า 42)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-076', 'MOPH2568', 76, 'sec-9.6', 'ห้องปฏิบัติการต้องจัดหาเครื่องมือ อุปกรณ์ และแนวทางในการป้องกันการติดเชื้อและการแพร่กระจายของเชื้อจากการปฏิบัติงาน', '1. มีแนวทางปฏิบัติในการทำให้ปราศจากเชื้อ การใช้ Antiseptic และน้ำยาฆ่าเชื้ออย่างเหมาะสม
2. มี BSC เพียงพอและเหมาะสมกับการใช้งาน
3. เมื่อปฏิบัติงานกับสิ่งส่งตรวจจากทางเดินหายใจหรือสิ่งส่งตรวจที่สงสัยว่ามีเชื้ออันตราย ต้องปฏิบัติในตู้ BSC (กิจกรรมที่เกิด Aerosol)
4. มีวิธีปฏิบัติในการขนส่งสิ่งส่งตรวจหรือเชื้อโรค
5. มีวิธีปฏิบัติในการเก็บรักษา และทำลายวัสดุอุปกรณ์และสิ่งส่งตรวจหลังการตรวจวิเคราะห์
6. มีป้ายสัญลักษณ์ Biohazard ชี้บ่งพื้นที่ บริเวณ เครื่องมือ และภาชนะที่มีอันตรายทางชีวภาพ เช่น พื้นที่ตรวจวิเคราะห์ ภาชนะทิ้งเข็มเจาะเลือด ภาชนะบรรจุขยะติดเชื้อ ตู้เย็นเก็บสิ่งส่งตรวจ ภาชนะขนส่งและบรรจุสิ่งส่งตรวจ
7. มีแนวทางปฏิบัติเมื่อเกิดอุบัติเหตุ เลือด สารคัดหลั่ง สัมผัสผิวหนัง กระเด็นเข้าตา
8. มีแนวทางปฏิบัติในการใช้อุปกรณ์ที่ปนเปื้อนและไม่ปนเปื้อนเพื่อป้องกันการติดเชื้อ และการเกิด Cross contamination', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-1', 'req-076', 1, 'มีแนวทางปฏิบัติในการทำให้ปราศจากเชื้อ การใช้ Antiseptic และน้ำยาฆ่าเชื้ออย่างเหมาะสม', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-2', 'req-076', 2, 'มี BSC เพียงพอและเหมาะสมกับการใช้งาน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-3', 'req-076', 3, 'เมื่อปฏิบัติงานกับสิ่งส่งตรวจจากทางเดินหายใจหรือสิ่งส่งตรวจที่สงสัยว่ามีเชื้ออันตราย ต้องปฏิบัติในตู้ BSC (กิจกรรมที่เกิด Aerosol)', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-4', 'req-076', 4, 'มีวิธีปฏิบัติในการขนส่งสิ่งส่งตรวจหรือเชื้อโรค', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-5', 'req-076', 5, 'มีวิธีปฏิบัติในการเก็บรักษา และทำลายวัสดุอุปกรณ์และสิ่งส่งตรวจหลังการตรวจวิเคราะห์', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-6', 'req-076', 6, 'มีป้ายสัญลักษณ์ Biohazard ชี้บ่งพื้นที่ บริเวณ เครื่องมือ และภาชนะที่มีอันตรายทางชีวภาพ เช่น พื้นที่ตรวจวิเคราะห์ ภาชนะทิ้งเข็มเจาะเลือด ภาชนะบรรจุขยะติดเชื้อ ตู้เย็นเก็บสิ่งส่งตรวจ ภาชนะขนส่งและบรรจุสิ่งส่งตรวจ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-7', 'req-076', 7, 'มีแนวทางปฏิบัติเมื่อเกิดอุบัติเหตุ เลือด สารคัดหลั่ง สัมผัสผิวหนัง กระเด็นเข้าตา', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-076-8', 'req-076', 8, 'มีแนวทางปฏิบัติในการใช้อุปกรณ์ที่ปนเปื้อนและไม่ปนเปื้อนเพื่อป้องกันการติดเชื้อ และการเกิด Cross contamination', NULL);
-- ข้อ 77 (PDF หน้า 43)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-077', 'MOPH2568', 77, 'sec-9.6', 'ห้องปฏิบัติการที่ครอบครองเชื้อโรค เช่น ห้องปฏิบัติการจุลชีววิทยาคลินิก ห้องปฏิบัติการที่มีการเก็บรักษาตัวอย่าง ต้องจดแจ้งการครอบครองเชื้อโรคและพิษจากสัตว์ ตาม พ.ร.บ. เชื้อโรคและพิษจากสัตว์', 'มีหลักฐานการจดแจ้งครอบครองเชื้อโรคและพิษจากสัตว์ ตาม พ.ร.บ. เชื้อโรคและพิษจากสัตว์', '(ตอบ N/A กรณีไม่มี)', 1, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-077-1', 'req-077', 1, 'มีหลักฐานการจดแจ้งครอบครองเชื้อโรคและพิษจากสัตว์ ตาม พ.ร.บ. เชื้อโรคและพิษจากสัตว์', NULL);
-- ข้อ 78 (PDF หน้า 44)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-078', 'MOPH2568', 78, 'sec-9.7', 'ห้องปฏิบัติการต้องมีแนวทางในการจัดการขยะซึ่งต้องสอดคล้องกับแนวทางปฏิบัติขององค์กร/หน่วยงาน', '1. มีวิธีปฏิบัติในการแยกขยะ การทิ้งขยะ การใช้ภาชนะบรรจุขยะ การเก็บรักษา การขนส่ง และการทำลาย
2. บุคลากรที่เกี่ยวข้องต้องปฏิบัติตามวิธีปฏิบัติที่กำหนดไว้อย่างถูกต้อง
3. ภาชนะบรรจุขยะต้องมีฝาปิด
4. มีการชี้บ่งตามประเภทของขยะ
5. มีแนวทางในการทำความสะอาดเมื่อเกิดอุบัติเหตุจากขยะหกขณะขนส่งไปยังที่พักขยะ
6. มีเส้นทางในการขนส่งขยะไปยังที่พักขยะที่สะดวกและปลอดภัย', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-078-1', 'req-078', 1, 'มีวิธีปฏิบัติในการแยกขยะ การทิ้งขยะ การใช้ภาชนะบรรจุขยะ การเก็บรักษา การขนส่ง และการทำลาย', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-078-2', 'req-078', 2, 'บุคลากรที่เกี่ยวข้องต้องปฏิบัติตามวิธีปฏิบัติที่กำหนดไว้อย่างถูกต้อง', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-078-3', 'req-078', 3, 'ภาชนะบรรจุขยะต้องมีฝาปิด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-078-4', 'req-078', 4, 'มีการชี้บ่งตามประเภทของขยะ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-078-5', 'req-078', 5, 'มีแนวทางในการทำความสะอาดเมื่อเกิดอุบัติเหตุจากขยะหกขณะขนส่งไปยังที่พักขยะ', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-078-6', 'req-078', 6, 'มีเส้นทางในการขนส่งขยะไปยังที่พักขยะที่สะดวกและปลอดภัย', NULL);
-- ข้อ 79 (PDF หน้า 44)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-079', 'MOPH2568', 79, 'sec-10.1', 'ห้องปฏิบัติการต้องมีวิธีปฏิบัติในการจัดการข้อร้องเรียน ให้ได้รับการดำเนินการอย่างมีประสิทธิภาพและนำผลไปใช้ในการปรับปรุงคุณภาพบริการ', 'มีวิธีปฏิบัติในการจัดการข้อร้องเรียน ครอบคลุมขั้นตอน
• ช่องทางรับข้อร้องเรียน
• การแก้ไขเบื้องต้น
• การวิเคราะห์หาสาเหตุ
• การประเมินผลกระทบ
• การพิจารณามาตรการป้องกัน
• การแจ้งแก้ไขเบื้องต้นให้ผู้ร้องเรียน (ถ้าทำได้)
• การรวบรวมและสรุปผล', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-079-1', 'req-079', 1, 'มีวิธีปฏิบัติในการจัดการข้อร้องเรียน ครอบคลุมขั้นตอน
• ช่องทางรับข้อร้องเรียน
• การแก้ไขเบื้องต้น
• การวิเคราะห์หาสาเหตุ
• การประเมินผลกระทบ
• การพิจารณามาตรการป้องกัน
• การแจ้งแก้ไขเบื้องต้นให้ผู้ร้องเรียน (ถ้าทำได้)
• การรวบรวมและสรุปผล', NULL);
-- ข้อ 80 (PDF หน้า 45)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-080', 'MOPH2568', 80, 'sec-10.1', 'ห้องปฏิบัติการมีการกำหนดช่องทางในการรับเรื่องร้องเรียน และมีการนำผลการจัดการข้อร้องเรียนไปใช้ในการปรับปรุง', 'มีหลักฐานที่แสดงการจัดการข้อร้องเรียนและนำข้อร้องเรียนไปใช้ในการปรับปรุง', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-080-1', 'req-080', 1, 'มีหลักฐานที่แสดงการจัดการข้อร้องเรียนและนำข้อร้องเรียนไปใช้ในการปรับปรุง', NULL);
-- ข้อ 81 (PDF หน้า 45)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-081', 'MOPH2568', 81, 'sec-10.2', 'ห้องปฏิบัติการต้องจัดทำวิธีปฏิบัติในการระบุและควบคุมสิ่งที่ไม่สอดคล้องกับข้อกำหนดที่มีผลกระทบต่อระบบคุณภาพ เพื่อให้มั่นใจว่าสิ่งที่ไม่สอดคล้องกับข้อกำหนด จะได้รับการบันทึก การแก้ไขเบื้องต้น การวิเคราะห์หาสาเหตุ และพิจารณามาตรการในการแก้ไขเพื่อป้องกันไม่ให้เกิดซ้ำตามความเหมาะสม', '1. มีวิธีปฏิบัติในการควบคุมสิ่งที่ไม่สอดคล้องกับข้อกำหนด ซึ่งครอบคลุมขั้นตอน
• การระบุสิ่งที่ไม่สอดคล้อง
• การจัดทำแบบบันทึก
• ขั้นตอนการปฏิบัติเมื่อพบ NC Event
(1) บันทึก
(2) แก้ไขเบื้องต้น
(3) การลงทะเบียน
(4) การวิเคราะห์หาสาเหตุ
(5) การประเมินผลกระทบ
(6) พิจารณามาตรการแก้ไข
• การประเมิน และรวบรวมสรุปผล ตามความถี่ที่กำหนด
2. มีวิธีปฏิบัติในการแก้ไขไม่ให้เกิดซ้ำ
• ออกใบ CAR
• ลงทะเบียน
• แจ้งผู้รับผิดชอบ
• วิเคราะห์หาสาเหตุ และกำหนดมาตรการแก้ไขเพื่อป้องกันไม่ให้เกิดซ้ำ
• ดำเนินการแก้ไข (กำหนดเวลา)
• ตรวจติดตาม
• ปิดประเด็น', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-081-1', 'req-081', 1, 'มีวิธีปฏิบัติในการควบคุมสิ่งที่ไม่สอดคล้องกับข้อกำหนด ซึ่งครอบคลุมขั้นตอน
• การระบุสิ่งที่ไม่สอดคล้อง
• การจัดทำแบบบันทึก
• ขั้นตอนการปฏิบัติเมื่อพบ NC Event
(1) บันทึก
(2) แก้ไขเบื้องต้น
(3) การลงทะเบียน
(4) การวิเคราะห์หาสาเหตุ
(5) การประเมินผลกระทบ
(6) พิจารณามาตรการแก้ไข
• การประเมิน และรวบรวมสรุปผล ตามความถี่ที่กำหนด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-081-2', 'req-081', 2, 'มีวิธีปฏิบัติในการแก้ไขไม่ให้เกิดซ้ำ
• ออกใบ CAR
• ลงทะเบียน
• แจ้งผู้รับผิดชอบ
• วิเคราะห์หาสาเหตุ และกำหนดมาตรการแก้ไขเพื่อป้องกันไม่ให้เกิดซ้ำ
• ดำเนินการแก้ไข (กำหนดเวลา)
• ตรวจติดตาม
• ปิดประเด็น', NULL);
-- ข้อ 82 (PDF หน้า 46)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-082', 'MOPH2568', 82, 'sec-10.3', 'ห้องปฏิบัติการมีระบบบริหารความเสี่ยง โดยกำหนดนโยบาย วิธีปฏิบัติ และการนำไปใช้เพื่อการวิเคราะห์ ประเมินผล ควบคุม และติดตามความเสี่ยงอย่างเป็นระบบ เพื่อให้มั่นใจว่าสามารถควบคุมความเสี่ยงของกระบวนการต่างๆ ในห้องปฏิบัติการให้อยู่ในระดับที่ยอมรับได้', 'มีวิธีปฏิบัติในการบริหารความเสี่ยงในห้องปฏิบัติการโดยอย่างน้อยต้องครอบคลุมรายละเอียด
• นโยบายการบริหารความเสี่ยง (ครอบคลุมกระบวนงาน)
• ขั้นตอนการบริหารความเสี่ยง (Risk management processes)
1. กำหนดขอบเขต (Scope)
2. กำหนดเกณฑ์การยอมรับความเสี่ยง (Risk Matrix)
3.การจัดทำแผนประเมินความเสี่ยง (Risk Assessment)
• Risk Identification
• Risk analysis
• Risk Evaluation
4.การจัดทำแผนจัดการความเสี่ยง(Risk treatment)
• กำหนดความเสี่ยงที่ยอมรับไม่ได้หรือที่ต้องการยอมรับแต่ต้องมีวิธีควบคุม
• ระบุความเสี่ยง/กิจกรรมที่ต้องการจัดการ
• ระบุคะแนนระดับความเสี่ยง
• กำหนดวิธีการควบคุมที่ปรับปรุง เป้าหมาย/ผลสำเร็จของการปรับปรุง
• กำหนดแล้วเสร็จและผู้รับผิดชอบ
• ตรวจสอบผลดำเนินการตามแผนโดยประเมินความเสี่ยงที่เหลืออยู่หลังการควบคุม
5. การปรับปรุงแผนประเมินความเสี่ยง (Risk assessment)
6. การทบทวนและติดตาม
7. การรายงานผล', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-082-1', 'req-082', 1, 'มีวิธีปฏิบัติในการบริหารความเสี่ยงในห้องปฏิบัติการโดยอย่างน้อยต้องครอบคลุมรายละเอียด
• นโยบายการบริหารความเสี่ยง (ครอบคลุมกระบวนงาน)
• ขั้นตอนการบริหารความเสี่ยง (Risk management processes)
1. กำหนดขอบเขต (Scope)
2. กำหนดเกณฑ์การยอมรับความเสี่ยง (Risk Matrix)
3.การจัดทำแผนประเมินความเสี่ยง (Risk Assessment)
• Risk Identification
• Risk analysis
• Risk Evaluation
4.การจัดทำแผนจัดการความเสี่ยง(Risk treatment)
• กำหนดความเสี่ยงที่ยอมรับไม่ได้หรือที่ต้องการยอมรับแต่ต้องมีวิธีควบคุม
• ระบุความเสี่ยง/กิจกรรมที่ต้องการจัดการ
• ระบุคะแนนระดับความเสี่ยง
• กำหนดวิธีการควบคุมที่ปรับปรุง เป้าหมาย/ผลสำเร็จของการปรับปรุง
• กำหนดแล้วเสร็จและผู้รับผิดชอบ
• ตรวจสอบผลดำเนินการตามแผนโดยประเมินความเสี่ยงที่เหลืออยู่หลังการควบคุม
5. การปรับปรุงแผนประเมินความเสี่ยง (Risk assessment)
6. การทบทวนและติดตาม
7. การรายงานผล', NULL);
-- ข้อ 83 (PDF หน้า 47)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-083', 'MOPH2568', 83, 'sec-11', 'ห้องปฏิบัติการต้องมีการปรับปรุงอย่างต่อเนื่องทั้งระบบบริหาร กระบวนการให้บริการ ครอบคลุมกระบวนการ ก่อนการทดสอบ การทดสอบ และหลังการทดสอบ', 'มีวิธีปฏิบัติในการพัฒนาอย่างต่อเนื่อง มีรายละเอียดอย่างน้อยครอบคลุมขั้นตอน
1) การค้นหาโอกาสพัฒนา
2) จัดทำแผนพัฒนา
3) ติดตามผล
4) ประเมินและสรุปผล', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-083-1', 'req-083', 1, 'มีวิธีปฏิบัติในการพัฒนาอย่างต่อเนื่อง มีรายละเอียดอย่างน้อยครอบคลุมขั้นตอน
1) การค้นหาโอกาสพัฒนา
2) จัดทำแผนพัฒนา
3) ติดตามผล
4) ประเมินและสรุปผล', NULL);
-- ข้อ 84 (PDF หน้า 47)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-084', 'MOPH2568', 84, 'sec-11', 'ห้องปฏิบัติการต้องมีวิธีปฏิบัติในสำรวจความพึงพอใจ รับข้อเสนอแนะและข้อคิดเห็นของผู้รับบริการและนำผลไปใช้ในการปรับปรุงคุณภาพบริการ', '1.มีวิธีปฏิบัติในการสำรวจความพึงพอใจ รับข้อเสนอแนะและข้อคิดเห็นของผู้รับบริการ มีรายละเอียดอย่างน้อยครอบคลุมขั้นตอน
• ความถี่
• การจัดทำแบบสอบถามครอบคลุมกลุ่มผู้รับบริการ
• วิธีการสอบถามเพื่อให้ได้มาซึ่งข้อมูล
• การรวบรวมข้อมูลและสรุปผล
2. มีผลการสำรวจความพึงพอใจ และข้อเสนอแนะ ตามความถี่ที่กำหนด
3. มีการนำผลไปใช้ในการปรับปรุงคุณภาพบริการ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-084-1', 'req-084', 1, 'มีวิธีปฏิบัติในการสำรวจความพึงพอใจ รับข้อเสนอแนะและข้อคิดเห็นของผู้รับบริการ มีรายละเอียดอย่างน้อยครอบคลุมขั้นตอน
• ความถี่
• การจัดทำแบบสอบถามครอบคลุมกลุ่มผู้รับบริการ
• วิธีการสอบถามเพื่อให้ได้มาซึ่งข้อมูล
• การรวบรวมข้อมูลและสรุปผล', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-084-2', 'req-084', 2, 'มีผลการสำรวจความพึงพอใจ และข้อเสนอแนะ ตามความถี่ที่กำหนด', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-084-3', 'req-084', 3, 'มีการนำผลไปใช้ในการปรับปรุงคุณภาพบริการ', NULL);
-- ข้อ 85 (PDF หน้า 48)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-085', 'MOPH2568', 85, 'sec-12', 'ห้องปฏิบัติการต้องดำเนินการประเมินผลโดยกำหนดดัชนีชี้วัดและเป้าหมาย เพื่อแสดงถึงการบริหารจัดการ การสนับสนุนให้มั่นใจว่า กระบวนการก่อนการทดสอบ กระบวนการทดสอบ และกระบวนการหลังการทดสอบ เป็นไปตามความต้องการของผู้รับบริการ และสอดคล้องกับข้อกำหนดของระบบคุณภาพ', 'มีการจัดทำแผนคุณภาพโดยกำหนดดัชนีชี้วัดและเป้าหมาย ครอบคลุมกระบวนการก่อนการทดสอบ กระบวนการทดสอบ และกระบวนการหลังการทดสอบ สอดคล้องกับนโยบายคุณภาพ', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-085-1', 'req-085', 1, 'มีการจัดทำแผนคุณภาพโดยกำหนดดัชนีชี้วัดและเป้าหมาย ครอบคลุมกระบวนการก่อนการทดสอบ กระบวนการทดสอบ และกระบวนการหลังการทดสอบ สอดคล้องกับนโยบายคุณภาพ', NULL);
-- ข้อ 86 (PDF หน้า 48)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-086', 'MOPH2568', 86, 'sec-12', 'ห้องปฏิบัติการมีการทบทวนตัวชี้วัดตามระยะเวลาที่กำหนด เพื่อให้มั่นใจว่ายังมีความเหมาะสมต่อเนื่อง', 'มีผลการทบทวนและนำผลการทบทวนไปใช้ในการปรับปรุง', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-086-1', 'req-086', 1, 'มีผลการทบทวนและนำผลการทบทวนไปใช้ในการปรับปรุง', NULL);
-- ข้อ 87 (PDF หน้า 49)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-087', 'MOPH2568', 87, 'sec-12', 'ห้องปฏิบัติการต้องมีการตรวจติดตามคุณภาพภายใน เพื่อให้มั่นใจว่าการดำเนินงานตามระบบคุณภาพที่กำหนดไว้ จะได้รับการปฏิบัติอย่างต่อเนื่องและมีประสิทธิภาพ', 'มีวิธีปฏิบัติในการตรวจติดตามระบบบริหารคุณภาพภายใน โดยครอบคลุม
• การคัดเลือกผู้ติดตามภายใน
• การวางแผน (ระบุความถี่) ในการตรวจติดตาม
• ปฏิบัติการตรวจติดตาม
(1) เปิดประชุม
(2) ดำเนินการตรวจ
(3) ทบทวนสิ่งที่พบ
(4) สรุปผล
(5) ปิดประชุม
• การรายงานผลการตรวจติดตาม
• การติดตามเพื่อปิดประเด็น', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-087-1', 'req-087', 1, 'มีวิธีปฏิบัติในการตรวจติดตามระบบบริหารคุณภาพภายใน โดยครอบคลุม
• การคัดเลือกผู้ติดตามภายใน
• การวางแผน (ระบุความถี่) ในการตรวจติดตาม
• ปฏิบัติการตรวจติดตาม
(1) เปิดประชุม
(2) ดำเนินการตรวจ
(3) ทบทวนสิ่งที่พบ
(4) สรุปผล
(5) ปิดประชุม
• การรายงานผลการตรวจติดตาม
• การติดตามเพื่อปิดประเด็น', NULL);
-- ข้อ 88 (PDF หน้า 49)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-088', 'MOPH2568', 88, 'sec-12', 'ห้องปฏิบัติการมีการกำหนดความถี่ในการตรวจติดตามคุณภาพภายในต้องไม่น้อยกว่า 1 ครั้งภายใน12 เดือน และผลการตรวจติดตามต้องนำเสนอผู้บริหารสูงสุดของห้องปฏิบัติการ', '1. มีแผนการตรวจติดตามคุณภาพภายใน
2. มีผลการตรวจติดตามคุณภาพภายใน', NULL, 0, 12);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-088-1', 'req-088', 1, 'มีแผนการตรวจติดตามคุณภาพภายใน', NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-088-2', 'req-088', 2, 'มีผลการตรวจติดตามคุณภาพภายใน', NULL);
-- ข้อ 89 (PDF หน้า 49)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-089', 'MOPH2568', 89, 'sec-12', 'ผู้ตรวจติดตามคุณภาพภายใน ผ่านการฝึกอบรมความรู้และเทคนิคการตรวจติดตามภายใน มีหลักฐานบันทึกการฝึกอบรม และไม่เป็นผู้รับผิดชอบในพื้นที่ หรือกิจกรรมที่จะตรวจติดตาม', 'มีเอกสารแสดงการเข้าอบรม/ประกาศนียบัตร/บันทึกการอบรม/มีเลขทะเบียน ของผู้ตรวจติดตามภายใน และมีเอกสารระบุรายละเอียดผู้ตรวจติดตาม เช่น ชื่อ-สกุล ตำแหน่ง สถานที่ทำงาน เป็นต้น และไม่ตรวจติดตามงานของตนเอง', NULL, 0, NULL);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-089-1', 'req-089', 1, 'มีเอกสารแสดงการเข้าอบรม/ประกาศนียบัตร/บันทึกการอบรม/มีเลขทะเบียน ของผู้ตรวจติดตามภายใน และมีเอกสารระบุรายละเอียดผู้ตรวจติดตาม เช่น ชื่อ-สกุล ตำแหน่ง สถานที่ทำงาน เป็นต้น และไม่ตรวจติดตามงานของตนเอง', NULL);
-- ข้อ 90 (PDF หน้า 50)
INSERT INTO requirements (id, std_code, item_no, section_id, requirement_text, criteria_text, remark, na_allowed, frequency_months) VALUES ('req-090', 'MOPH2568', 90, 'sec-12', 'ผู้บริหารห้องปฏิบัติการต้องทบทวนการบริหารจัดการคุณภาพ (Management review) อย่างน้อย 1 ครั้งใน 12 เดือน เพื่อให้มั่นใจว่าการบริหารคุณภาพมีความเหมาะสมและมีประสิทธิภาพ', 'มีวิธีปฏิบัติในการทบทวนการบริหารจัดการคุณภาพ ซึ่งต้องต้องครอบคลุม ขั้นตอน
• การจัดทำแผนประชุม
• การเตรียมแผนประชุมโดยกำหนดผู้เข้าร่วมประชุมและวาระโดยมีหัวข้อการทบทวน ตามมาตรฐานที่กำหนด
• หัวข้อการทบทวน
(1) การติดตามมาตรการจากการประชุมทบทวนบริหารครั้งที่แล้ว
(2) นโยบายคุณภาพและวัตถุประสงค์
(3) ดัชนีชี้วัดคุณภาพ
(4) ปริมาณงานที่เปลี่ยนแปลง, ขอบเขต, บุคลากร, สถานที่ที่มีผลต่อระบบคุณภาพ
(5) การบริหารความเสี่ยง
(6) ข้อร้องเรียน / NC / CA
(7) ผลการตรวจติดตามคุณภาพภายในครั้งล่าสุด
(8) ผลการตรวจจากองค์กรภายนอก
(9) IQC/EQA
(10) ผลการสำรวจความพึงพอใจและข้อเสนอแนะของผู้รับบริการ
(11) การดำเนินงานตามแผนพัฒนา, แผนฝึกอบรม
(12) ความต้องการทรัพยากร
• ดำเนินการประชุม
• บันทึกและสรุปผลการประชุมทบทวน
• สื่อสารผลการทบทวน
2.มีสรุปผลการทบทวนและนำเสนอผู้บริหาร', NULL, 0, 12);
INSERT INTO req_criteria (id, requirement_id, seq, text, evidence_kind) VALUES ('crit-090-1', 'req-090', 1, 'มีวิธีปฏิบัติในการทบทวนการบริหารจัดการคุณภาพ ซึ่งต้องต้องครอบคลุม ขั้นตอน
• การจัดทำแผนประชุม
• การเตรียมแผนประชุมโดยกำหนดผู้เข้าร่วมประชุมและวาระโดยมีหัวข้อการทบทวน ตามมาตรฐานที่กำหนด
• หัวข้อการทบทวน
(1) การติดตามมาตรการจากการประชุมทบทวนบริหารครั้งที่แล้ว
(2) นโยบายคุณภาพและวัตถุประสงค์
(3) ดัชนีชี้วัดคุณภาพ
(4) ปริมาณงานที่เปลี่ยนแปลง, ขอบเขต, บุคลากร, สถานที่ที่มีผลต่อระบบคุณภาพ
(5) การบริหารความเสี่ยง
(6) ข้อร้องเรียน / NC / CA
(7) ผลการตรวจติดตามคุณภาพภายในครั้งล่าสุด
(8) ผลการตรวจจากองค์กรภายนอก
(9) IQC/EQA
(10) ผลการสำรวจความพึงพอใจและข้อเสนอแนะของผู้รับบริการ
(11) การดำเนินงานตามแผนพัฒนา, แผนฝึกอบรม
(12) ความต้องการทรัพยากร
• ดำเนินการประชุม
• บันทึกและสรุปผลการประชุมทบทวน
• สื่อสารผลการทบทวน
2.มีสรุปผลการทบทวนและนำเสนอผู้บริหาร', NULL);
