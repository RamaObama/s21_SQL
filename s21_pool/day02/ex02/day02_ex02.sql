-- Вариант № 1 Медленный
SELECT CASE
           WHEN pers.name IS NULL THEN '-'
           ELSE pers.name
           END AS person_name,
       visit_date,
       CASE
           WHEN pizza.name IS NULL THEN '-'
           ELSE pizza.name
           END AS pizzeria_name
FROM person AS pers
         FULL JOIN (SELECT *
                    FROM person_visits AS pers_v
                    WHERE pers_v.visit_date BETWEEN '2022-01-01' AND '2022-01-03') query
                   ON pers.id = query.person_id
         FULL JOIN pizzeria AS pizza
                   ON query.pizzeria_id = pizza.id
ORDER BY person_name, visit_date, pizzeria_name;

-- Вариант № 2 с COALESCE Быстрый
SELECT COALESCE(pers.name, '-')  AS person_name,
       query.visit_date          AS visit_date,
       COALESCE(pizza.name, '-') AS pizzeria_name
FROM person AS pers
         FULL JOIN (SELECT *
                    FROM person_visits AS pers_v
                    WHERE pers_v.visit_date BETWEEN '2022-01-01' AND '2022-01-03') query
                   ON pers.id = query.person_id
         FULL JOIN pizzeria AS pizza
                   ON query.pizzeria_id = pizza.id
ORDER BY person_name, visit_date, pizzeria_name;
