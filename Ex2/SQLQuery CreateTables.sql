IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Address')
BEGIN
CREATE TABLE [Address] (
    Address_ID int IDENTITY(1,1) PRIMARY KEY,
    Address_Line1 varchar(128),
    Address_Line2 varchar(128),
    City varchar(50),
    Street varchar(128),
    House varchar(128)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Gyms')
BEGIN
CREATE TABLE Gyms (
    Gym_ID int IDENTITY(1,1) PRIMARY KEY,
    Name varchar(50),
    Area float,
    Address_ID int,
    Contact_Phone varchar(50),
    FOREIGN KEY (Address_ID) REFERENCES Address(Address_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Sports')
BEGIN
CREATE TABLE Sports (
    Sport_ID int IDENTITY(1,1) PRIMARY KEY,
    Name varchar(50),
    Description text
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Trainers')
BEGIN
CREATE TABLE Trainers (
    Trainer_ID int IDENTITY(1,1) PRIMARY KEY,
    First_Name varchar(128),
    Last_Name varchar(128),
    Experience int,
    Contact_Phone varchar(128),
    Address_ID int,
    Passport varchar(128),
    FOREIGN KEY (Address_ID) REFERENCES [Address](Address_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Clients')
BEGIN
CREATE TABLE Clients (
    Client_ID int IDENTITY(1,1) PRIMARY KEY,
    First_Name varchar(128),
    Last_Name varchar(128),
    Date_of_Birth date,
    Gender varchar(10),
    Contact_Phone varchar(64),
    Health varchar(128)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Schedules')
BEGIN
CREATE TABLE Schedules (
    Schedule_ID int IDENTITY(1,1) PRIMARY KEY,
    Gym_ID int,
    Sport_ID int,
    Day_of_Week varchar(64),
    Start_Time time,
    End_Time time,
    FOREIGN KEY (Gym_ID) REFERENCES Gyms(Gym_ID),
    FOREIGN KEY (Sport_ID) REFERENCES Sports(Sport_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Trainer_Load')
BEGIN
CREATE TABLE Trainer_Load (
    Trainer_Load_ID int IDENTITY(1,1) PRIMARY KEY,
    Trainer_ID int,
    Schedule_ID int,
    FOREIGN KEY (Trainer_ID) REFERENCES Trainers(Trainer_ID),
    FOREIGN KEY (Schedule_ID) REFERENCES Schedules(Schedule_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Clients_in_Gym')
BEGIN
CREATE TABLE Clients_in_Gym (
    Clients_in_Gym_ID int IDENTITY(1,1) PRIMARY KEY,
    Client_ID int,
    Gym_ID int,
    Start_Date date,
    End_Date date,
    Address_ID int,
    FOREIGN KEY (Client_ID) REFERENCES Clients(Client_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gyms(Gym_ID),
    FOREIGN KEY (Address_ID) REFERENCES [Address](Address_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Client_Schedule')
BEGIN
CREATE TABLE Client_Schedule (
    Client_Schedule_ID int IDENTITY(1,1) PRIMARY KEY,
    Client_ID int,
    Schedule_ID int,
    FOREIGN KEY (Client_ID) REFERENCES Clients(Client_ID),
    FOREIGN KEY (Schedule_ID) REFERENCES Schedules(Schedule_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Gym_Report')
BEGIN
CREATE TABLE Gym_Report (
    Gym_Report_ID int IDENTITY(1,1) PRIMARY KEY,
    Gym_ID int,
    Report_Date date,
    Total_Attendance int,
    FOREIGN KEY (Gym_ID) REFERENCES Gyms(Gym_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Trainer_Report')
BEGIN
CREATE TABLE Trainer_Report (
    Trainer_Report_ID int IDENTITY(1,1) PRIMARY KEY,
    Trainer_ID int,
    Report_Date date,
    Total_Load int,
    FOREIGN KEY (Trainer_ID) REFERENCES Trainers(Trainer_ID)
);
END



IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Sport_Report')
BEGIN
CREATE TABLE Sport_Report (
    Sport_Report_ID int IDENTITY(1,1) PRIMARY KEY,
    Sport_ID int,
    Report_Date date,
    FOREIGN KEY (Sport_ID) REFERENCES Sports(Sport_ID)
);
END



