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