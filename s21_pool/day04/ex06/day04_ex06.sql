-- Please create a Materialized View mv_dmitriy_visits_and_eats (with data included) based on SQL statement that finds the name of pizzeria Dmitriy visited on January 8, 2022 and could eat pizzas for less than 800 rubles (this SQL you can find out at Day #02 Exercise #07).
-- To check yourself you can write SQL to Materialized View mv_dmitriy_visits_and_eats and compare results with your previous query.

CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats
AS
SELECT pi.name AS pizzeria_name
FROM (SELECT * FROM person) AS p
         JOIN person_visits pv ON p.id = pv.person_id
         JOIN pizzeria pi ON pv.pizzeria_id = pi.id
         JOIN menu m ON pi.id = m.pizzeria_id
WHERE m.price < 800
  AND pv.visit_date = '2022-01-08'
  AND p.name = 'Dmitriy';

-- SELECT * FROM mv_dmitriy_visits_and_eats;
-- DROP MATERIALIZED VIEW mv_dmitriy_visits_and_eats;
