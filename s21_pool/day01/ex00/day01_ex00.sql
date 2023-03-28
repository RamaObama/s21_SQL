SELECT mu.id AS object_id, mu.pizza_name AS object_name
FROM menu AS mu
UNION
SELECT pers.id AS object_id, pers.name AS object_id
FROM person AS pers
ORDER BY object_id, object_name;
