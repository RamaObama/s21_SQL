-- Please write a SQL statement to see restaurants are grouping by visits and by orders and joined with each other by using restaurant name.
-- You can use internal SQLs from Exercise 02 (restaurants by visits and by orders) without limitations of amount of rows.
--
-- Additionally, please add the next rules.
--
-- calculate a sum of orders and visits for corresponding pizzeria (be aware, not all pizzeria keys are presented in both tables).
-- sort results by total_count column in descending mode and by name in ascending mode.
-- Take a look at the data sample below.

WITH main AS ((SELECT pz.name,
                      count(person_id) AS count,
                      'visits'         AS action_type
               FROM person_visits pv
                        JOIN pizzeria pz ON pz.id = pv.pizzeria_id
               GROUP BY 1
               ORDER BY 2 DESC)
              UNION ALL
              (SELECT pz.name,
                      count(pz.name) AS count,
                      'order'        AS action_type
               FROM person_order po
                        JOIN menu m ON m.id = po.menu_id
                        JOIN pizzeria pz ON m.pizzeria_id = pz.id
               GROUP BY 1
               ORDER BY 2 DESC))
SELECT name,
       sum(count) AS total_count
FROM main
GROUP BY 1
ORDER BY 2 DESC, 1;