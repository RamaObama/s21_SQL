WITH visits AS (SELECT pers_v.visit_date
                FROM person_visits AS pers_v
                WHERE pers_v.person_id = 1 OR pers_v.person_id = 2),
     dates AS (SELECT day::date AS missing_date
               FROM GENERATE_SERIES('2022-01-01'::date, '2022-01-10'::date, '1 day') AS day)
SELECT dates.missing_date
FROM dates
         FULL OUTER JOIN visits ON dates.missing_date = visits.visit_date
WHERE visit_date IS NULL
ORDER BY missing_date;