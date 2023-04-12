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