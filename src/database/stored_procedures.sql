USE WasteNot_Warning;

-- SP: 1 -> Not complete, verificar se está dentro do horário de monitorização
GO
CREATE PROCEDURE GetRowCountOfEventsInExclusionTime
AS
BEGIN
    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO AS ARHE ON ARHE.AreaRestrita_Id = AR.Id
                    INNER JOIN HORARIO_EXCLUSAO AS HE ON HE.Id = ARHE.HorarioExclusao_Id
                        WHERE RE.[Timestamp] BETWEEN HE.DataInicio AND HE.DataFim;

    SELECT @RowCount as row_count;
    --RETURN @RowCount;
END;
GO
/* With Return
DECLARE @Result INT;
EXEC @Result = GetRowCountOfEventsInExclusionTime;
SELECT @Result;*/
EXEC GetRowCountOfEventsInExclusionTime;
--DROP PROCEDURE GetRowCountOfEventsInExclusionTime;
GO

-- sp: 2
CREATE PROCEDURE GetRowCountOfEventsInRepairingSchedule
AS
BEGIN
    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN MANUTENCOES AS MAN ON MAN.AreaRestrita_Id = AR.Id
                        WHERE RE.[Timestamp] BETWEEN MAN.DataInicio AND MAN.DataFim;

    SELECT @RowCount as row_count;
END;
GO

EXEC GetRowCountOfEventsInRepairingSchedule;
--DROP PROCEDURE GetRowCountOfEventsInRepairingSchedule;
GO

--sp: 3
CREATE PROCEDURE GetRowCountOfEventsInActiveSchedule
AS
BEGIN
    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN MANUTENCOES AS MAN ON MAN.AreaRestrita_Id = AR.Id
                        WHERE RE.[Timestamp] BETWEEN MAN.DataInicio AND MAN.DataFim;

    SELECT @RowCount as row_count;
END;
GO

EXEC GetRowCountOfEventsInActiveSchedule;
--DROP PROCEDURE GetRowCountOfEventsInActiveSchedule;



SELECT *
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO AS ARHE ON ARHE.AreaRestrita_Id = AR.Id
                    INNER JOIN HORARIO_EXCLUSAO AS HE ON HE.Id = ARHE.HorarioExclusao_Id
                        WHERE RE.[Timestamp] BETWEEN HE.DataInicio AND HE.DataFim;







INSERT INTO REGISTO_EVENTOS ([Timestamp], TipoEvento_Descricao, DispositivoSeguranca_Mac)
VALUES 
       ('2023-05-04 12:00:00', 'Intrusão detectada', 'EFGH34')
       ;

SELECT * FROM HORARIO_MONITORIZACAO;

ALTER TABLE HORARIO_MONITORIZACAO 
ALTER COLUMN HoraInicio TIME;

DELETE FROM HORARIO_MONITORIZACAO;