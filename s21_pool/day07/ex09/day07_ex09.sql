-- Please write a SQL statement that returns aggregated information by person’s address ,
-- the result of “Maximal Age - (Minimal Age / Maximal Age)” that is presented as a formula column,
-- next one is average age per address and the result of comparison between formula and average columns
-- (other words, if formula is greater than average then True, otherwise False value).
--
-- The result should be sorted by address column.

-- Вариант #1.
WITH max AS (SELECT address,
                    max(age) AS age_max
             FROM person
             GROUP BY 1),
     min AS (SELECT address,
                    min(age) AS age_min
             FROM person
             GROUP BY 1),
     avg AS (SELECT address,
                    avg(age) AS age_avg
             FROM person
             GROUP BY 1)
SELECT DISTINCT address,
                round(age_max - age_min / cast(age_max AS NUMERIC), 2)   AS formula,
                round(age_avg, 2)                                        AS average,
                (age_max - age_min / cast(age_max AS NUMERIC)) > age_avg AS comparison
FROM person
         NATURAL JOIN max
         NATURAL JOIN min
         NATURAL JOIN avg
ORDER BY 1;

-- Вариант #2.
SELECT DISTINCT address,
                round(max(age::numeric) - (min(age::numeric) / max(age::numeric)), 2)             AS formula,
                round(avg(age::numeric), 2)                                                       AS average,
                (max(age::numeric) - (min(age::numeric) / max(age::numeric))) > avg(age::numeric) AS comparison
FROM person
GROUP BY 1
ORDER BY 1;