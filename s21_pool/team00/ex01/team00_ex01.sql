-- Please add a possibility to see additional rows with the most expensive cost to the SQL from previous exercise. Just take a look at the sample of data below.
-- Please sort data by total_cost and then by tour.

SELECT sum                                         AS total_cost,
       '{' || way.tour || ',' || way.point2 || '}' AS tour
FROM way
WHERE length(tour) = 7
  AND point2 = 'A'
  AND (sum = (SELECT min(sum)
              FROM way
              WHERE length(tour) = 7
                AND point2 = 'A')
    OR sum = (SELECT max(sum)
              FROM way
              WHERE length(tour) = 7
                AND point2 = 'A'))
ORDER BY 1, 2;