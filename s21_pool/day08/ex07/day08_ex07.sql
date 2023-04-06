-- You can see a graphical presentation of the deadlock situation on a picture.
-- Looks like a “christ-lock” between parallel sessions.
--
-- Please write any SQL statement with any isolation level (you can use default setting) on the pizzeria table to reproduce this deadlock situation.

-- Session 1
BEGIN;

-- Session 2
BEGIN;

-- Session 1
UPDATE pizzeria SET rating = 5 WHERE id = 1;

-- Session 2
UPDATE pizzeria SET rating = 3 WHERE id = 2;

-- Session 1
UPDATE pizzeria SET rating = 1 WHERE id = 2;

-- Session 2
UPDATE pizzeria SET rating = 2 WHERE id = 1;

-- Session 1
COMMIT;

-- Session 2
COMMIT;