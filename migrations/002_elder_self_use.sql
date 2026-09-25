-- 002_elder_self_use: everything the elder needs to run the book alone.
--  • a name under each photo, a favourite flag, and undo-able deletes on memories
--  • how the elder wants to be addressed and their display settings on users
--  • one row per day the elder looked at today's photos (for the "N days in a row" line)
--  • two more who-is-in-the-photo groups: pets and places

ALTER TABLE memories
  ADD COLUMN caption    text CHECK (char_length(caption) <= 80),
  ADD COLUMN favorite   boolean NOT NULL DEFAULT false,
  ADD COLUMN deleted_at timestamptz;

DROP INDEX memories_user_created_idx;
CREATE INDEX memories_user_created_idx ON memories (user_id, created_at DESC) WHERE deleted_at IS NULL;

ALTER TABLE users
  ADD COLUMN nickname text CHECK (char_length(nickname) <= 40),
  -- { textSize: normal|large|xlarge, theme: light|dark, autoSpeak: bool, speechRate: slow|normal, onboarded: bool }
  ADD COLUMN settings jsonb NOT NULL DEFAULT '{}'::jsonb;

CREATE TABLE visits (
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  day     date NOT NULL,
  PRIMARY KEY (user_id, day)
);

INSERT INTO relations (code, sort_order) VALUES ('สัตว์เลี้ยง', 8), ('สถานที่', 9);
