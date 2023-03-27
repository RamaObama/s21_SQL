SELECT (SELECT person.name
        FROM person
        WHERE person.id = pers_o.person_id) AS name,
       CASE
           WHEN (SELECT person.name
                 FROM person
                 WHERE person.id = pers_o.person_id) = 'Denis'
               THEN TRUE
           ELSE FALSE
           END                              AS check_name
FROM person_order AS pers_o
WHERE (pers_o.menu_id = 13 OR pers_o.menu_id = 14 OR pers_o.menu_id = 18)
  AND pers_o.order_date = '2022-01-07';
