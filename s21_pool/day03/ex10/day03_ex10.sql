-- Please register new orders from Denis and Irina on 24th of February 2022 for the new menu with “sicilian pizza”.
--
-- Warning: this exercise will probably be the cause  of changing data in the wrong way.
-- Actually, you can restore the initial database model with data from the link in the “Rules of the day” section and replay script from Exercises 07 , 08 and 09.

INSERT INTO person_order
VALUES ((SELECT max(id)
         FROM person_order) + 1,
        (SELECT p.id
         FROM person p
         WHERE p.name = 'Denis'),
        (SELECT m.id
         FROM menu m
         WHERE m.pizza_name = 'sicilian pizza'),
        '2022-02-24'::date),
       ((SELECT max(id)
         FROM person_order) + 2,
        (SELECT p.id
         FROM person p
         WHERE p.name = 'Irina'),
        (SELECT m.id
         FROM menu m
         WHERE m.pizza_name = 'sicilian pizza'),
        '2022-02-24'::date);

-- SELECT * FROM person_order;

-- DELETE FROM person_order WHERE id = 21;
-- DELETE FROM person_order WHERE id = 22;