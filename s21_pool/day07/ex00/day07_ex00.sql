-- Let’s make a simple aggregation, please write a SQL statement that returns person
-- identifiers and corresponding number of visits in any pizzerias and sorting by count of visits in
-- descending mode and sorting in person_id in ascending mode.

SELECT person_id,
       count(pizzeria_id) AS count_of_visits
FROM person_visits pv
GROUP BY person_id, pv.person_id
ORDER BY 2 DESC, 1;