CREATE PROCEDURE [dbo].[AddNewClient]
    @First_Name varchar(128),
    @Last_Name varchar(128),
    @Date_Of_Birth date,
    @Gender varchar(10),
    @Contact_Phone varchar(64),
    @Health varchar(128),
	@Middle_Name varchar(128)
AS
	--ƒобавление нового клиента в базу данных
BEGIN
    INSERT INTO [dbo].[Clients] (First_Name, Last_Name, Date_of_Birth, Gender, Contact_Phone, Health, Middle_Name)
    VALUES (@First_Name, @Last_Name, @Date_Of_Birth, @Gender, @Contact_Phone, @Health, @Middle_Name);
END;


CREATE PROCEDURE [dbo].[AddNewTrainer]
    @FirstName varchar(128),
    @LastName varchar(128),
    @Experience int,
    @ContactPhone varchar(128),
    @AddressID int,
    @Passport varchar(128)
AS
	--ƒобавление нового тренера в базу данных

BEGIN
    INSERT INTO Trainers (First_Name, Last_Name, Experience, Contact_Phone, Address_ID, Passport)
    VALUES (@FirstName, @LastName, @Experience, @ContactPhone, @AddressID, @Passport);
END;


CREATE PROCEDURE [dbo].[CancelRegister]
    @ScheduleID int
AS
BEGIN
    -- ”дал¤ем все св¤занные записи из таблицы Trainer_Load
    DELETE FROM Trainer_Load WHERE Schedule_ID = @ScheduleID;

    -- ”дал¤ем все св¤занные записи из таблицы Client_Schedule
    DELETE FROM Client_Schedule WHERE Schedule_ID = @ScheduleID;

    -- “еперь можно безопасно удалить зан¤тие из расписани¤
    DELETE FROM Schedules WHERE Schedule_ID = @ScheduleID;
END;


CREATE PROCEDURE [dbo].[CountTotalClassesByTrainer]
    @TrainerID int,
    @TotalClasses int OUTPUT
AS
	--ѕодсчет общего количества зан¤тий, проведенных тренером
BEGIN
    SELECT @TotalClasses = COUNT(*)
    FROM Trainer_Load
    WHERE Trainer_ID = @TrainerID;
END;


CREATE PROCEDURE [dbo].[RegisterClientToSchedule]
    @ClientID int,
    @ScheduleID int
AS
BEGIN
	--–егистраци¤ клиента на зан¤тие
    -- ѕровер¤ем, не зарегистрирован ли уже клиент на это зан¤тие
    IF NOT EXISTS(SELECT 1 FROM Client_Schedule WHERE Client_ID = @ClientID AND Schedule_ID = @ScheduleID)
    BEGIN
        INSERT INTO Client_Schedule (Client_ID, Schedule_ID)
        VALUES (@ClientID, @ScheduleID);
    END
    ELSE
    BEGIN
        PRINT ' лиент уже зарегистрирован на это зан¤тие.';
    END
END;


ALTER PROCEDURE [dbo].[UpdateTrainerInfo]
    @TrainerID int,
    @Experience int,
    @ContactPhone varchar(128)
AS
	--ќбновление информации о тренере
BEGIN
    UPDATE Trainers
    SET Experience = @Experience, Contact_Phone = @ContactPhone
    WHERE Trainer_ID = @TrainerID;
END;


