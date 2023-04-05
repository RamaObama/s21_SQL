-- Please write a SQL statement to see 3 favorite restaurants by visits and by orders in one list
-- (please add an action_type column with values ‘order’ or ‘visit’, it depends on data from the corresponding table).
-- Please take a look at the sample of data below.
-- The result should be sorted by action_type column in ascending mode and by count column in descending mode.

WITH visits AS (SELECT pz.name,
                       count(pizzeria_id),
                       'visit' AS action_type
                FROM person_visits pv
                         JOIN pizzeria pz ON pv.pizzeria_id = pz.id
                GROUP BY 1
                ORDER BY 2 DESC
                LIMIT 3),
     ordres AS (SELECT pz.name,
                       count(pz.name),
                       'order' AS action_type
                FROM person_order po
                         JOIN menu m ON po.menu_id = m.id
                         JOIN pizzeria pz ON m.pizzeria_id = pz.id
                GROUP BY 1
                ORDER BY 2 DESC
                LIMIT 3)
SELECT *
FROM visits
UNION ALL
SELECT *
FROM ordres
ORDER BY 3, 2 DESC;