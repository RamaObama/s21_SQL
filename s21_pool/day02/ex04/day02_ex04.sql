-- Find full information about all possible pizzeria names and prices to get mushroom or pepperoni pizzas.
-- Please sort the result by pizza name and pizzeria name then.
-- The result of sample data is below (please use the same column names in your SQL statement).

WITH pizza AS (SELECT *
               FROM menu
               WHERE menu.pizza_name IN ('mushroom pizza', 'pepperoni pizza'))
SELECT pizza.pizza_name,
       piz.name AS pizzeria_name,
       pizza.price
FROM pizza
         JOIN pizzeria AS piz ON pizza.pizzeria_id = piz.id
ORDER BY 1, 2;
