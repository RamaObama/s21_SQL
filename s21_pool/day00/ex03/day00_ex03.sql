SELECT DISTINCT visiter.person_id
FROM person_visits AS visiter
WHERE (visiter.visit_date BETWEEN '2022-01-06' AND '2022-01-09')
   OR visiter.pizzeria_id = 2
ORDER BY visiter.person_id DESC;