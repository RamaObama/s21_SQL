SELECT pers_o.order_date                    AS orfer_date,
       CONCAT(p.name, ' (age:', p.age, ')') AS person_information
FROM person_order pers_o
         JOIN person p ON pers_o.person_id = p.id
ORDER BY order_date ASC, person_information ASC;