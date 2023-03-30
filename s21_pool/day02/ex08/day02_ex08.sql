-- Please find the names of all males from Moscow or Samara cities who orders either pepperoni or mushroom pizzas (or both) .
-- Please order the result by person name in descending mode.

SELECT list.name
FROM (SELECT pers.id,
             pers.name
      FROM person AS pers
      WHERE pers.gender = 'male'
        AND pers.address IN ('Moscow', 'Samara')) AS list
         LEFT JOIN (SELECT m.id
                    FROM menu AS m
                    WHERE m.pizza_name IN ('pepperoni pizza', 'mushroom pizza')) AS name_pizza
                   ON list.id = name_pizza.id
ORDER BY list.name DESC;