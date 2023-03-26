-- Вариант № 1
-- SELECT name, age FROM person WHERE address = 'Kazan';
-- Вариант № 2
SELECT per.name, per.age
FROM person AS per
WHERE per.address = 'Kazan';