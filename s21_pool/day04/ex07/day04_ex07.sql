-- Let's refresh data in our Materialized View mv_dmitriy_visits_and_eats from exercise #06.
-- Before this action, please generate one more Dmitriy visit that satisfies the SQL clause of Materialized View except pizzeria that we can see in a result from exercise #06.
-- After adding a new visit please refresh a state of data for mv_dmitriy_visits_and_eats.

INSERT INTO person_visits
VALUES ((SELECT MAX(id) FROM person_visits) + 1,
        (SELECT p.id FROM person p WHERE p.name = 'Dmitriy'),
        (SELECT q1.id
         FROM (SELECT *
               FROM pizzeria pi) q1
                  JOIN (SELECT * FROM menu m WHERE m.price < 800) q2
                       ON q1.id = q2.pizzeria_id
         EXCEPT
         (SELECT pi.id
          FROM pizzeria pi
                   JOIN mv_dmitriy_visits_and_eats dmitriy
                        ON pi.name = dmitriy.pizzeria_name)
         ORDER BY 1 LIMIT 1), '2022-01-08'::date);

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

-- SELECT * FROM mv_dmitriy_visits_and_eats;