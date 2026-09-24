-- Demo data mirroring the prototype's sample screens.
-- Image files ship with BeingHuman-BE under storage/demo/.

INSERT INTO users (external_id, display_name)
VALUES ('demo', 'คุณแม่ (ตัวอย่าง)')
ON CONFLICT (external_id) DO NOTHING;

DELETE FROM memories WHERE user_id = (SELECT id FROM users WHERE external_id = 'demo');

INSERT INTO memories (user_id, relation, image_key, created_at)
SELECT u.id, v.relation, v.image_key, v.created_at::timestamptz
FROM users u
CROSS JOIN (VALUES
  ('ลูก',      'demo/somchai.jpg',    '2026-09-20 10:00+07'),
  ('หลาน',     'demo/fah-garden.jpg', '2026-09-19 10:00+07'),
  ('คู่ชีวิต',  'demo/wedding.jpg',    '2026-09-18 10:00+07'),
  ('พี่น้อง',   'demo/old-house.jpg',  '2026-09-17 10:00+07')
) AS v(relation, image_key, created_at)
WHERE u.external_id = 'demo';
