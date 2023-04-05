-- Please write a SQL statement that returns the amount of orders, average of price, maximum and minimum prices for sold pizza by corresponding pizzeria restaurant.
-- The result should be sorted by pizzeria name. Please take a look at the data sample below.
--
-- Round your average price to 2 floating numbers.

SELECT pz.name,
       count(pz.name)         AS count_of_orders,
       round(avg(m.price), 2) AS average_price,
       max(m.price)           AS max_price,
       min(m.price)           AS min_price
FROM person_order po
         JOIN menu m on m.id = po.menu_id
         JOIN pizzeria pz on pz.id = m.pizzeria_id
GROUP BY 1
ORDER BY 1;