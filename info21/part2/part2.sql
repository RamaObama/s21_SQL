-- 1) Write a procedure for adding P2P check
-- Parameters: nickname of the person being checked, checker's nickname, task name, P2P check status, time.
-- If the status is "start", add a record in the Checks table (use today's date).
-- Add a record in the P2P table.
-- If the status is "start", specify the record just added as a check, otherwise specify the check with the unfinished P2P step.

DROP PROCEDURE IF EXISTS add_peer_review CASCADE;

CREATE OR REPLACE PROCEDURE add_peer_review(
    IN nickname_check_peer VARCHAR,
    IN nickname_in_peer VARCHAR,
    IN task_name VARCHAR,
    IN status check_status,
    IN check_time TIME
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (status = 'Start') THEN
        IF ((SELECT count(*)
             FROM p2p
                      JOIN checks ON p2p."Check" = checks.id
             WHERE p2p.checkingpeer = nickname_in_peer
               AND checks.peer = nickname_check_peer
               AND checks.task = task_name) = 1) THEN
            RAISE EXCEPTION 'Error: This peer pair has an incomplete check.';
        ELSE
            INSERT INTO checks
            VALUES ((SELECT max(id) FROM checks) + 1,
                    nickname_check_peer,
                    task_name,
                    now());
            INSERT INTO p2p
            VALUES ((SELECT max(id) FROM p2p) + 1,
                    (SELECT max(id) FROM checks),
                    nickname_in_peer,
                    status,
                    check_time);
        END IF;
    ELSE
        INSERT INTO p2p
        VALUES ((SELECT max(id) FROM p2p) + 1,
                (SELECT "Check"
                 FROM p2p
                          JOIN checks ON p2p."Check" = checks.id
                 WHERE p2p.checkingpeer = nickname_in_peer
                   AND checks.task = task_name),
                nickname_in_peer,
                status,
                check_time);
    END IF;
END;
$$;

-- TODO: Добавить еще процедур, для проверки.
-- Success
CALL add_peer_review('deltajed', 'mikeleil', 'C6_s21_matrix', 'Start', '12:00:00');
CALL add_peer_review('deltajed', 'mikeleil', 'C6_s21_matrix', 'Success', '13:00:00');

-- Fail::Error
-- CALL add_peer_review('deltajed', 'mikeleil', 'C6_s21_matrix', 'Start', '12:00:00');


-- 2) Write a procedure for adding checking by Verter
-- Parameters: nickname of the person being checked, task name, Verter check status, time.
-- Add a record to the Verter table (as a check specify the check of the corresponding task with the latest (by time) successful P2P step)

DROP PROCEDURE IF EXISTS add_verter_review CASCADE;

CREATE OR REPLACE PROCEDURE add_verter_review(
    IN nickname_check_peer VARCHAR,
    IN task_name VARCHAR,
    IN status check_status,
    IN check_time TIME
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (status = 'Start') THEN
        IF ((SELECT max(p2p.time)
             FROM p2p
                      JOIN checks ON p2p."Check" = checks.id
             WHERE checks.peer = nickname_check_peer
               AND checks.task = task_name
               AND p2p.state = 'Success') IS NOT NULL) THEN
            INSERT INTO verter
            VALUES ((SELECT max(id) FROM verter) + 1,
                    (SELECT DISTINCT checks.id
                     FROM p2p
                              JOIN checks ON p2p."Check" = checks.id
                     WHERE checks.peer = nickname_check_peer
                       AND checks.task = task_name
                       AND p2p.state = 'Success'),
                    status,
                    check_time);
        ELSE
            RAISE EXCEPTION 'Error: P2P check for the task is not completed or has a `Failure` status';
        END IF;
    ELSE
        INSERT INTO verter
        VALUES ((SELECT max(id) FROM verter) + 1,
                (SELECT "Check"
                 FROM verter
                 GROUP BY "Check"
                 HAVING count(*) % 2 = 1), status, check_time);
    END IF;
END;
$$;

-- TODO: Добавить еще процедур, для проверки.
-- Success
CALL add_verter_review('deltajed', 'C6_s21_matrix', 'Start', '22:00:00');

-- Fail::Error
CALL add_verter_review('deltajed', 'CPP3_SmartCalc_v2.0', 'Start', '22:00:00');