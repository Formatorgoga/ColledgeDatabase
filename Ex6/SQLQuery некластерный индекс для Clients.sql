-- Некластерный индекс для столбца Contact_Phone
CREATE NONCLUSTERED INDEX IDX_Clients_ContactPhone ON Clients (Contact_Phone);

SELECT First_Name, Last_Name, Contact_Phone
FROM Clients
WHERE Contact_Phone = '555-555'