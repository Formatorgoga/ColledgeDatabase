USE [Gyms]

SELECT 
	Gym_ID, 
	COUNT(*) AS Total_Clients
FROM 
	Clients_in_Gym
GROUP BY Gym_ID;


SELECT 
	Gym_ID, 
	COUNT(*) AS Total_Clients
FROM 
	Clients_in_Gym
GROUP BY 
	Gym_ID
HAVING 
	COUNT(*) >= 1;

