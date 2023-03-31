-- Please write a SQL statement which returns a list of pizza names, pizza prices,
-- pizzerias names and dates of visit for Kate and for prices in range from 800 to 1000 rubles.
-- Please sort by pizza, price and pizzeria names.

WITH list AS (SELECT q1.id, pizzeria_id, visit_date
              FROM (SELECT id
                    FROM person
                    WHERE name = 'Kate') AS q1
                       JOIN person_visits ON person_id = q1.id)
SELECT m.pizza_name, m.price, pi.name AS pizzeria_name, l.visit_date
FROM (SELECT *
      FROM menu
      WHERE price BETWEEN 800 AND 1000) AS m
         JOIN pizzeria pi ON m.pizzeria_id = pi.id
         JOIN list l ON l.pizzeria_id = pi.id
ORDER BY 1, 2, 3;