-- Please register new visits into Dominos restaurant from Denis and Irina on 24th of February 2022.
--
-- Warning: this exercise will probably be the cause  of changing data in the wrong way.
-- Actually, you can restore the initial database model with data from the link in the “Rules of the day” section and replay script from Exercises 07 and 08..

INSERT INTO person_visits
VALUES ((SELECT max(id)
         FROM person_visits) + 1,
        (SELECT p.id
         FROM person p
         WHERE p.name = 'Denis'),
        (SELECT pi.id
         FROM pizzeria pi
         WHERE pi.name = 'Dominos'),
        '2020-02-24'::date),
       ((SELECT max(id)
         FROM person_visits) + 2,
        (SELECT p.id
         FROM person p
         WHERE p.name = 'Irina'),
        (SELECT pi.id
         FROM pizzeria pi
         WHERE pi.name = 'Dominos'),
        '2020-02-24'::date);

-- SELECT * FROM person_visits;
--
-- DELETE FROM person_visits WHERE id = 20;
-- DELETE FROM person_visits WHERE id = 21;