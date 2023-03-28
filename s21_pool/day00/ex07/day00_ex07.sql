SELECT pers.id,
       pers.name,
       CASE
           WHEN (pers.age BETWEEN 10 AND 20) THEN 'interval #1'
           WHEN (pers.age > 20 AND pers.age < 24) THEN 'interval #2'
           ELSE 'interval #3' END AS interval_info
FROM person AS pers
ORDER BY interval_info;