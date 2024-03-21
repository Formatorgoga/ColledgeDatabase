USE [Gyms]

SELECT 
    Client_ID,
    First_Name,
    Last_Name,
    CASE 
        WHEN Gender = 'Мужской ' THEN 'М'
        WHEN Gender = 'Женский' THEN 'Ж'
        ELSE 'Other'
    END AS Gender_Short
FROM 
    Clients;
