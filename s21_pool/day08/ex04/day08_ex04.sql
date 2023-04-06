-- Let’s check one of the famous “Non-Repeatable Reads” database pattern but under SERIALIZABLE isolation level.
-- You can see a graphical presentation of that anomaly on a picture.
-- Horizontal Red Line means the final results after all sequential steps for both Sessions.
-- Please check a rating for “Pizza Hut” in a transaction mode for both Sessions and after that make UPDATE of rating to 3.0 value in session #2 (in the same order as in the picture).

-- Session 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Session 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- Session 2
UPDATE pizzeria SET rating = 3.0 WHERE name = 'Pizza Hut';
COMMIT;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
COMMIT;

-- Session 1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- Session 2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';