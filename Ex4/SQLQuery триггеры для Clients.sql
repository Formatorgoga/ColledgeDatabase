--Триггеры для Clients
ALTER TRIGGER [dbo].[trg_DeleteClientCascade]
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


ALTER TRIGGER [dbo].[trg_InsertClientCheckAge]
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


ALTER TRIGGER [dbo].[trg_InsertClientCheckPhoneUnique]
ON [dbo].[Clients]

AFTER INSERT
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


ALTER TRIGGER [dbo].[trg_UpdateClientPhone]
ON [dbo].[Clients]
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM inserted i
        INNER JOIN Clients c ON c.Contact_Phone = i.Contact_Phone AND c.Client_ID != i.Client_ID
    )
    BEGIN
        RAISERROR ('Номер телефона клиента должен быть уникальным.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
