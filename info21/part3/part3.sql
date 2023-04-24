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

SELECT *
FROM human_readable_points();