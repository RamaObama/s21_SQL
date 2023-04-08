-- Let’s look at pl/pgsql functions right now.
-- Please create a pl/pgsql function  fnc_person_visits_and_eats_on_date based on
-- SQL statement that finds the names of pizzerias which person
-- (IN pperson parameter with default value is ‘Dmitriy’)
-- visited and bought pizza for less than the given sum in rubles
-- (IN pprice parameter with default value is 500) on the specific date
-- (IN pdate parameter with default value is 8th of January 2022).
-- To check yourself and call a function, you can make a statement like below.

-- Вариант №1.
CREATE FUNCTION fnc_person_visits_and_eats_on_date(
    IN pperson varchar DEFAULT 'Dmitriy',
    IN pprice numeric DEFAULT 500,
    IN pdate date DEFAULT '2022-01-08')
    RETURNS TABLE
            (
                pizzeria_name varchar
            )
AS
$$
BEGIN
    RETURN QUERY ((SELECT pz.name AS pizzeria_name
                   FROM (SELECT *
                         FROM person_visits pv
                         WHERE pv.visit_date = pdate) visit
                            JOIN (SELECT *
                                  FROM person
                                  WHERE person.name = pperson) pers
                                 ON visit.person_id = pers.id
                            JOIN pizzeria pz
                                 ON visit.pizzeria_id = pz.id
                            JOIN (SELECT *
                                  FROM menu
                                  WHERE menu.price < pprice) me
                                 ON pz.id = me.pizzeria_id)
                  INTERSECT
                  (SELECT pz.name
                   FROM (SELECT *
                         FROM person_order po
                         WHERE po.order_date = pdate) ord
                            JOIN (SELECT *
                                  FROM person
                                  WHERE person.name = pperson) pers
                                 ON ord.person_id = pers.id
                            JOIN (SELECT *
                                  FROM menu
                                  WHERE menu.price < pprice) me
                                 ON ord.menu_id = me.id
                            JOIN pizzeria pz
                                 ON me.pizzeria_id = pz.id));
END;
$$ LANGUAGE plpgsql;

-- Вариант №2.
CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date_2(
    pperson varchar DEFAULT 'Dmitriy',
    pprice numeric DEFAULT 500,
    pdate date DEFAULT '2022-01-08'
)
    RETURNS TABLE
            (
                pizzeria_name varchar
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT DISTINCT p.name AS pizzeria_name
        FROM person_visits pv
                 JOIN person_order po
                      ON po.person_id = pv.person_id
                          AND po.menu_id IN
                              (SELECT id
                               FROM menu
                               WHERE price < pprice
                                 AND pizzeria_id = pv.pizzeria_id)
                 JOIN pizzeria p ON p.id = pv.pizzeria_id
                 JOIN person per ON per.id = pv.person_id
        WHERE per.name = pperson
          AND pv.visit_date = pdate;
END;
$$ LANGUAGE plpgsql;

-- Вариант №3.
CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date_3(
    pperson varchar DEFAULT 'Dmitriy',
    pprice numeric DEFAULT 500,
    pdate date DEFAULT '2022-01-08'
)
    RETURNS TABLE
            (
                pizzeria_name varchar
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT /*DISTINCT*/ p.name AS pizzeria_name
        FROM person_visits pv
--                  JOIN person_order po ON po.person_id = pv.person_id
                 JOIN menu m ON /*m.id = po.menu_id AND*/ m.price < pprice AND m.pizzeria_id = pv.pizzeria_id
                 JOIN pizzeria p ON p.id = pv.pizzeria_id
                 JOIN person per ON per.id = pv.person_id AND per.name = pperson
        WHERE pv.visit_date = pdate
        ORDER BY 1 DESC;
END;
$$ LANGUAGE plpgsql;

-- Вариант №1.
SELECT *
FROM fnc_person_visits_and_eats_on_date(pprice := 800);

SELECT *
FROM fnc_person_visits_and_eats_on_date(pperson := 'Anna', pprice := 1300, pdate := '2022-01-01');

-- Вариант №2.
SELECT *
FROM fnc_person_visits_and_eats_on_date_2(pprice := 800);

SELECT *
FROM fnc_person_visits_and_eats_on_date_2(pperson := 'Anna', pprice := 1300, pdate := '2022-01-01');

-- Вариант №3.
SELECT *
FROM fnc_person_visits_and_eats_on_date_3(pprice := 800);

SELECT *
FROM fnc_person_visits_and_eats_on_date_3(pperson := 'Anna', pprice := 1300, pdate := '2022-01-01');