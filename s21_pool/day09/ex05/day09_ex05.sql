-- Looks like 2 functions from exercise 04 need a more generic approach.
-- Please before our further steps drop these functions from the database.
-- Write a common SQL-function (please be aware, not pl/pgsql-function) with the name fnc_persons.
-- This function should have an IN parameter pgender with default value = ‘female’.
-- To check yourself and call a function, you can make a statement like below (wow! you can work with a function like with a virtual table but with more flexibilities!).

DROP FUNCTION IF EXISTS fnc_persons_female;
DROP FUNCTION IF EXISTS fnc_persons_male;

CREATE OR REPLACE FUNCTION fnc_persons(IN pgender varchar DEFAULT 'female')
    RETURNS TABLE
            (
                id      bigint,
                name    varchar,
                age     integer,
                gender  varchar,
                address varchar
            )
AS
$$
SELECT *
FROM person
WHERE pgender = gender
$$
    LANGUAGE sql;

SELECT *
FROM fnc_persons(pgender := 'male');

SELECT *
FROM fnc_persons();
