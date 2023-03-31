-- Please find the same pizza names who have the same price, but from different pizzerias.
-- Make sure that the result is ordered by pizza name. The sample of data is presented below.
-- Please make sure your column names are corresponding column names below.

WITH find AS (SELECT m.pizza_name,
                     m.price,
                     pi.name,
                     pi.id
              FROM menu m
                       JOIN pizzeria pi ON m.pizzeria_id = pi.id)
SELECT q1.pizza_name,
       q1.name AS pizzeria_name_1,
       f.name  AS pizzeria_name_2,
       q1.price
FROM (SELECT *
      FROM find) q1
         JOIN find f ON q1.price = f.price
    AND q1.pizza_name = f.pizza_name
    AND q1.id > f.id
ORDER BY 1;