SELECT DISTINCT pers_o.order_date AS action_date,
                person.name       AS person_name
FROM person_order AS pers_o
         JOIN person_visits ON pers_o.order_date = person_visits.visit_date
         JOIN person ON pers_o.person_id = person.id
ORDER BY action_date ASC, person_name DESC;

-- Вариант №2
SELECT action_date, person_name
FROM ((SELECT person_order.order_date AS action_date, person.name AS person_name
       FROM person,
            person_order
       WHERE person.id = person_order.person_id)
      UNION ALL
      (SELECT person_visits.visit_date AS action_date, person.name AS person_name
       FROM person,
            person_visits
       WHERE person.id = person_visits.person_id)) tmp
GROUP BY action_date, person_name
HAVING COUNT(*) >= 2
ORDER BY action_date ASC, person_name DESC