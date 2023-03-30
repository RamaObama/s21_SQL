SELECT day::date AS missing_date
FROM GENERATE_SERIES('2022-01-01'::date, '2022-01-10'::date, '1 day') AS day
         LEFT JOIN (SELECT pers_v.visit_date
                    FROM person_visits AS pers_v
                    WHERE pers_v.person_id = 1
                       OR pers_v.person_id = 2) query2
                   ON day = query2.visit_date
WHERE visit_date IS NULL
ORDER BY missing_date;