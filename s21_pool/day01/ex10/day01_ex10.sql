SELECT pers.name AS name, pizza_name, pizza.name AS pizzeria_name
FROM person_order pers_o
         JOIN person pers ON pers.id = pers_o.person_id
         JOIN menu mu on mu.id = pers_o.menu_id
         JOIN pizzeria pizza on pizza.id = mu.pizzeria_id
ORDER BY name, pizza_name, pizzeria_name;