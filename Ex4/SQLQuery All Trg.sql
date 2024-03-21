--Триггеры для Address

CREATE TRIGGER [dbo].[trg_InsertUniqueStreet]
ON [dbo].[Address]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Проверяем, существует ли уже такая улица в таблице Address
    IF EXISTS (
        SELECT 1
        FROM [Address] a
        INNER JOIN inserted i ON a.Street = i.Street
        WHERE a.Address_ID <> i.Address_ID
    )
    BEGIN
        RAISERROR ('Улица должна быть уникальной.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


--Триггеры для Clients

CREATE TRIGGER [dbo].[trg_DeleteClientCascade]
ON [dbo].[Clients]
AFTER DELETE
AS
BEGIN
	 -- Проверяем наличие клиента в другой таблице, которая может нарушить ограничения
    IF EXISTS(SELECT * FROM Clients_in_Gym WHERE Client_ID IN (SELECT Client_ID FROM deleted))
    BEGIN
    -- Если клиент все еще находится в Clients_in_Gym, вызываем ошибку
	RAISERROR ('Невозможно удалить клиента, так как он все еще зарегистрирован в зале.', 16, 1);
	RETURN;
    END

    DELETE FROM Clients_in_Gym WHERE Client_ID IN (SELECT Client_ID FROM deleted);
END;


CREATE TRIGGER [dbo].[trg_InsertClientCheckAge]
ON [dbo].[Clients]
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE DATEDIFF(year, Date_of_Birth, GETDATE()) < 18)
    BEGIN
        RAISERROR ('Клиент должен быть старше 18 лет.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_UpdateUniquePhone]
ON [dbo].[Clients]

AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Проверяем, существует ли уже номер телефона в таблице Clients
    IF EXISTS (
        SELECT 1
        FROM Clients c
        INNER JOIN inserted i ON c.Contact_Phone = i.Contact_Phone
        WHERE c.Client_ID <> i.Client_ID
    )
    BEGIN
        RAISERROR ('Номер телефона должен быть уникальным.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


--Триггеры для Gyms

CREATE TRIGGER [dbo].[trg_DeleteGymCascadeSchedules]
ON [dbo].[Gyms]
AFTER DELETE
AS
BEGIN
	-- Проверяем, есть ли занятия в расписании, которые уже используются клиентами
    IF EXISTS(SELECT * FROM Client_Schedule WHERE Schedule_ID IN (SELECT Schedule_ID FROM Schedules WHERE Gym_ID IN (SELECT Gym_ID FROM deleted)))
    BEGIN
        -- Если такие занятия есть, вызываем ошибку
        RAISERROR ('Невозможно удалить зал, так как расписание уже используется клиентами.', 16, 1);
        RETURN;
    END
    -- Если занятий, используемых клиентами, нет, удаляем записи из таблицы Schedules
    DELETE FROM Schedules WHERE Gym_ID IN (SELECT Gym_ID FROM deleted);
END;


CREATE TRIGGER [dbo].[trg_InsertGymCheckAddressExists]
ON [dbo].[Gyms]
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM inserted i JOIN Address a ON i.Address_ID = a.Address_ID)
    BEGIN
        RAISERROR ('Адрес для зала должен существовать в таблице Address.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_InsertGymCheckArea]
ON [dbo].[Gyms]
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Area < 50.0)
    BEGIN
        RAISERROR ('Площадь зала должна быть не менее 50 кв. м.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_UpdateGymAddress]
ON [dbo].[Gyms]
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @GymID int, @NewAddressID int;
    SELECT @GymID = Gym_ID, @NewAddressID = Address_ID FROM inserted;

	 -- Проверка существования нового Address_ID
    IF NOT EXISTS (SELECT * FROM Address WHERE Address_ID = @NewAddressID)
    BEGIN
        RAISERROR ('Новый адрес не найден в таблице адресов.', 16, 1);
        RETURN;
    END

    UPDATE Clients_in_Gym
    SET Address_ID = @NewAddressID
    WHERE Gym_ID = @GymID;

    UPDATE Gyms
    SET Name = inserted.Name,
        Area = inserted.Area,
        Address_ID = inserted.Address_ID,
        Contact_Phone = inserted.Contact_Phone
    FROM inserted
    WHERE Gyms.Gym_ID = inserted.Gym_ID;
END;


--Триггеры для Shedules

CREATE TRIGGER [dbo].[trg_DeleteScheduleCascadeClientSchedule]
ON [dbo].[Schedules]
AFTER DELETE
AS
BEGIN
	-- Проверка, не зарегистрированы ли клиенты на удаленное расписание
    IF EXISTS(SELECT * FROM Client_Schedule WHERE Schedule_ID IN (SELECT Schedule_ID FROM deleted))
    BEGIN
        -- Если клиенты все еще зарегистрированы на расписание, вызываем ошибку
        RAISERROR ('Невозможно удалить расписание, так как на него зарегистрированы клиенты.', 16, 1);
        RETURN;
    END
	
    DELETE FROM Client_Schedule WHERE Schedule_ID IN (SELECT Schedule_ID FROM deleted);
END;


CREATE TRIGGER [dbo].[trg_InsertScheduleCheckTimeOverlap]
ON [dbo].[Schedules]
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT * FROM inserted i
        JOIN Schedules s ON i.Gym_ID = s.Gym_ID AND i.Day_of_Week = s.Day_of_Week
        WHERE (i.Start_Time < s.End_Time AND i.End_Time > s.Start_Time)
    )
    BEGIN
        RAISERROR ('Время занятий в расписании не должно пересекаться.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_UpdateScheduleSportID]
ON [dbo].[Schedules]
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE NOT EXISTS (SELECT * FROM Sports WHERE Sport_ID = inserted.Sport_ID))
    BEGIN
        RAISERROR ('Изменяемый ID спорта должен существовать в таблице Sports.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_UpdateTrainerLoadOnScheduleChange]
ON [dbo].[Schedules]
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @OldScheduleID int, @NewScheduleID int, @GymID int, @Start_Time time, @End_Time time, @Day_of_Week varchar(64);

    SELECT @OldScheduleID = Schedule_ID FROM deleted;
    SELECT @NewScheduleID = Schedule_ID, @GymID = Gym_ID, @Start_Time = Start_Time, @End_Time = End_Time, @Day_of_Week = Day_of_Week FROM inserted;

    -- Проверка, что время начала занятий не позднее времени окончания
    IF @Start_Time >= @End_Time
    BEGIN
        RAISERROR ('Время начала занятий должно быть раньше времени окончания.', 16, 1);
        RETURN;
    END

    UPDATE Trainer_Load
    SET Schedule_ID = @NewScheduleID
    WHERE Schedule_ID = @OldScheduleID;

    UPDATE Schedules
    SET Gym_ID = inserted.Gym_ID,
        Sport_ID = inserted.Sport_ID,
        Day_of_Week = inserted.Day_of_Week,
        Start_Time = inserted.Start_Time,
        End_Time = inserted.End_Time
    FROM inserted
    WHERE Schedules.Schedule_ID = @OldScheduleID;
END;


--Триггеры для Sports

CREATE TRIGGER [dbo].[trg_DeleteSportPreventIfUsed]
ON [dbo].[Sports]
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM deleted JOIN Schedules ON Schedules.Sport_ID = deleted.Sport_ID)
    BEGIN
        RAISERROR ('Нельзя удалить вид спорта, который используется в расписании.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Sports WHERE Sport_ID IN (SELECT Sport_ID FROM deleted);
    END
END;


--Триггеры для Trainers

CREATE TRIGGER [dbo].[trg_DeleteTrainerCascadeReports]
ON [dbo].[Trainers]
AFTER DELETE
AS
BEGIN
	-- Проверка, есть ли отчеты, связанные с удаляемыми тренерами
    IF EXISTS(SELECT * FROM Trainer_Report WHERE Trainer_ID IN (SELECT Trainer_ID FROM deleted))
    BEGIN
        -- Если отчеты существуют, вызываем ошибку
        RAISERROR ('Невозможно удалить тренера, так как существуют связанные отчеты.', 16, 1);
        RETURN;
    END

    DELETE FROM Trainer_Report WHERE Trainer_ID IN (SELECT Trainer_ID FROM deleted);
END;


CREATE TRIGGER [dbo].[trg_DeleteTrainerPreventIfScheduled]
ON [dbo].[Trainers]
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM deleted JOIN Trainer_Load ON Trainer_Load.Trainer_ID = deleted.Trainer_ID)
    BEGIN
        RAISERROR ('Нельзя удалить тренера, который назначен на занятия.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Trainers WHERE Trainer_ID IN (SELECT Trainer_ID FROM deleted);
    END
END;


CREATE TRIGGER [dbo].[trg_InsertTrainerCheckExperience]
ON [dbo].[Trainers]
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Experience < 1)
    BEGIN
        RAISERROR ('Опыт работы тренера должен быть не менее 1 года.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_UpdateTrainerExperience]
ON [dbo].[Trainers]
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Experience < 0)
    BEGIN
        RAISERROR ('Опыт работы тренера не может быть отрицательным.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


CREATE TRIGGER [dbo].[trg_UpdateTrainerPhoneUnique]
ON [dbo].[Trainers]
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Trainers t ON t.Trainer_ID != i.Trainer_ID
        WHERE t.Contact_Phone = i.Contact_Phone
    )
    BEGIN
        RAISERROR ('Номер телефона уже используется другим тренером.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


