SELECT DISTINCT pers_o.order_date AS action_date,
                person.name       AS person_name
FROM person_order AS pers_o
         JOIN person_visits ON pers_o.order_date = person_visits.visit_date
         JOIN person ON pers_o.person_id = person.id
ORDER BY action_date ASC, person_name DESC;