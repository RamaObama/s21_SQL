-- Please find the name of pizzeria Dmitriy visited on January 8, 2022 and could eat pizza for less than 800 rubles.

SELECT p.name AS pizzeria_name
FROM (SELECT *
      FROM person
      WHERE person.name = 'Dmitriy') as pers
         JOIN person_visits ON person_visits.person_id = pers.id
         JOIN pizzeria p on person_visits.pizzeria_id = p.id
         JOIN menu m on p.id = m.pizzeria_id
WHERE m.price < 800
  AND person_visits.visit_date = '2022-01-08';