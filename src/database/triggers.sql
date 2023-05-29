-- When a security device is created, a device is also created

CREATE OR ALTER TRIGGER trg_CreateDispositivoSeguranca
ON DISPOSITIVO_SEGURANCA
INSTEAD OF INSERT
AS
BEGIN

    IF NOT EXISTS (
        SELECT *
        FROM DISPOSITIVO
        WHERE Mac = (SELECT Dispositivo_Mac FROM inserted)
    )
    BEGIN

        INSERT INTO DISPOSITIVO (Mac, IP, Modelo, Fabricante)
        SELECT Dispositivo_Mac, NULL, NULL, NULL
        FROM inserted;
    END;

    INSERT INTO DISPOSITIVO_SEGURANCA (Dispositivo_Mac, TipoDispositivoSeguranca_Descricao, AreaRestrita_Id)
    SELECT Dispositivo_Mac, TipoDispositivoSeguranca_Descricao, AreaRestrita_Id
    FROM inserted;
END;