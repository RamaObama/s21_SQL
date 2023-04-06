-- Please for this task use the command line for PostgreSQL database (psql).
-- You need to check how your changes will be published in the database for other database users.
--
-- Actually, we need two active sessions (meaning 2 parallel sessions in the command lines).
--
-- Please provide a proof that your parallel session can’t see your changes until you will make a COMMIT;

-- Session 1
BEGIN;
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
SELECT * FROM pizzeria;

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- Session 1
COMMIT;

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';