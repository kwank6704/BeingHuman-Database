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

## Deploy ฐานข้อมูลบน Neon (Vercel)

1. สร้างฐานข้อมูล Neon จากโปรเจกต์ BeingHuman-BE บน Vercel (แท็บ **Storage → Create Database → Neon**)
2. ใน Vercel → BeingHuman-BE → **Settings → Environment Variables** คัดลอกค่า **`DATABASE_URL_UNPOOLED`**
3. รันจากเครื่องตัวเอง (PowerShell):

```powershell
cd BeingHuman-Database
npm install
$env:DATABASE_URL = "วาง DATABASE_URL_UNPOOLED ที่คัดลอกมา"
npm run seed
```

เห็น `applied 001_init.sql` แปลว่าสำเร็จ — `npm run seed` ใส่รูปตัวอย่างของผู้ใช้ `demo` ด้วย ถ้าไม่ต้องการใช้ `npm run migrate` แทน
(ใน Git Bash / macOS ใช้ `DATABASE_URL="..." npm run seed` บรรทัดเดียว)

- Vercel **ไม่รัน migration ให้** — ถ้าเพิ่มไฟล์ใน `migrations/` ภายหลัง ต้องรัน `npm run migrate` แบบนี้อีกครั้ง
- ดูข้อมูลบน Neon ใน DBeaver ได้: PostgreSQL connection ใส่ Host / Database / User / Password จากหน้า Neon (ปุ่ม **Connect**) และเปิดแท็บ **SSL** → SSL mode = `require`

## Schema

- `users` — one per elder; `external_id` is the LIFF user id (or a device id before LINE login).
- `relations` — who-is-in-the-photo groups (ลูก, หลาน, คู่ชีวิต, พี่น้อง, เพื่อน, ตัวเอง, ครอบครัว) with browse order.
- `memories` — a photo, its relation, and an optional recorded voice story (`voice_key`, `voice_duration_sec`).
  Media files are stored by the backend; rows keep storage keys.

Add a migration as `migrations/NNN_description.sql`; each file runs once inside a transaction.
