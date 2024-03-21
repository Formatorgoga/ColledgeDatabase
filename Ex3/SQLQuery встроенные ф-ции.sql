USE [Gyms]

SELECT 
    First_Name, 
    Last_Name, 
    CONVERT(varchar(20), Date_of_Birth, 103) AS Formatted_Date_of_Birth
FROM 
    Clients;


SELECT 
    First_Name, 
    Last_Name, 
    CAST(Date_of_Birth AS varchar(20)) AS Date_of_Birth_String
FROM 
    Clients;


SELECT 
    First_Name, 
    Last_Name, 
    ISNULL(Health, 'No health information provided') AS Health_Status
FROM 
    Clients;


SELECT 
	First_Name, 
    Last_Name, 
	NULLIF(Health, 'Здоров') AS Health_Status
FROM Clients;


SELECT 
    First_Name, 
    Last_Name, 
    IIF(Gender = 'Мужской', 'Мистер.', 'Миссис.') + Last_Name AS Salutation
FROM 
    Clients;


	SELECT 
    First_Name, 
    Last_Name, 
    COALESCE(Middle_Name, 'No Middle Name') AS Middle_Name
FROM 
    Clients;


SELECT 
	Client_ID,
	First_Name, 
    Last_Name,
	CHOOSE (Client_ID, 'A','B','C','D','E') AS Expression  
FROM 
	Clients;

















