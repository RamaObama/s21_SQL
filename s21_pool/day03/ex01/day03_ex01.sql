-- Please find all menu identifiers which are not ordered by anyone. The result should be sorted by identifiers.

SELECT m.id AS menu_id
FROM menu m
EXCEPT
SELECT po.menu_id
FROM person_order po
ORDER BY 1;