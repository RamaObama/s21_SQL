-- Let’s check one of the famous “Phantom Reads” database pattern but under REPEATABLE READ isolation level. You can see a graphical presentation of that anomaly on a picture.
-- Horizontal Red Line means the final results after all sequential steps for both Sessions.
--
-- Please summarize all ratings for all pizzerias in a transaction mode for both Sessions and after that make UPDATE of rating to 5 value for “Pizza Hut” restaurant in session #2 (in the same order as in the picture).

-- Session 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 2
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 1
SELECT sum(rating) FROM pizzeria;

-- Session 2
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
COMMIT;

-- Session 1
SELECT sum(rating) FROM pizzeria;
COMMIT;

-- Session 1
SELECT sum(rating) FROM pizzeria;

-- Session 2
SELECT sum(rating) FROM pizzeria;