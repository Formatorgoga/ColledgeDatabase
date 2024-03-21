SELECT 
	DATEPART(YEAR, Date_of_Birth) AS Birth_Year
FROM 
	Clients;


SELECT 
	DATEADD(YEAR, 10, Date_of_Birth) AS Ten_Years_Later
FROM 
	Clients;


SELECT 
	DATEDIFF(YEAR, Date_of_Birth, GETDATE()) AS Age
FROM 
	Clients;


SELECT 
	GETDATE() AS Current_DateTime;
