USE Gyms

-- Найти все тренеров, у которых есть клиенты
SELECT *
FROM Trainers T
WHERE EXISTS (
    SELECT 1
    FROM Clients_in_Gym C
    WHERE C.Client_ID = T.Trainer_ID
);

-- Найти гимнастические залы с определенными ID
SELECT *
FROM Gyms
WHERE Gym_ID IN (1, 2, 3);

-- Поиск тренеров с опытом больше, чем у всех остальных тренеров
SELECT *
FROM Trainers
WHERE Experience > ALL (
    SELECT Experience
    FROM Trainers
    WHERE Trainer_ID <> Trainers.Trainer_ID
);

-- Поиск клиентов, которые занимаются в хотя бы одном из указанных залов
SELECT *
FROM Clients
WHERE Client_ID = ANY (
    SELECT Client_ID
    FROM Clients_in_Gym
    WHERE Gym_ID IN (SELECT Gym_ID FROM Gyms WHERE Name IN ('Зал1', 'Зал2'))
);

-- Найти тренеров с опытом работы между 3 и 7 годами
SELECT *
FROM Trainers
WHERE Experience BETWEEN 3 AND 7;

-- Найти клиентов с фамилией, начинающейся на 'Smi'
SELECT *
FROM Clients
WHERE Last_Name LIKE 'Пет%';














