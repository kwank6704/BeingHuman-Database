// Applies migrations/*.sql in name order, once each (tracked in schema_migrations).
// `node scripts/migrate.mjs --seed` also runs seeds/*.sql (always; seeds are idempotent).
import { readdir, readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import pg from 'pg';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const url = process.env.DATABASE_URL || 'postgres://beinghuman:beinghuman@localhost:5432/beinghuman';
const client = new pg.Client({ connectionString: url });

async function sqlFiles(dir) {
  return (await readdir(path.join(root, dir))).filter(f => f.endsWith('.sql')).sort();
}

async function run() {
  await client.connect();
  await client.query('CREATE TABLE IF NOT EXISTS schema_migrations (name text PRIMARY KEY, applied_at timestamptz NOT NULL DEFAULT now())');
  const done = new Set((await client.query('SELECT name FROM schema_migrations')).rows.map(r => r.name));

  for (const f of await sqlFiles('migrations')) {
    if (done.has(f)) continue;
    const sql = await readFile(path.join(root, 'migrations', f), 'utf8');
    await client.query('BEGIN');
    try {
      await client.query(sql);
      await client.query('INSERT INTO schema_migrations (name) VALUES ($1)', [f]);
      await client.query('COMMIT');
      console.log('applied', f);
    } catch (e) {
      await client.query('ROLLBACK');
      throw new Error(`${f}: ${e.message}`);
    }
  }

  if (process.argv.includes('--seed')) {
    for (const f of await sqlFiles('seeds')) {
      await client.query(await readFile(path.join(root, 'seeds', f), 'utf8'));
      console.log('seeded', f);
    }
  }
}

run().then(() => client.end(), async e => { console.error(e.message); await client.end(); process.exit(1); });
