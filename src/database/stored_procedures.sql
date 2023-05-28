USE WasteNot_Warning;

-- SP: 1 -> Not complete, verificar se está dentro do horário de monitorização
GO
CREATE PROCEDURE GetRowCountOfEventsInExclusionTime
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO AS ARHE ON ARHE.AreaRestrita_Id = AR.Id
                    INNER JOIN HORARIO_EXCLUSAO AS HE ON HE.Id = ARHE.HorarioExclusao_Id
                        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO AS ARHM ON ARHM.AreaRestrita_Id = AR.Id
                            INNER JOIN HORARIO_MONITORIZACAO AS HM ON HM.Id = ARHM.HorarioMonitorizacao_Id 
                                WHERE (RE.[Timestamp] BETWEEN HE.DataInicio AND HE.DataFim) OR 
                                    (CONVERT(TIME, RE.[Timestamp]) NOT BETWEEN HM.HoraInicio AND HM.HoraFim);

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
    SET NOCOUNT ON;
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
-- Este procedimento não é muito preciso, pois nem todas as as áreas têm registos em todas as tabelas 
GO
CREATE PROCEDURE GetRowCountOfEventsInActiveSchedule
AS
BEGIN 
    SET NOCOUNT ON;
    DECLARE @RowCount INT;

    SELECT @RowCount = COUNT(*)
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO AS ARHE ON ARHE.AreaRestrita_Id = AR.Id
                    INNER JOIN HORARIO_EXCLUSAO AS HE ON HE.Id = ARHE.HorarioExclusao_Id
                        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO AS ARHM ON ARHM.AreaRestrita_Id = AR.Id
                            INNER JOIN HORARIO_MONITORIZACAO AS HM ON HM.Id = ARHM.HorarioMonitorizacao_Id 
                                INNER JOIN MANUTENCOES AS MAN ON MAN.AreaRestrita_Id = AR.Id
                                    WHERE (RE.[Timestamp] NOT BETWEEN HE.DataInicio AND HE.DataFim) AND 
                                        (CONVERT(TIME, RE.[Timestamp]) BETWEEN HM.HoraInicio AND HM.HoraFim) AND
                                        (RE.[Timestamp] NOT BETWEEN MAN.DataInicio AND MAN.DataFim);

    SELECT @RowCount as row_count;
END;
GO

EXEC GetRowCountOfEventsInActiveSchedule;
--DROP PROCEDURE GetRowCountOfEventsInActiveSchedule;
GO

