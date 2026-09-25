-- 003_morning_greeting: the 07:00 "สวัสดีตอนเช้าค่ะ" message from the LINE Official Account.
-- greeted_on is the last day (Asia/Bangkok) a morning message was sent, so a repeated or
-- overlapping cron run never sends the same elder two messages on one day.
-- Elders can turn the message off with settings.morningGreeting = false.

ALTER TABLE users ADD COLUMN greeted_on date;
