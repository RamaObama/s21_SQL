-- Please use SQL statement from Exercise #01 and show pizza names from pizzeria which are not ordered by anyone, including corresponding prices also.
-- The result should be sorted by pizza name and price.

WITH orders AS (SELECT m.id AS menu_id
                FROM menu m
                EXCEPT
                SELECT po.menu_id
                FROM person_order po
                ORDER BY 1),
     pizza AS (SELECT *
               FROM menu
                        RIGHT JOIN orders ON menu.id = orders.menu_id)
SELECT pizza.pizza_name,
       pizza.price,
       pi.name AS pizzeria_name
FROM pizza
         JOIN pizzeria pi ON pizza.pizzeria_id = pi.id
ORDER BY 1, 2;