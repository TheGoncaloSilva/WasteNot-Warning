USE p1g6;
GO
-- When a security device is created, a device is also created
GO
CREATE OR ALTER TRIGGER trg_CreateDispositivoSeguranca
ON DISPOSITIVO_SEGURANCA
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT I.Dispositivo_Mac
        FROM inserted AS I
        LEFT JOIN DISPOSITIVO AS D ON I.Dispositivo_Mac = D.Mac
        WHERE D.Mac IS NULL
    )
    BEGIN
        INSERT INTO DISPOSITIVO (Mac, IP, Modelo, Fabricante)
        SELECT I.Dispositivo_Mac, NULL, NULL, NULL
        FROM inserted AS I
        LEFT JOIN DISPOSITIVO AS D ON I.Dispositivo_Mac = D.Mac
        WHERE D.Mac IS NULL;
    END;

    INSERT INTO DISPOSITIVO_SEGURANCA (Dispositivo_Mac, TipoDispositivoSeguranca_Descricao, AreaRestrita_Id)
    SELECT Dispositivo_Mac, TipoDispositivoSeguranca_Descricao, AreaRestrita_Id
    FROM inserted;
END;

GO
CREATE OR ALTER TRIGGER trg_CheckDateValidity
ON MANUTENCOES
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE DataInicio > DataFim
    )
    BEGIN
        RAISERROR('Start date must be less than end date.', 16, 1)
        ROLLBACK TRAN;
        RETURN;
    END;
END;