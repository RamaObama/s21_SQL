SELECT pers_o.order_date                          AS order_date,
       CONCAT(pers.name, ' (age:', pers.age, ')') AS person_information
FROM (person_order AS pers_o(primary_id, id, menu_id, order_date)
    NATURAL JOIN person pers)
ORDER BY order_date ASC, person_information ASC;