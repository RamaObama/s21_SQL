-- Please find the names of persons who live on the same address.
-- Make sure that the result is ordered by 1st person, 2nd person's name and common address.
-- The  data sample is presented below.

-- Вариант №1
SELECT p1.name    AS person_name1,
       p2.name    AS person_name2,
       p1.address AS common_address
FROM person AS p1
         JOIN person AS p2 ON p1.address = p2.address
WHERE p1.id > p2.id
ORDER BY person_name1, person_name2, common_address;

-- Вариант №2
WITH find AS (SELECT p1.name    AS person_name1,
                     p2.name    AS person_name2,
                     p1.address AS common_address,
                     p1.id      AS id1,
                     p2.id      AS id2
              FROM person p1
                       JOIN person p2 ON p1.address = p2.address
              ORDER BY 1, 2, 3)
SELECT person_name1, person_name2, common_address
FROM find
WHERE id1 > id2;