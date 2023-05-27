-- SP: 1
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
                INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO AS ARHE ON ARHE.AreaRestrita_Id = AR.Id
                    INNER JOIN HORARIO_EXCLUSAO AS HE ON HE.Id = ARHE.HorarioExclusao_Id
                        WHERE RE.[Timestamp] BETWEEN HE.DataInicio AND HE.DataFim;

    SELECT @RowCount as row_count;
    --RETURN @RowCount;
END;
GO


SELECT *
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN MANUTENCOES AS MAN ON MAN.AreaRestrita_Id = AR.Id
                        WHERE RE.[Timestamp] BETWEEN MAN.DataInicio AND MAN.DataFim;