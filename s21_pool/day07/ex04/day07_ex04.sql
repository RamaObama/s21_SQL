-- Please write a SQL statement that returns the person name and corresponding
-- number of visits in any pizzerias if the person has visited more than 3 times (> 3).

SELECT p.name,
       count(pv.pizzeria_id) AS count_of_visits
FROM person p
         JOIN person_visits pv ON p.id = pv.person_id
GROUP BY 1
HAVING count(pv.pizzeria_id) > 3;