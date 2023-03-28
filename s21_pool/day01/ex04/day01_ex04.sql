SELECT pers_o.person_id AS person_id
FROM person_order AS pers_o
WHERE pers_o.order_date = '2022-01-07'
EXCEPT ALL
SELECT pers_v.person_id AS person_id
FROM person_visits AS pers_v
WHERE pers_v.visit_date = '2022-01-07';