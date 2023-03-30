-- Find names of all female persons older than 25 and order the result by name.

SELECT name
FROM person
WHERE gender = 'female'
  AND age > 25
ORDER BY name;
