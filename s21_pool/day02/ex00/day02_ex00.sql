SELECT DISTINCT pizza.name, pizza.rating
FROM pizzeria pizza
         LEFT JOIN person_visits pers_v ON
    pizza.id = pers_v.pizzeria_id
WHERE pers_v.pizzeria_id IS NULL;