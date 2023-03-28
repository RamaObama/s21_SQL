SELECT *
FROM person_order
WHERE mod(person_order.id, 2) = 0
ORDER BY id;