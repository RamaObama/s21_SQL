(SELECT pers.name AS object_name
 FROM person AS pers
 ORDER BY object_name)
UNION ALL
(SELECT mu.pizza_name AS object_name
 FROM menu AS mu
 ORDER BY object_name);

-- MAC version???
-- SELECT mu.id AS object_id, mu.pizza_name AS object_name
-- FROM menu AS mu
-- UNION
-- SELECT pers.id AS object_id, pers.name AS object_id
-- FROM person AS pers
-- ORDER BY object_id, object_name;

select t1.object_name
from (select pizza_name as object_name, 'menu' as label
      from menu
      union all
      select name, 'person' as label
      from person
      order by label desc, object_name) as t1;