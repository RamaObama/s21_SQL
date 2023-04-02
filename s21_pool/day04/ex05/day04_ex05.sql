-- Please create a Database View v_price_with_discount that returns a person's orders with person names, pizza names, real price and calculated column discount_price (with applied 10% discount and satisfies formula price - price*0.1).
-- The result please sort by person name and pizza name and make a round for discount_price column to integer type.

CREATE VIEW v_price_with_discount
AS
WITH orders AS (SELECT p.name, m.pizza_name, m.price
                FROM person_order po
                         JOIN person p on po.person_id = p.id
                         JOIN menu m on po.menu_id = m.id)
SELECT *, round(price - price * 0.1) AS discount_price
FROM orders
ORDER BY name, pizza_name;

-- SELECT * FROM v_price_with_discount;
-- DROP VIEW v_price_with_discount;