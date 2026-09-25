-- Demo data mirroring the prototype's sample screens.
-- Image files ship with BeingHuman-BE under storage/demo/.
-- Re-running resets the demo book, including its settings, so the first-run welcome shows again.

INSERT INTO users (external_id, display_name)
VALUES ('demo', 'คุณแม่ (ตัวอย่าง)')
ON CONFLICT (external_id) DO NOTHING;

UPDATE users SET nickname = NULL, settings = '{}'::jsonb WHERE external_id = 'demo';

DELETE FROM visits WHERE user_id = (SELECT id FROM users WHERE external_id = 'demo');
DELETE FROM memories WHERE user_id = (SELECT id FROM users WHERE external_id = 'demo');

INSERT INTO memories (user_id, relation, caption, favorite, image_key, created_at)
SELECT u.id, v.relation, v.caption, v.favorite, v.image_key, v.created_at::timestamptz
FROM users u
CROSS JOIN (VALUES
  ('หลาน',     'ฟ้า วิ่งเล่นหน้าบ้าน',      true,  'demo/fah-garden.jpg', '2026-09-21 10:00+07'),
  ('ลูก',      'สมชาย ลูกชายคนโต',        false, 'demo/somchai.jpg',    '2026-09-20 10:00+07'),
  ('ลูก',      'งานแต่งงานของนุ่น',          true,  'demo/wedding.jpg',    '2026-09-19 10:00+07'),
  ('ครอบครัว', 'เที่ยวทะเลหัวหินกันทั้งบ้าน', false, 'demo/huahin.jpg',     '2026-09-18 10:00+07'),
  ('หลาน',     'วันเกิดฟ้า ครบ 5 ขวบ',      false, 'demo/birthday.jpg',   '2026-09-17 10:00+07'),
  ('เพื่อน',    'งานเลี้ยงรุ่นเพื่อนโรงเรียน',  false, 'demo/reunion.jpg',    '2026-09-16 10:00+07'),
  ('ครอบครัว', 'รวมญาติที่บ้านหัวหิน',       false, 'demo/old-house.jpg',  '2026-09-15 10:00+07')
) AS v(relation, caption, favorite, image_key, created_at)
WHERE u.external_id = 'demo';
