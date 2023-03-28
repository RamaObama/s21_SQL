SELECT pers_o.order_date AS action_date,
       pers_o.person_id  AS person_id
FROM person_order AS pers_o
INTERSECT
SELECT pers_v.visit_date AS action_date,
       pers_v.person_id  AS person_id
FROM person_visits AS pers_v
ORDER BY action_date ASC, person_id DESC;