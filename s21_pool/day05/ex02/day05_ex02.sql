-- Please create a functional B-Tree index with name idx_person_name for the column name of the person table.
-- Index should contain person names in upper case.
--
-- Please write and provide any SQL with proof (EXPLAIN ANALYZE) that index idx_person_name is working.

CREATE INDEX idx_person_name ON person (upper(name));

SET ENABLE_SEQSCAN = OFF;

SELECT *
FROM person p
WHERE upper(p.name) = upper('Kate');

EXPLAIN ANALYZE
SELECT *
FROM person p
WHERE upper(p.name) = upper('Kate');