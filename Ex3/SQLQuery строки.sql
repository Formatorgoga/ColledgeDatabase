USE [Gyms]

SELECT 
	REPLACE(Address_Line1, 'јдрес', 'Addr.') AS REPLACE_Address_Line1
FROM 
	[Address];


SELECT 
	SUBSTRING(Address_Line1, 1, 3) AS Substring_Address_Line1
FROM 
	[Address];


SELECT 
	STUFF(Address_Line1, 4, 3, 'Avenue') AS STUFF_Address_Line1
FROM 
	[Address];


SELECT 
	[Name], 
	STR(Area, 10, 2) AS STR_Area
FROM 
	Gyms;


SELECT [Name], UNICODE([Name]) AS Name_in_Unicode
FROM 
	Gyms;


SELECT LOWER([Name]) AS Lower_Name
FROM 
	Gyms;


SELECT UPPER([Name]) AS Upper_Name
FROM 
	Gyms;
