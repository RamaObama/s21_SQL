-- Удаляем таблицы
DROP TABLE IF EXISTS Peers CASCADE;
DROP TABLE IF EXISTS Tasks CASCADE;
DROP TYPE IF EXISTS Check_status CASCADE;
DROP TABLE IF EXISTS P2P CASCADE;
DROP TABLE IF EXISTS Verter CASCADE;
DROP TABLE IF EXISTS Checks CASCADE;
DROP TABLE IF EXISTS TransferredPoints CASCADE;
DROP TABLE IF EXISTS Friends CASCADE;
DROP TABLE IF EXISTS Recommendations CASCADE;
DROP TABLE IF EXISTS XP CASCADE;
DROP TABLE IF EXISTS TimeTracking CASCADE;

-- Создание таблицы Peers
CREATE TABLE IF NOT EXISTS Peers
(
    Nickname VARCHAR PRIMARY KEY NOT NULL,
    Birthday DATE                NOT NULL
);

-- Создание таблицы Tasks
CREATE TABLE IF NOT EXISTS Tasks
(
    Title      TEXT   NOT NULL PRIMARY KEY,
    ParentTask TEXT,
    MaxXP      BIGINT NOT NULL,
    FOREIGN KEY (ParentTask) REFERENCES Tasks (Title)
);

-- Создание перечисления "статус проверки"
CREATE TYPE check_status AS ENUM ('Start', 'Success', 'Failure');

-- Создание таблицы P2P
CREATE TABLE P2P
(
    ID           BIGINT PRIMARY KEY NOT NULL,
    "Check"      BIGINT             NOT NULL,
    CheckingPeer VARCHAR            NOT NULL,
    State        check_status       NOT NULL,
    Time         TIME               NOT NULL,
    FOREIGN KEY ("Check") REFERENCES Checks (ID),
    FOREIGN KEY (CheckingPeer) REFERENCES Peers (Nickname)
);

-- Создание таблицы Verter
CREATE TABLE Verter
(
    ID      BIGINT PRIMARY KEY NOT NULL,
    "Check" BIGINT             NOT NULL,
    State   check_status       NOT NULL,
    Time    TIME               NOT NULL,
    FOREIGN KEY ("Check") REFERENCES Checks (ID)
);

-- Создание таблицы Checks
CREATE TABLE Checks
(
    ID   BIGINT PRIMARY KEY NOT NULL,
    Peer VARCHAR            NOT NULL,
    Task TEXT               NOT NULL,
    Date DATE               NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname),
    FOREIGN KEY (Task) REFERENCES Tasks (Title)
);

-- Создание таблицы TransferredPoints
CREATE TABLE TransferredPoints
(
    ID           BIGINT PRIMARY KEY NOT NULL,
    CheckingPeer VARCHAR            NOT NULL,
    CheckedPeer  VARCHAR            NOT NULL,
    PointsAmount BIGINT             NOT NULL,
    FOREIGN KEY (CheckingPeer) REFERENCES Peers (Nickname),
    FOREIGN KEY (CheckedPeer) REFERENCES Peers (Nickname)
);

-- Создание таблицы Friends
CREATE TABLE Friends
(
    ID    BIGINT PRIMARY KEY NOT NULL,
    Peer1 VARCHAR            NOT NULL,
    Peer2 VARCHAR            NOT NULL,
    FOREIGN KEY (Peer1) REFERENCES Peers (Nickname),
    FOREIGN KEY (Peer2) REFERENCES Peers (Nickname)
);

-- Создание таблицы Recommendations
CREATE TABLE Recommendations
(
    ID              BIGINT PRIMARY KEY NOT NULL,
    Peer            VARCHAR            NOT NULL,
    RecommendedPeer VARCHAR            NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname),
    FOREIGN KEY (RecommendedPeer) REFERENCES Peers (Nickname)
);

-- Создание таблицы XP
CREATE TABLE XP
(
    ID       BIGINT PRIMARY KEY NOT NULL,
    "Check"  BIGINT             NOT NULL,
    XPAmount BIGINT             NOT NULL,
    FOREIGN KEY ("Check") REFERENCES Checks (ID)
);

-- Создание таблицы TimeTracking
CREATE TABLE TimeTracking
(
    ID    BIGINT PRIMARY KEY NOT NULL,
    Peer  VARCHAR            NOT NULL,
    Date  DATE               NOT NULL,
    Time  TIME               NOT NULL,
    State BIGINT             NOT NULL CHECK (State IN (1, 2)),
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname)
);

/* -------------------------- FUNCTION --------------------------- */
-- Функция для перевода ников к нижнему регистру
CREATE OR REPLACE FUNCTION set_lowercase_nickname()
    RETURNS TRIGGER AS
$$
BEGIN
    new.nickname := lower(new.nickname);
    RETURN new;
END;
$$ LANGUAGE plpgsql;

--

CREATE OR REPLACE FUNCTION set_in_transferred_points()
    RETURNS TRIGGER AS
$$
DECLARE
    peer VARCHAR;
BEGIN
    IF ((SELECT count(*) FROM Peers) > 1) THEN
        FOR peer IN (SELECT Nickname FROM Peers)
            LOOP
                peer := replace(peer, '(', '');
                peer := replace(peer, ')', '');
                IF (peer != new.Nickname AND (SELECT count(*)
                                              FROM TransferredPoints
                                              WHERE peer = CheckedPeer) = 0) THEN
                    INSERT INTO TransferredPoints
                    VALUES (coalesce((SELECT max(ID) FROM TransferredPoints), 0) + 1, peer, new.Nickname, 0);
                    INSERT INTO TransferredPoints
                    VALUES ((SELECT max(ID) FROM TransferredPoints) + 1, new.Nickname, peer, 0);
                END IF;
            END LOOP;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/* -------------------------- TRIGGER ---------------------------- */
-- Триггер для срабатывания set_lowercase_nickname
CREATE TRIGGER trg_set_lowercase_nickname
    BEFORE INSERT OR UPDATE
    ON Peers
    FOR EACH ROW
EXECUTE PROCEDURE set_lowercase_nickname();

CREATE TRIGGER trg_set_in_transferred_points
    AFTER INSERT
    ON Peers
    FOR EACH ROW
EXECUTE FUNCTION set_in_transferred_points();

/* ---------------------------- DROP ----------------------------- */
-- set_lowercase_nickname
DROP FUNCTION IF EXISTS set_lowercase_nickname() CASCADE;
DROP TRIGGER IF EXISTS trg_set_lowercase_nickname ON Peers CASCADE;

DROP FUNCTION IF EXISTS set_in_transferred_points() CASCADE;
DROP TRIGGER IF EXISTS trg_set_in_transferred_points ON Peers CASCADE;


/* ---------------------------- INSERT ----------------------------- */
-- Добавление значений в таблицу Peers
INSERT INTO Peers (Nickname, Birthday)
VALUES ('deltajed', '1994-01-24'),
       ('katharyn', '1997-06-30'),
       ('katherib', '1996-11-05'),
       ('omarvarl', '1993-04-03'),
       ('mikeleil', '1996-01-01'),
       ('gellerti', '1996-01-02'),
       ('uleecame', '1996-01-03'),
       ('fernando', '1996-01-04'),
       ('astraeus', '1996-01-05'),
       ('aphrodit', '1996-01-06');

-- Добавление значений в таблицу Tasks
INSERT INTO Tasks (Title, ParentTask, MaxXP)
VALUES ('C2_SimpleBashUtils', NULL, 250),
       ('C3_s21_string+', 'C2_SimpleBashUtils', 500),
       ('C4_s21_math', 'C2_SimpleBashUtils', 300),
       ('C5_s21_decimal', 'C4_s21_math', 350),
       ('C6_s21_matrix', 'C5_s21_decimal', 200),
       ('C7_SmartCalc_v1.0', 'C6_s21_matrix', 500),
       ('C8_3DViewer_v1.0', 'C7_SmartCalc_v1.0', 750),
       ('DO1_Linux', 'C3_s21_string+', 300),
       ('DO2_Linux_Network', 'DO1_Linux', 250),
       ('DO3_LinuxMonitoring_v1.0', 'DO2_Linux_Network', 350),
       ('DO4_LinuxMonitoring_v2.0', 'DO3_LinuxMonitoring_v1.0', 350),
       ('DO5_SimpleDocker', 'DO3_LinuxMonitoring_v1.0', 300),
       ('DO6_CICD', 'DO5_SimpleDocker', 300),
       ('CPP1_s21_matrix+', 'C8_3DViewer_v1.0', 300),
       ('CPP2_s21_containers', 'CPP1_s21_matrix+', 350),
       ('CPP3_SmartCalc_v2.0', 'CPP2_s21_containers', 600),
       ('CPP4_3DViewer_v2.0', 'CPP3_SmartCalc_v2.0', 750),
       ('CPP5_3DViewer_v2.1', 'CPP4_3DViewer_v2.0', 600),
       ('CPP6_3DViewer_v2.2', 'CPP4_3DViewer_v2.0', 800),
       ('CPP7_MLP', 'CPP4_3DViewer_v2.0', 700),
       ('CPP8_PhotoLab_v1.0', 'CPP4_3DViewer_v2.0', 450),
       ('CPP9_MonitoringSystem', 'CPP4_3DViewer_v2.0', 1000),
       ('A1_Maze', 'CPP4_3DViewer_v2.0', 300),
       ('A2_SimpleNavigator_v1.0', 'A1_Maze', 400),
       ('A3_Parallels', 'A2_SimpleNavigator_v1.0', 300),
       ('A4_Crypto', 'A2_SimpleNavigator_v1.0', 350),
       ('A5_s21_memory', 'A2_SimpleNavigator_v1.0', 400),
       ('A6_Transactions', 'A2_SimpleNavigator_v1.0', 700),
       ('A7_DNA_Analyzer', 'A2_SimpleNavigator_v1.0', 800),
       ('A8_Algorithmic_trading', 'A2_SimpleNavigator_v1.0', 800),
       ('SQL1_Bootcamp', 'C8_3DViewer_v1.0', 1500),
       ('SQL2_Info21_v1.0', 'SQL1_Bootcamp', 500),
       ('SQL3_RetailAnalitycs_v1.0', 'SQL2_Info21_v1.0', 600);

-- Добавление значений в таблицу Checks Часть 2
INSERT INTO Checks (ID, Peer, Task, Date)
VALUES (1, 'deltajed', 'C2_SimpleBashUtils', '2022-06-28'),
       (2, 'deltajed', 'C3_s21_string+', '2022-05-25'),
       (3, 'deltajed', 'C4_s21_math', '2022-06-14'),
       (4, 'deltajed', 'C5_s21_decimal', '2022-08-21'),
       (5, 'deltajed', 'C6_s21_matrix', '2023-03-03'),
       (6, 'deltajed', 'DO1_Linux', '2023-03-06'),
       (7, 'deltajed', 'C7_SmartCalc_v1.0', '2023-03-20'),
       (8, 'deltajed', 'C8_3DViewer_v1.0', '2023-03-21'),
       (9, 'deltajed', 'DO2_Linux_Network', '2023-03-27'),
       (10, 'deltajed', 'SQL1_Bootcamp', '2023-04-10'),
       (11, 'deltajed', 'DO3_LinuxMonitoring_v1.0', '2023-04-12'),
       (12, 'mikeleil', 'C2_SimpleBashUtils', '2022-06-12'),
       (13, 'mikeleil', 'C3_s21_string+', '2022-06-15'),
       (14, 'mikeleil', 'C4_s21_math', '2022-08-02'),
       (15, 'mikeleil', 'C5_s21_decimal', '2022-07-23'),
       (16, 'mikeleil', 'C6_s21_matrix', '2022-10-01'),
       (17, 'mikeleil', 'DO1_Linux', '2022-06-17'),
       (18, 'mikeleil', 'C7_SmartCalc_v1.0', '2023-03-03'),
       (19, 'mikeleil', 'C8_3DViewer_v1.0', '2023-03-21'),
       (20, 'mikeleil', 'DO2_Linux_Network', '2022-09-25'),
       (21, 'mikeleil', 'DO3_LinuxMonitoring_v1.0', '2022-11-28'),
       (22, 'mikeleil', 'DO5_SimpleDocker', '2022-12-16'),
       (23, 'mikeleil', 'DO6_CICD', '2022-12-21'),
       (24, 'mikeleil', 'SQL1_Bootcamp', '2023-04-10');