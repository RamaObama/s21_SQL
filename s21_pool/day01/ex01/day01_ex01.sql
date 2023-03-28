SELECT mu.pizza_name AS object_name
FROM menu AS mu
UNION ALL
SELECT pers.name AS object_name
FROM person AS pers
ORDER BY object_name;