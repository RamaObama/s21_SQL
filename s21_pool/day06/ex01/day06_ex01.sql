-- Actually, we created a structure to store our discounts and we are ready to go further and fill our person_discounts table with new records.
-- So, there is a table person_order that stores the history of a person's orders.
-- Please write a DML statement (INSERT INTO ... SELECT ...) that makes  inserts new records into person_discounts table based on the next rules.
--
-- take aggregated state by person_id and pizzeria_id columns
--
-- calculate personal discount value by the next pseudo code:
-- if “amount of orders” = 1 then “discount” = 10.5  else if “amount of orders” = 2 then  “discount” = 22 else  “discount” = 30
--
-- to generate a primary key for the person_discounts table please use  SQL construction below (this construction is from the WINDOW FUNCTION  SQL area).
-- ... ROW_NUMBER( ) OVER ( ) AS id ...

INSERT INTO person_discounts (id, person_id, pizzeria_id, discount)
SELECT row_number() OVER () AS id,
       amount.person_id,
       amount.pizzeria_id,
       CASE
           WHEN amount.orders = 1 THEN 10.5
           WHEN amount.orders = 2 THEN 22
           ELSE 30
           END              AS discount
FROM (SELECT person_id, pizzeria_id, count(person_id) AS orders
      FROM person_order
               JOIN menu m on person_order.menu_id = m.id
      GROUP BY person_id, pizzeria_id
      ORDER BY 1, 2) AS amount;
