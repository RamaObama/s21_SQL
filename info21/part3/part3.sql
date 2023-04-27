-- 1) Write a function that returns the TransferredPoints table in a more human-readable form
-- Peer's nickname 1, Peer's nickname 2, number of transferred peer points.
-- The number is negative if peer 2 received more points from peer 1.

DROP FUNCTION IF EXISTS human_readable_points();

CREATE OR REPLACE FUNCTION human_readable_points()
    RETURNS TABLE
            (
                Peer1        VARCHAR,
                Peer2        VARCHAR,
                PointsAmount BIGINT
            )
AS
$$
BEGIN
    RETURN QUERY (SELECT tPoint1.checkingpeer,
                         tPoint1.checkedpeer,
                         (tPoint1.pointsamount - tPoint2.pointsamount) AS PointsAmount
                  FROM transferredpoints tPoint1
                           JOIN transferredpoints tPoint2 ON tPoint1.checkingpeer = tPoint2.checkedpeer
                      AND tPoint1.checkedpeer = tPoint2.checkingpeer
                      AND tPoint1.id < tPoint2.id);
END;
$$
    LANGUAGE plpgsql;

-- SELECT * FROM human_readable_points();

-- 2) Write a function that returns a table of the following form: user name, name of the checked task, number of XP received
-- Include in the table only tasks that have successfully passed the check (according to the Checks table).
-- One task can be completed successfully several times. In this case, include all successful checks in the table.

DROP FUNCTION IF EXISTS get_amount_xp_gained();

CREATE OR REPLACE FUNCTION get_amount_xp_gained()
    RETURNS TABLE
            (
                Peer VARCHAR,
                Task TEXT,
                XP   BIGINT
            )
AS
$$
BEGIN
    RETURN QUERY (SELECT c.peer,
                         c.task,
                         x.xpamount
                  FROM xp x
                           JOIN checks c ON x."Check" = c.id);
END;
$$
    LANGUAGE plpgsql;

-- SELECT * FROM get_amount_xp_gained();

-- 3) Write a function that finds the peers who have not left campus for the whole day
-- Function parameters: day, for example 12.05.2022.
-- The function returns only a list of peers.

DROP FUNCTION IF EXISTS peers_not_left_campus(IN day date);

CREATE OR REPLACE FUNCTION peers_not_left_campus(IN day date)
    RETURNS TABLE
            (
                Peers VARCHAR
            )
AS
$$
BEGIN
    RETURN QUERY (SELECT peer
                  FROM timetracking t
                  WHERE t.date = day
                  GROUP BY peer
                  HAVING count(state) < 3);
END ;
$$
    LANGUAGE plpgsql;

-- SELECT * FROM peers_not_left_campus('2022-09-01');

-- 4) Calculate the change in the number of peer points of each peer using the TransferredPoints table
-- Output the result sorted by the change in the number of points.
-- Output format: peer's nickname, change in the number of peer points

DROP PROCEDURE IF EXISTS prc_changes_peer_points(cursor refcursor);

CREATE OR REPLACE PROCEDURE prc_changes_peer_points(IN cursor refcursor) AS
$$
BEGIN
    OPEN cursor FOR
        WITH sum_checking AS (SELECT checkingpeer,
                                     ABS(SUM(pointsamount)) AS sum_points
                              FROM transferredpoints
                              GROUP BY checkingpeer),
             sum_checked AS (SELECT checkedpeer,
                                    ABS(SUM(pointsamount)) AS sum_points
                             FROM transferredpoints
                             GROUP BY checkedpeer)
        SELECT checkingpeer                                                                     AS Peer,
               ((COALESCE(sum_checking.sum_points, 0)) - (COALESCE(sum_checked.sum_points, 0))) AS PointsChange
        FROM sum_checking
                 JOIN sum_checked ON sum_checking.checkingpeer = sum_checked.checkedpeer
        ORDER BY PointsChange DESC;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_changes_peer_points('cursor');
-- FETCH ALL IN "cursor";
-- END;

-- 5) Calculate the change in the number of peer points of each peer using the table returned by the first function from Part 3
-- Output the result sorted by the change in the number of points.
-- Output format: peer's nickname, change in the number of peer points

DROP PROCEDURE IF EXISTS prc_changes_peer_points_v2(cursor refcursor);

CREATE OR REPLACE PROCEDURE prc_changes_peer_points_v2(IN cursor refcursor) AS
$$
BEGIN
    OPEN cursor FOR
        WITH peer1 AS (SELECT Peer1             AS Peer,
                              SUM(pointsamount) AS PointsChange
                       FROM human_readable_points()
                       GROUP BY Peer1),
             peer2 AS (SELECT Peer2             AS Peer,
                              SUM(pointsamount) AS PointsChange
                       FROM human_readable_points()
                       GROUP BY Peer2)
        SELECT COALESCE(peer1.Peer, peer2.Peer)                                    AS Peer,
               (COALESCE(peer1.PointsChange, 0) - COALESCE(peer2.PointsChange, 0)) AS PointsChange
        FROM peer1
                 FULL JOIN peer2 ON peer1.Peer = peer2.Peer
        ORDER BY PointsChange DESC;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_changes_peer_points_v2('cursor');
-- FETCH ALL IN "cursor";
-- END;

-- 6) Find the most frequently checked task for each day
-- If there is the same number of checks for some tasks in a certain day, output all of them.
-- Output format: day, task name

DROP PROCEDURE IF EXISTS prc_most_frequently_checked_task(cursor refcursor);

CREATE OR REPLACE PROCEDURE prc_most_frequently_checked_task(cursor refcursor) AS
$$
BEGIN
    OPEN cursor FOR
        WITH task1 AS (SELECT task,
                              date,
                              count(*) AS counts
                       FROM checks
                       GROUP BY task, date),
             task2 AS (SELECT task1.task,
                              task1.date,
                              rank() OVER (PARTITION BY task1.date ORDER BY task1.counts) AS rank
                       FROM task1)
        SELECT task2.date, task2.task
        FROM task2
        WHERE rank = 1;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_most_frequently_checked_task('cursor');
-- FETCH ALL IN "cursor";
-- END;

-- 7) Find all peers who have completed the whole given block of tasks and the completion date of the last task
-- Procedure parameters: name of the block, for example “CPP”.
-- The result is sorted by the date of completion.
-- Output format: peer's name, date of completion of the block (i.e. the last completed task from that block)

DROP PROCEDURE IF EXISTS prc_peers_completed_task(block_task VARCHAR, cursor refcursor) CASCADE;

CREATE OR REPLACE PROCEDURE prc_peers_completed_task(
    IN block_task VARCHAR,
    IN cursor refcursor) AS
$$
BEGIN
    OPEN cursor FOR
        WITH task AS (SELECT *
                      FROM tasks
                      WHERE title SIMILAR TO concat(block_task, '[0-9]%')),
             last AS (SELECT max(title) AS title
                      FROM task),
             success AS (SELECT c.peer,
                                c.task,
                                c.date
                         FROM checks c
                                  JOIN p2p ON c.id = p2p."Check"
                         WHERE p2p.state = 'Success'
                         GROUP BY c.id)
        SELECT s.peer AS Peer,
               s.date AS Day
        FROM success s
                 JOIN last l ON s.task = l.title;
END;
$$
    LANGUAGE plpgsql;

BEGIN;
CALL prc_peers_completed_task('C', 'cursor');
FETCH ALL IN "cursor";
END;