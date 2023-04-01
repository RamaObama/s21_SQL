-- Please take a look at the Graph on the left.

-- There are 4 cities (a, b, c and d) and arcs between them with cost (or taxination).
-- Actually the cost (a,b) = (b,a).
--
-- Please create a table with name nodes by using structure {point1, point2, cost} and fill data based on a picture (remember there are direct and reverse paths between 2 nodes).
--
-- Please write one SQL statement that returns all tours (aka paths) with minimal traveling cost if we will start from city "a".
-- Just remember, you need to find the cheapest way of visiting all the cities and returning to your starting point.
-- For example, the tour looks like that a -> b -> c -> d -> a.
--
-- The sample of output data you can find below.
-- Please sort data by total_cost and then by tour.
-- ____________________________
-- | total_cost |     tour    |
-- | 80         | {a,b,d,c,a} |
-- | ...        | ...         |
-- ----------------------------

CREATE TABLE IF NOT EXISTS nodes
(
    point1 char NOT NULL,
    point2 char NOT NULL,
    cost   int  NOT NULL
);

INSERT INTO nodes
VALUES ('A', 'B', 10),
       ('B', 'A', 10),
       ('A', 'C', 15),
       ('C', 'A', 15),
       ('C', 'B', 35),
       ('B', 'C', 35),
       ('A', 'D', 20),
       ('D', 'A', 20),
       ('C', 'D', 30),
       ('D', 'C', 30),
       ('D', 'B', 25),
       ('B', 'D', 25);

SELECT *
FROM nodes;

