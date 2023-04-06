-- Please for this task use the command line for PostgreSQL database (psql). You need to check how your changes will be published in the database for other database users.
-- Actually, we need two active sessions (meaning 2 parallel sessions in the command lines).

-- Let’s check one of the famous “Non-Repeatable Reads” database pattern but under READ COMMITTED isolation level.
-- You can see a graphical presentation of that anomaly on a picture.
-- Horizontal Red Line means the final results after all sequential steps for both Sessions.

-- Session 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- Session 2
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
COMMIT;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
COMMIT;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';