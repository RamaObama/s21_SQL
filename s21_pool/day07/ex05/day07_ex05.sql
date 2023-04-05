-- Please write a simple SQL query that returns a list of unique person names who made orders in any pizzerias.
-- The result should be sorted by person name.

SELECT DISTINCT p.name
FROM person_order po
         JOIN person p ON p.id = po.person_id
ORDER BY 1;