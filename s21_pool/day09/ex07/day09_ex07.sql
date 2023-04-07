-- Please write a SQL or pl/pgsql function func_minimum (it’s up to you) that has an input parameter
-- is an array of numbers and the function should return a minimum value.
--
-- To check yourself and call a function, you can make a statement like below.
-- SELECT func_minimum(VARIADIC arr => ARRAY[10.0, -1.0, 5.0, 4.4]);

-- Вариант №1. pl/pgsql
CREATE OR REPLACE FUNCTION func_minimum(VARIADIC arr NUMERIC[])
    RETURNS NUMERIC AS
$$
BEGIN
    RETURN (SELECT min(i) FROM unnest($1) i);
END;
$$ LANGUAGE plpgsql;

SELECT func_minimum(VARIADIC arr => ARRAY [10.0, -1.0, 5.0, 4.4]);

-- Вариант №2. SQL
CREATE OR REPLACE FUNCTION func_minimum_2(VARIADIC arr numeric[]) RETURNS numeric AS
$$
SELECT min($1[i])
FROM generate_subscripts($1, 1) g(i);
$$ LANGUAGE sql;

SELECT func_minimum_2(VARIADIC arr => ARRAY [10.0, -1.0, 5.0, 4.4]);