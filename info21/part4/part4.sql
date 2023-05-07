-- 1) Create a stored procedure that, without destroying the database,
-- destroys all those tables in the current database whose names begin with the phrase 'TableName'.

CREATE TABLE tmp_table_1
(
    col1 VARCHAR,
    col2 VARCHAR
);

CREATE TABLE tmp_table_2
(
    col1 VARCHAR,
    col2 VARCHAR
);

DROP PROCEDURE IF EXISTS prc_drop_table CASCADE;

CREATE OR REPLACE PROCEDURE prc_drop_table(IN tablename VARCHAR) AS
$$
BEGIN
    FOR tablename IN (SELECT table_name
                      FROM information_schema.tables
                      WHERE table_name LIKE concat(tablename, '%')
                        AND table_schema LIKE 'public')
        LOOP
            EXECUTE 'DROP TABLE IF EXISTS ' || tablename || ' CASCADE';
        END LOOP;
END ;
$$
    LANGUAGE plpgsql;

-- CALL prc_drop_table('tmp_table');

-- 2) Create a stored procedure with an output parameter that outputs a list of names and parameters of all scalar user's SQL functions in the current database.
-- Do not output function names without parameters. The names and the list of parameters must be in one string.
-- The output parameter returns the number of functions found.

DROP PROCEDURE IF EXISTS prc_get_scalar_functions CASCADE;

CREATE OR REPLACE PROCEDURE prc_get_scalar_functions(
    OUT num_functions INT,
    OUT function_list TEXT
) AS
$$
DECLARE
    func_name   TEXT;
    func_params TEXT;
    func        RECORD;
BEGIN
    num_functions := 0;
    function_list := '';

    FOR func IN
        SELECT p.proname AS function_name, pg_get_function_arguments(p.oid) AS function_params
        FROM pg_proc p
                 JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
          AND p.proargtypes = ''
        LOOP
            func_name := func.function_name;
            func_params := func.function_params;

            -- Only include functions with parameters
            IF func_params != '' THEN
                num_functions := num_functions + 1;
                function_list := function_list || func_name || '(' || func_params || '), ';
            END IF;
        END LOOP;

    -- Remove trailing comma and space from function list
    function_list := SUBSTRING(function_list, 1, LENGTH(function_list) - 2);
END;
$$
    LANGUAGE plpgsql;

-- DO
-- $$
--     DECLARE
--         num_functions INT;
--         function_list TEXT;
--     BEGIN
--         CALL prc_get_scalar_functions(num_functions, function_list);
--         RAISE NOTICE 'Found % scalar functions: %', num_functions, function_list;
--     END
-- $$;

-- 3) Create a stored procedure with output parameter, which destroys all SQL DML triggers in the current database.
-- The output parameter returns the number of destroyed triggers.



-- 4) Create a stored procedure with an input parameter that outputs names and descriptions of object types
-- (only stored procedures and scalar functions) that have a string specified by the procedure parameter.

DROP PROCEDURE IF EXISTS prc_search_objects CASCADE;

CREATE OR REPLACE PROCEDURE prc_search_objects(
    IN search_string text,
    IN cursor refcursor default 'cursor') AS
$$
BEGIN
    OPEN cursor FOR
        SELECT routine_name AS object_name,
               routine_type AS object_type
        FROM information_schema.routines
        WHERE specific_schema = 'public'
          AND routine_definition LIKE concat('%', search_string, '%');
END;
$$
    LANGUAGE plpgsql;

BEGIN;
CALL prc_search_objects('peer');
FETCH ALL IN "cursor";
END;