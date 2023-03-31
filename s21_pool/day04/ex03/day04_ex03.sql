-- Please write a SQL statement which returns missing days for persons’ visits in January of 2022.
-- Use v_generated_dates view for that task and sort the result by missing_date column.

SELECT dates.generated_date AS missing_date
FROM v_generated_dates dates
EXCEPT
SELECT pv.visit_date
FROM person_visits pv
ORDER BY 1;
