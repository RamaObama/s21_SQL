SELECT pizzeria.name AS name
FROM pizzeria
WHERE name NOT IN (SELECT DISTINCT pizza.name
                   FROM pizzeria pizza
                            JOIN person_visits pv ON pizza.id = pv.pizzeria_id);

SELECT pizzeria.name AS name
FROM pizzeria
WHERE NOT EXISTS(SELECT pizzeria_id
                 FROM person_visits pv
                 WHERE pizzeria.id = pv.pizzeria_id);