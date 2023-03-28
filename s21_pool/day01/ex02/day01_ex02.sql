SELECT mu.pizza_name
FROM menu AS mu
UNION
SELECT mu.pizza_name
FROM menu AS mu
ORDER BY pizza_name DESC;