-- 001_init: users and their memories (photo + optional voice story).
-- Media bytes live in the backend's storage; rows hold storage keys only.

CREATE TABLE users (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  external_id  text NOT NULL UNIQUE,          -- LIFF user id, or a device id before LINE login
  display_name text,
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- Relationship groups, in the order the elder browses them.
CREATE TABLE relations (
  code       text PRIMARY KEY,
  sort_order smallint NOT NULL UNIQUE
);

INSERT INTO relations (code, sort_order) VALUES
  ('ลูก', 1), ('หลาน', 2), ('คู่ชีวิต', 3), ('พี่น้อง', 4), ('เพื่อน', 5), ('ตัวเอง', 6), ('ครอบครัว', 7);

CREATE TABLE memories (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  relation           text NOT NULL REFERENCES relations(code),
  image_key          text NOT NULL,
  image_mime         text NOT NULL DEFAULT 'image/jpeg',
  voice_key          text,
  voice_mime         text,
  voice_duration_sec integer NOT NULL DEFAULT 0 CHECK (voice_duration_sec BETWEEN 0 AND 600),
  created_at         timestamptz NOT NULL DEFAULT now(),
  CHECK ((voice_key IS NULL) = (voice_mime IS NULL))
);

CREATE INDEX memories_user_created_idx ON memories (user_id, created_at DESC);
