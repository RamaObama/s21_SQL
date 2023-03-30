-- Please find all pizza names (and corresponding pizzeria names using menu table) that Denis or Anna ordered.
-- Sort a result by both columns.

WITH orders AS (SELECT *
                FROM person_order AS pers_o
                         RIGHT JOIN (SELECT *
                                     FROM person AS pers
                                     WHERE pers.name IN ('Anna', 'Denis')) AS pers_ ON pers_o.person_id = pers_.id)
SELECT mu.pizza_name,
       pizza.name AS pizzeria_name
FROM menu AS mu
         JOIN orders ON mu.id = orders.menu_id
         JOIN pizzeria pizza ON mu.pizzeria_id = pizza.id
ORDER BY pizza_name, pizzeria_name;