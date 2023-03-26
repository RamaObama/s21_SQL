-- Вариант № 1
-- SELECT name, age FROM person WHERE address = 'Kazan' AND gender = 'female' ORDER BY name;
-- Вариант № 2
SELECT per.name, per.age FROM person AS per WHERE per.address = 'Kazan' AыND per.gender = 'female' ORDER BY per.name;