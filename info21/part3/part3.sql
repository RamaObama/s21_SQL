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

-- BEGIN;
-- CALL prc_peers_completed_task('C', 'cursor');
-- FETCH ALL IN "cursor";
-- END;

-- 8) Determine which peer each student should go to for a check.
-- You should determine it according to the recommendations of the peer's friends, i.e. you need to find the peer with the greatest number of friends who recommend to be checked by him.
-- Output format: peer's nickname, nickname of the checker found

DROP PROCEDURE IF EXISTS prc_most_recommended_peer(cursor refcursor) CASCADE;

CREATE OR REPLACE PROCEDURE prc_most_recommended_peer(IN cursor refcursor) AS
$$
BEGIN
    OPEN cursor FOR
        WITH friend AS (SELECT nickname,
                               (CASE WHEN nickname = f.peer1 THEN peer2 ELSE peer1 END) AS friends
                        FROM peers
                                 JOIN friends f ON peers.nickname = f.peer1
                            AND peers.nickname = f.peer2),
             recommend AS (SELECT nickname,
                                  count(recommendedpeer) AS count,
                                  recommendedpeer
                           FROM friend f
                                    JOIN recommendations r ON f.friends = r.peer
                           WHERE f.nickname != r.recommendedpeer
                           GROUP BY nickname, recommendedpeer),
             max AS (SELECT nickname,
                            max(count) AS max_count
                     FROM recommend
                     GROUP BY nickname)
        SELECT r.nickname      AS Peer,
               recommendedpeer AS RecommendedPeer
        FROM recommend r
                 JOIN max m ON r.nickname = m.nickname
            AND r.count = max.max_count;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL find_most_recommend_peer('cursor');
-- FETCH ALL IN "cursor";
-- END;

-- 9) Determine the percentage of peers who:
--
-- Started only block 1
-- Started only block 2
-- Started both
-- Have not started any of them
--
-- A peer is considered to have started a block if he has at least one check of any task from this block (according to the Checks table)
-- Procedure parameters: name of block 1, for example SQL, name of block 2, for example A.
-- Output format: percentage of those who started only the first block, percentage of those who started only the second block, percentage of those who started both blocks, percentage of those who did not started any of them

DROP PROCEDURE IF EXISTS prc_started_two_blocks CASCADE;

CREATE OR REPLACE PROCEDURE prc_started_two_blocks(
    IN block1 TEXT,
    IN block2 TEXT,
    OUT StartedBlock1 BIGINT,
    OUT StartedBlock2 BIGINT,
    OUT StartedBothBlocks BIGINT,
    OUT DidntStartAnyBlock BIGINT) AS
$$
DECLARE
    count_peers BIGINT := (SELECT count(p.nickname)
                           FROM peers p);
BEGIN
    CREATE TABLE tmp
    (
        bl1   TEXT,
        bl2   TEXT,
        count BIGINT
    );
    INSERT INTO tmp VALUES (block1, block2, count_peers);

    CREATE VIEW both_block AS
    (
    WITH started_bl1 AS (SELECT DISTINCT peer
                         FROM checks c
                         WHERE c.task SIMILAR TO concat((SELECT bl1 FROM tmp), '[0-9]%')),
         started_bl2 AS (SELECT DISTINCT peer
                         FROM checks c
                         WHERE c.task SIMILAR TO concat((SELECT bl2 FROM tmp), '[0-9]%')),
         only_bl1 AS (SELECT peer
                      FROM started_bl1
                      EXCEPT
                      SELECT peer
                      FROM started_bl2),
         only_bl2 AS (SELECT peer
                      FROM started_bl2
                      EXCEPT
                      SELECT peer
                      FROM started_bl1),
         start_both AS (SELECT peer
                        FROM started_bl1
                        INTERSECT
                        SELECT peer
                        FROM started_bl2),
         no_start AS (SELECT count(nickname) AS peer_count
                      FROM peers
                               LEFT JOIN checks c ON peers.nickname = c.peer
                      WHERE peer IS NULL)
    SELECT (((SELECT count(*) FROM only_bl1) * 100) / (SELECT count FROM tmp))   AS q1,
           (((SELECT count(*) FROM only_bl2) * 100) / (SELECT count FROM tmp))   AS q2,
           (((SELECT count(*) FROM start_both) * 100) / (SELECT count FROM tmp)) AS q3,
           (((SELECT peer_count FROM no_start) * 100) / (SELECT count FROM tmp)) AS q4);

    StartedBlock1 = (SELECT q1 FROM both_block);
    StartedBlock2 = (SELECT q2 FROM both_block);
    StartedBothBlocks = (SELECT q3 FROM both_block);
    DidntStartAnyBlock = (SELECT q4 FROM both_block);

    DROP VIEW both_block CASCADE;
    DROP TABLE tmp CASCADE;
END;
$$
    LANGUAGE plpgsql;

-- CALL prc_started_two_blocks('C', 'DO', NULL, NULL, NULL, NULL);

-- 10) Determine the percentage of peers who have ever successfully passed a check on their birthday
-- Also determine the percentage of peers who have ever failed a check on their birthday.
-- Output format: percentage  of peers who have ever successfully passed a check on their birthday, percentage of peers who have ever failed a check on their birthday

DROP PROCEDURE IF EXISTS prc_successfully_checks_of_birthday CASCADE;

CREATE OR REPLACE PROCEDURE prc_successfully_checks_of_birthday(cursor refcursor default 'cursor')
AS
$$
BEGIN
    OPEN cursor FOR
        WITH birthday AS (SELECT nickname,
                                 coalesce(xp."Check", 0) AS status
                          FROM (SELECT *
                                FROM checks c
                                         JOIN peers p ON p.nickname = c.peer
                                WHERE (SELECT extract(DAY FROM birthday)) = (SELECT extract(DAY FROM date))
                                  AND (SELECT extract(MONTH FROM birthday)) =
                                      (SELECT extract(MONTH FROM date))) AS birt
                                   LEFT JOIN xp ON xp."Check" = birt.id
                          GROUP BY nickname, status)
        SELECT round((SELECT count(DISTINCT b.nickname)
                      FROM birthday b
                      WHERE status > 0)::NUMERIC * 100 / count(peers.nickname)::NUMERIC) AS SuccessfulChecks,
               round((SELECT count(DISTINCT b.nickname)
                      FROM birthday b
                      WHERE status = 0)::NUMERIC * 100 / count(peers.nickname)::NUMERIC) AS UnsuccessfulChecks
        FROM peers;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_successfully_checks_of_birthday();
-- FETCH ALL FROM "cursor";
-- END;

-- 11) Determine all peers who did the given tasks 1 and 2, but did not do task 3
-- Procedure parameters: names of tasks 1, 2 and 3.
-- Output format: list of peers

DROP PROCEDURE IF EXISTS prc_successfully_task_1_2_not_3 CASCADE;

CREATE OR REPLACE PROCEDURE prc_successfully_task_1_2_not_3(task1 VARCHAR, task2 VARCHAR, task3 VARCHAR,
                                                            cursor refcursor default 'cursor') AS
$$
BEGIN
    OPEN cursor FOR
        WITH success AS (SELECT peer, count(peer)
                         FROM (SELECT peer, task
                               FROM ((SELECT *
                                      FROM checks c
                                               JOIN xp x ON c.id = x."Check"
                                      WHERE task = task1)
                                     UNION
                                     (SELECT *
                                      FROM checks c
                                               JOIN xp x ON c.id = x."Check"
                                      WHERE task = task2)) q1
                               GROUP BY peer, task) q2
                         GROUP BY peer
                         HAVING count(peer) = 2)
        SELECT peer
        FROM success
        EXCEPT
        (SELECT s.peer
         FROM success s
                  JOIN checks c ON c.peer = s.peer
                  JOIN xp x ON c.id = x."Check"
         WHERE task = task3);
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_successfully_task_1_2_not_3('C2_SimpleBashUtils', 'C4_s21_math', 'A4_Crypto');
-- FETCH ALL FROM "cursor";
-- END;

-- 12) Using recursive common table expression, output the number of preceding tasks for each task
-- I. e. How many tasks have to be done, based on entry conditions, to get access to the current one.
-- Output format: task name, number of preceding tasks

DROP PROCEDURE IF EXISTS prc_count_parent_tasks CASCADE;

CREATE OR REPLACE PROCEDURE prc_count_parent_tasks(cursor refcursor default 'cursor')
AS
$$
BEGIN
    OPEN cursor FOR
        WITH RECURSIVE parent AS (SELECT (SELECT title
                                          FROM tasks
                                          WHERE parenttask IS NULL) AS Task,
                                         0                          AS PrevCount
                                  UNION ALL
                                  SELECT t.title,
                                         PrevCount + 1
                                  FROM parent p
                                           JOIN tasks t ON t."parenttask" = p.Task)
        SELECT *
        FROM parent;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_count_parent_tasks();
-- FETCH ALL FROM "cursor";
-- END;

-- 13) Find "lucky" days for checks. A day is considered "lucky" if it has at least N consecutive successful checks
-- Parameters of the procedure: the N number of consecutive successful checks .
-- The time of the check is the start time of the P2P step.
-- Successful consecutive checks are the checks with no unsuccessful checks in between.
-- The amount of XP for each of these checks must be at least 80% of the maximum.
-- Output format: list of days

DROP PROCEDURE IF EXISTS prc_lucky_day CASCADE;

CREATE OR REPLACE PROCEDURE prc_lucky_day(IN N INT, IN cursor refcursor default 'cursor') AS
$$
BEGIN
    OPEN cursor FOR
        WITH lucky AS (SELECT *
                       FROM checks c
                                JOIN p2p p ON c.id = p."Check"
                                LEFT JOIN verter v ON c.id = v."Check"
                                JOIN tasks t ON c.task = t.title
                                JOIN xp x ON c.id = x."Check"
                       WHERE p.state = 'Success'
                         AND (v.state = 'Success' OR v.state IS NULL))
        SELECT date
        FROM lucky l
        WHERE l.xpamount >= l.maxxp * 0.8
        GROUP BY date
        HAVING COUNT(date) >= N;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_lucky_day(3);
-- FETCH ALL IN "cursor";
-- END;

-- 14) Find the peer with the highest amount of XP
-- Output format: peer's nickname, amount of XP

DROP PROCEDURE IF EXISTS prc_max_peer_xp CASCADE;

CREATE OR REPLACE PROCEDURE prc_max_peer_xp(IN cursor refcursor default 'cursor') AS
$$
BEGIN
    OPEN cursor FOR
        SELECT peer,
               sum(xpamount) AS XP
        FROM xp
                 JOIN checks c ON xp."Check" = c.id
        GROUP BY peer
        ORDER BY XP DESC
        LIMIT 1;
END;
$$
    LANGUAGE plpgsql;

-- BEGIN;
-- CALL prc_max_peer_xp();
-- FETCH ALL IN "cursor";
-- END;