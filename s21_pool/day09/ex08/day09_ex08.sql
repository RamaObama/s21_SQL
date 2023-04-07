-- Please write a SQL or pl/pgsql function fnc_fibonacci (it’s up to you) that has an input parameter pstop with type integer
-- (by default is 10) and the function output is a table with all Fibonacci numbers less than pstop.
-- To check yourself and call a function, you can make a statements like below.
--
-- select * from fnc_fibonacci(100);
-- select * from fnc_fibonacci();

-- Вариант №1. pl/pgsql
CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop INTEGER DEFAULT 10)
    RETURNS TABLE
            (
                fibonacci_number INTEGER
            )
AS
$$
DECLARE
    previous INTEGER := 0;
    current  INTEGER := 1;
    next     INTEGER;
BEGIN
    fibonacci_number := previous;
    RETURN NEXT;
    WHILE current < pstop
        LOOP
            fibonacci_number := current;
            RETURN NEXT;
            next := current + previous;
            previous := current;
            current := next;
        END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Вариант №2. sql
CREATE OR REPLACE FUNCTION fnc_fibonacci_2(pstop INTEGER DEFAULT 10)
    RETURNS TABLE
            (
                fibonacci_number INTEGER
            )
AS
$$
WITH RECURSIVE fibonacci AS (SELECT 0::INTEGER AS fibonacci_number, 1::INTEGER AS next_fibonacci_number
                             UNION ALL
                             SELECT next_fibonacci_number, fibonacci_number + next_fibonacci_number
                             FROM fibonacci
                             WHERE next_fibonacci_number < pstop)
SELECT fibonacci_number
FROM fibonacci
WHERE fibonacci_number < pstop;
$$ LANGUAGE sql;

-- Вариант №1. pl/pgsql
SELECT *
FROM fnc_fibonacci(100);
SELECT *
FROM fnc_fibonacci();

-- Вариант №2. sql
SELECT *
FROM fnc_fibonacci_2(100);
SELECT *
FROM fnc_fibonacci_2();