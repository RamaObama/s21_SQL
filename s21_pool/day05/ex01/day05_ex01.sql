-- Before further steps please write a SQL statement that returns pizzas’ and corresponding pizzeria names.
-- Please take a look at the sample result below (no sort needed).
--
-- __________________________________
-- |  pizza_name  |  pizzeria_name  |
-- | cheese pizza |    Pizza Hut    |
-- | ...          | ...             |
-- ----------------------------------
-- Let’s provide proof that your indexes are working for your SQL.
-- The sample of proof is the output of the EXPLAIN ANALYZE command.
-- Please take a look at the sample output command.

SET ENABLE_SEQSCAN = OFF;

SELECT m.pizza_name,
       p.name AS pizzeria_name
FROM menu m
         JOIN pizzeria p ON m.pizzeria_id = p.id;

EXPLAIN ANALYZE
SELECT m.pizza_name,
       p.name AS pizzeria_name
FROM menu m
         JOIN pizzeria p ON m.pizzeria_id = p.id;