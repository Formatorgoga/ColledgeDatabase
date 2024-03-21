USE [Gyms]

SELECT *
FROM Gyms
INNER JOIN Trainers ON Gyms.Gym_ID = Trainers.Address_ID;

SELECT *
FROM Gyms
LEFT JOIN Trainers ON Gyms.Gym_ID = Trainers.Address_ID;

SELECT *
FROM Gyms
RIGHT JOIN Trainers ON Gyms.Gym_ID = Trainers.Address_ID;

SELECT *
FROM Gyms
FULL JOIN Trainers ON Gyms.Gym_ID = Trainers.Address_ID;

SELECT *
FROM Gyms
CROSS JOIN Trainers;

SELECT *
FROM Schedules
CROSS APPLY (
    SELECT *
    FROM Trainer_Load
    WHERE Schedules.Schedule_ID = Trainer_Load.Schedule_ID
) AS LoadDetails;

GO



