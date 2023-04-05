-- We know about personal addresses from our data.
-- Let’s imagine, that particular person visits pizzerias in his/her city only.
-- Please write a SQL statement that returns address, pizzeria name and amount of persons’ orders.
-- The result should be sorted by address and then by restaurant name.

SELECT address,
       pz.name,
       count(pz.name) AS count_of_orders
FROM person
         JOIN person_order po on person.id = po.person_id
         JOIN menu m on m.id = po.menu_id
         JOIN pizzeria pz on pz.id = m.pizzeria_id
GROUP BY 1, 2
ORDER BY 1, 2;