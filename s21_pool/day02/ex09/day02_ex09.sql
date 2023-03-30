-- Please find the names of all females who ordered both pepperoni and cheese pizzas (at any time and in any pizzerias).
-- Make sure that the result is ordered by person name.

WITH women AS (SELECT *
               FROM person AS p
               WHERE p.gender = 'female'),
     orders AS (SELECT women.name,
                       m.pizza_name,
                       po.*
                FROM person_order po
                         JOIN women ON po.person_id = women.id
                         JOIN menu m on po.menu_id = m.id)
SELECT ord.name
FROM orders AS ord
WHERE ord.pizza_name = 'cheese pizza'
  AND EXISTS(SELECT orders.name
             FROM orders
             WHERE orders.pizza_name = 'pepperoni pizza'
               AND orders.name = ord.name)
ORDER BY ord.name;