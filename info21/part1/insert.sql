-----------------------------------------
-- Добавление значений в таблицу Peers --
-----------------------------------------
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

-----------------------------------------
-- Добавление значений в таблицу Tasks --
-----------------------------------------
INSERT INTO Tasks (Title, ParentTask, MaxXP)
VALUES ('C2_SimpleBashUtils', NULL, 250),
       ('C3_s21_string+', 'C2_SimpleBashUtils', 500),
       ('C4_s21_math', 'C2_SimpleBashUtils', 300),
       ('C5_s21_decimal', 'C4_s21_math', 350),
       ('C6_s21_matrix', 'C5_s21_decimal', 200),
       ('C7_SmartCalc_v1.0', 'C6_s21_matrix', 500),
       ('C8_3DViewer_v1.0', 'C7_SmartCalc_v1.0', 750),
       ('DO1_Linux', 'C3_s21_string+', 300),
       ('DO2_Linux Network', 'DO1_Linux', 250),
       ('DO3_LinuxMonitoring v1.0', 'DO2_Linux Network', 350),
       ('DO4_LinuxMonitoring v2.0', 'DO3_LinuxMonitoring v1.0', 350),
       ('DO5_SimpleDocker', 'DO3_LinuxMonitoring v1.0', 300),
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
       ('SQL1_Bootcamp', 'C8_3DViewer_v1.0', 1500),
       ('SQL2_Info21 v1.0', 'SQL1_Bootcamp', 500),
       ('SQL3_RetailAnalitycs v1.0', 'SQL2_Info21 v1.0', 600),
       ('A1_Maze', 'CPP4_3DViewer_v2.0', 300),
       ('A2_SimpleNavigator v1.0', 'A1_Maze', 400),
       ('A3_Parallels', 'A2_SimpleNavigator v1.0', 300),
       ('A4_Crypto', 'A2_SimpleNavigator v1.0', 350),
       ('A5_s21_memory', 'A2_SimpleNavigator v1.0', 400),
       ('A6_Transactions', 'A2_SimpleNavigator v1.0', 700),
       ('A7_DNA Analyzer', 'A2_SimpleNavigator v1.0', 800),
       ('A8_Algorithmic trading', 'A2_SimpleNavigator v1.0', 800);

------------------------------------------
-- Добавление значений в таблицу Checks --
------------------------------------------
INSERT INTO Checks (ID, Peer, Task, Date)
VALUES (1, 'deltajed', 'C2_SimpleBashUtils', '2022-12-07'),
       (2, 'katharyn', 'C2_SimpleBashUtils', '2022-12-28'),
       (3, 'mikeleil', 'C3_s21_string+', '2023-01-02'),
       (4, 'gellerti', 'C3_s21_string+', '2023-01-03'),
       (5, 'mikeleil', 'DO1_Linux', '2023-01-07'),
       (6, 'deltajed', 'C3_s21_string+', '2023-01-12'),
       (7, 'katharyn', 'DO1_Linux', '2023-01-12'),
       (8, 'gellerti', 'DO1_Linux', '2023-01-12'),
       (9, 'astraeus', 'DO2_Linux Network', '2023-02-04'),
       (10, 'katharyn', 'DO2_Linux Network', '2023-02-12'),
       (11, 'astraeus', 'C6_s21_matrix', '2023-02-15'),
       (12, 'deltajed', 'C4_s21_math', '2023-02-18'),
       (13, 'mikeleil', 'DO2_Linux Network', '2023-02-21'),
       (14, 'gellerti', 'DO2_Linux Network', '2023-02-21'),
       (15, 'katharyn', 'DO3_LinuxMonitoring v1.0', '2023-02-21'),
       (16, 'mikeleil', 'DO3_LinuxMonitoring v1.0', '2023-02-25'),
       (17, 'deltajed', 'C5_s21_decimal', '2023-03-02'),
       (18, 'mikeleil', 'DO4_LinuxMonitoring v2.0', '2023-03-07'),
       (19, 'katharyn', 'DO4_LinuxMonitoring v2.0', '2023-03-07'),
       (20, 'gellerti', 'C4_s21_math', '2023-03-07'),
       (21, 'astraeus', 'C7_SmartCalc_v1.0', '2023-04-01'),
       (22, 'deltajed', 'C6_s21_matrix', '2023-04-03'),
       (23, 'mikeleil', 'DO5_SimpleDocker', '2023-04-10'),
       (24, 'mikeleil', 'DO6_CICD', '2023-04-15'),
       (25, 'deltajed', 'C7_SmartCalc_v1.0', '2023-05-06'),
       (26, 'deltajed', 'C8_3DViewer_v1.0', '2023-06-01');

---------------------------------------
-- Добавление значений в таблицу P2P --
---------------------------------------
INSERT INTO P2P (id, "Check", CheckingPeer, State, Time)
VALUES (1, 1, 'mikeleil', 'Start', '07:00:00'),
       (2, 1, 'mikeleil', 'Success', '07:11:00'),
       (3, 2, 'deltajed', 'Start', '14:01:00'),
       (4, 2, 'deltajed', 'Success', '14:28:00'),
       (5, 3, 'deltajed', 'Start', '18:00:00'),
       (6, 3, 'deltajed', 'Failure', '18:14:00'),
       (7, 4, 'astraeus', 'Start', '12:17:00'),
       (8, 4, 'astraeus', 'Success', '12:49:00'),
       (9, 5, 'katharyn', 'Start', '13:02:00'),
       (10, 5, 'katharyn', 'Success', '13:13:00'),
       (11, 6, 'astraeus', 'Start', '09:00:00'),
       (12, 6, 'astraeus', 'Success', '09:29:00'),
       (13, 7, 'gellerti', 'Start', '15:45:00'),
       (14, 7, 'gellerti', 'Success', '15:58:00'),
       (15, 8, 'katharyn', 'Start', '17:08:00'),
       (16, 8, 'katharyn', 'Success', '17:38:00'),
       (17, 9, 'mikeleil', 'Start', '14:31:00'),
       (18, 9, 'mikeleil', 'Success', '14:53:00'),
       (19, 10, 'mikeleil', 'Start', '17:12:00'),
       (20, 10, 'mikeleil', 'Success', '17:39:00'),
       (21, 11, 'gellerti', 'Start', '21:17:00'),
       (22, 11, 'gellerti', 'Success', '21:29:00'),
       (23, 12, 'astraeus', 'Start', '20:17:00'),
       (24, 12, 'astraeus', 'Success', '20:34:00'),
       (25, 13, 'astraeus', 'Start', '11:02:00'),
       (26, 13, 'astraeus', 'Success', '11:13:00'),
       (27, 14, 'deltajed', 'Start', '18:12:00'),
       (28, 14, 'deltajed', 'Success', '18:32:00'),
       (29, 15, 'mikeleil', 'Start', '15:00:00'),
       (30, 15, 'mikeleil', 'Success', '15:21:00'),
       (31, 16, 'katharyn', 'Start', '07:00:00'),
       (32, 16, 'katharyn', 'Success', '07:11:00'),
       (33, 17, 'gellerti', 'Start', '16:17:00'),
       (34, 17, 'gellerti', 'Success', '16:49:00'),
       (35, 18, 'astraeus', 'Start', '13:15:00'),
       (36, 18, 'astraeus', 'Success', '13:48:00'),
       (37, 19, 'mikeleil', 'Start', '10:15:00'),
       (38, 19, 'mikeleil', 'Success', '10:36:00'),
       (39, 20, 'astraeus', 'Start', '18:00:00'),
       (40, 20, 'astraeus', 'Failure', '18:14:00'),
       (41, 21, 'deltajed', 'Start', '13:02:00'),
       (42, 21, 'deltajed', 'Success', '13:13:00'),
       (43, 22, 'gellerti', 'Start', '12:47:00'),
       (44, 22, 'gellerti', 'Success', '13:16:00'),
       (45, 23, 'katharyn', 'Start', '15:42:00'),
       (46, 23, 'katharyn', 'Success', '16:22:00'),
       (47, 24, 'astraeus', 'Start', '18:21:00'),
       (48, 24, 'astraeus', 'Success', '19:11:00'),
       (49, 25, 'mikeleil', 'Start', '09:17:00'),
       (50, 25, 'mikeleil', 'Success', '10:09:00'),
       (51, 26, 'gellerti', 'Start', '22:08:00'),
       (52, 26, 'gellerti', 'Success', '23:03:00');

------------------------------------------
-- Добавление значений в таблицу Verter --
------------------------------------------
INSERT INTO Verter (id, "Check", State, Time)
VALUES (1, 1, 'Start', '07:12:00'),
       (2, 1, 'Success', '07:13:00'),
       (3, 2, 'Start', '14:29:00'),
       (4, 2, 'Failure', '14:30:00'),
       (5, 4, 'Start', '12:50:00'),
       (6, 4, 'Success', '12:51:00'),
       (7, 6, 'Start', '09:30:00'),
       (8, 6, 'Success', '09:31:00'),
       (9, 11, 'Start', '21:30:00'),
       (10, 11, 'Failure', '21:31:00'),
       (11, 12, 'Start', '20:35:00'),
       (12, 12, 'Success', '20:36:00'),
       (13, 17, 'Start', '16:50:00'),
       (14, 17, 'Success', '16:51:00'),
       (15, 22, 'Start', '13:17:00'),
       (16, 22, 'Success', '13:18:00');

-------------------------------------------
-- Добавление значений в таблицу Friends --
-------------------------------------------
INSERT INTO Friends (id, Peer1, Peer2)
VALUES (1, 'deltajed', 'katharyn'),
       (2, 'deltajed', 'katherib'),
       (3, 'deltajed', 'omarvarl'),
       (4, 'deltajed', 'mikeleil'),
       (5, 'deltajed', 'gellerti'),
       (6, 'deltajed', 'uleecame'),
       (7, 'deltajed', 'fernando'),
       (8, 'deltajed', 'astraeus'),
       (9, 'deltajed', 'aphrodit'),
       (10, 'katharyn', 'katherib'),
       (11, 'katharyn', 'omarvarl'),
       (12, 'katharyn', 'mikeleil'),
       (13, 'katharyn', 'gellerti'),
       (14, 'katharyn', 'uleecame'),
       (15, 'katharyn', 'fernando'),
       (16, 'katharyn', 'astraeus'),
       (17, 'katharyn', 'aphrodit'),
       (18, 'katherib', 'omarvarl'),
       (19, 'katherib', 'mikeleil'),
       (20, 'katherib', 'gellerti'),
       (21, 'katherib', 'uleecame'),
       (22, 'katherib', 'fernando'),
       (23, 'katherib', 'astraeus'),
       (24, 'katherib', 'aphrodit'),
       (25, 'omarvarl', 'mikeleil'),
       (26, 'omarvarl', 'gellerti'),
       (27, 'omarvarl', 'uleecame'),
       (28, 'omarvarl', 'fernando'),
       (29, 'omarvarl', 'astraeus'),
       (30, 'omarvarl', 'aphrodit'),
       (31, 'mikeleil', 'gellerti'),
       (32, 'mikeleil', 'uleecame'),
       (33, 'mikeleil', 'fernando'),
       (34, 'mikeleil', 'astraeus'),
       (35, 'mikeleil', 'aphrodit'),
       (36, 'gellerti', 'uleecame'),
       (37, 'gellerti', 'fernando'),
       (38, 'gellerti', 'astraeus'),
       (39, 'gellerti', 'aphrodit'),
       (40, 'uleecame', 'fernando'),
       (41, 'uleecame', 'astraeus'),
       (42, 'uleecame', 'aphrodit'),
       (43, 'fernando', 'astraeus'),
       (44, 'fernando', 'aphrodit'),
       (45, 'astraeus', 'aphrodit');

---------------------------------------------------
-- Добавление значений в таблицу Recommendations --
---------------------------------------------------
INSERT INTO Recommendations (id, Peer, RecommendedPeer)
VALUES (1, 'deltajed', 'katharyn'),
       (2, 'deltajed', 'katherib'),
       (3, 'deltajed', 'omarvarl'),
       (4, 'deltajed', 'mikeleil'),
       (5, 'deltajed', 'gellerti'),
       (6, 'deltajed', 'uleecame'),
       (7, 'deltajed', 'fernando'),
       (8, 'deltajed', 'astraeus'),
       (9, 'deltajed', 'aphrodit'),
       (10, 'katharyn', 'uleecame'),
       (11, 'katharyn', 'fernando'),
       (12, 'katharyn', 'astraeus'),
       (13, 'katherib', 'omarvarl'),
       (14, 'katherib', 'mikeleil'),
       (15, 'katherib', 'aphrodit'),
       (16, 'omarvarl', 'mikeleil'),
       (17, 'omarvarl', 'aphrodit'),
       (18, 'mikeleil', 'gellerti'),
       (19, 'mikeleil', 'aphrodit'),
       (20, 'gellerti', 'uleecame'),
       (21, 'gellerti', 'aphrodit'),
       (22, 'uleecame', 'fernando'),
       (23, 'fernando', 'astraeus'),
       (24, 'fernando', 'aphrodit'),
       (25, 'astraeus', 'aphrodit');

------------------------------------------------
-- Добавление значений в таблицу TimeTracking --
------------------------------------------------
INSERT INTO TimeTracking (id, Peer, Date, Time, State)
VALUES (1, 'deltajed', '2023-04-12', '13:11', 1),
       (2, 'deltajed', '2023-04-12', '13:44', 2),
       (3, 'deltajed', '2023-04-12', '15:14', 1),
       (4, 'deltajed', '2023-04-12', '19:10', 2),
       (5, 'mikeleil', '2023-01-01', '10:00', 1),
       (6, 'mikeleil', '2023-01-01', '20:00', 2);

-----------------------------------------------------
-- Добавление значений в таблицу TransferredPoints --
-----------------------------------------------------

--------------------------------------
-- Добавление значений в таблицу XP --
--------------------------------------
INSERT INTO XP (id, "Check", xpamount)
VALUES (1, 1, 250),
       (2, 4, 400),
       (3, 5, 300),
       (4, 6, 450),
       (5, 7, 270),
       (6, 8, 285),
       (7, 9, 250),
       (8, 10, 240),
       (9, 12, 300),
       (10, 13, 250),
       (11, 14, 250),
       (12, 15, 300),
       (13, 16, 350),
       (14, 17, 330),
       (15, 18, 340),
       (16, 19, 350),
       (17, 21, 500),
       (18, 22, 200),
       (19, 23, 280),
       (20, 24, 300),
       (21, 25, 500),
       (22, 26, 700);