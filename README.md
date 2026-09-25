# BeingHuman-Database

PostgreSQL schema, migrations and demo seed for **สมุดความทรงจำ** (Memory Book).

| Repo | Role |
| --- | --- |
| [BeingHuman](https://github.com/kwank6704/BeingHuman) | Next.js frontend |
| [BeingHuman-BE](https://github.com/kwank6704/BeingHuman-BE) | Express API + media storage |
| BeingHuman-Database | this repo |

## Run

> วิธีรันทั้งระบบ (ฐานข้อมูล + backend + หน้าเว็บ) ทีละขั้น อยู่ที่ [BeingHuman README](https://github.com/kwank6704/BeingHuman#วิธีรันในเครื่อง-getting-started)

Requires Node.js 20+ and Docker Desktop (running).

```bash
npm install
npm run db:up      # Postgres 16 on localhost:5432 (docker)
npm run seed       # apply migrations + demo data (user "demo")
```

`npm run migrate` applies new migrations only. `npm run reset` wipes the volume and starts over.
Set `DATABASE_URL` to point at another server.

## Schema

- `users` — one per elder; `external_id` is the LIFF user id (or a device id before LINE login); `nickname`
  (how the app greets them) and `settings` (jsonb: text size, theme, read-aloud).
- `relations` — who-is-in-the-photo groups (ลูก, หลาน, คู่ชีวิต, พี่น้อง, เพื่อน, ตัวเอง, ครอบครัว, สัตว์เลี้ยง, สถานที่) with browse order.
- `memories` — a photo, its relation, and an optional recorded voice story (`voice_key`, `voice_duration_sec`).
  Also `caption` (name under the photo), `favorite`, and `deleted_at` (undo-able delete; purged after 7 days).
  Media files are stored by the backend; rows keep storage keys.
- `visits` — one row per day the elder finished today's photos, for the "N days in a row" line.

Add a migration as `migrations/NNN_description.sql`; each file runs once inside a transaction.
