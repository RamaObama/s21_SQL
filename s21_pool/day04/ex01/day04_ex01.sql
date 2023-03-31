-- Please use 2 Database Views from Exercise #00 and write SQL to get female and male person names in one list.
-- Please set the order by person name.

SELECT female.name
FROM v_persons_female female
UNION ALL
SELECT male.name
FROM v_persons_male male
ORDER BY 1;