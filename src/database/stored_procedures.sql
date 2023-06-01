USE p1g6;

-- SP: 1 -> Not complete, verificar se está dentro do horário de monitorização
GO
CREATE PROCEDURE GetRowCountOfEventsInExclusionTime
AS
BEGIN
    SET NOCOUNT ON;
    -- Create a temporary table
    CREATE TABLE #MatchingRegistoEventos (
        RegistoEventos_Id INT
    );
    
    -- Insert the matching RegistoEventos IDs into the temporary table
    INSERT INTO #MatchingRegistoEventos (RegistoEventos_Id)
    SELECT RE.Id
    FROM REGISTO_EVENTOS RE

    -- Check if the matching RegistoEventos IDs are NOT IN the HORARIO_MONITORIZACAO of the related AREA_RESTRITA and DISPOSITIVO_SEGURANCA
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO ARHM ON AR.Id = ARHM.AreaRestrita_Id
        INNER JOIN HORARIO_MONITORIZACAO HM ON ARHM.HorarioMonitorizacao_Id = HM.Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(TIME, RE.[Timestamp]) BETWEEN HM.HoraInicio AND HM.HoraFim
    );
    
    -- Check if the matching RegistoEventos IDs are NOT IN MANUTENCOES
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN MANUTENCOES M ON AR.Id = M.AreaRestrita_Id
        WHERE RE.Id IN ((SELECT RegistoEventos_Id FROM #MatchingRegistoEventos))
            AND CONVERT(DATE, RE.[Timestamp]) BETWEEN M.DataInicio AND M.DataFim
    );
    
    -- Check if the matching RegistoEventos IDs are in HORARIO_EXCLUSAO
    INSERT INTO #MatchingRegistoEventos (RegistoEventos_Id)
    (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO ARHE ON AR.Id = ARHE.AreaRestrita_Id
        INNER JOIN HORARIO_EXCLUSAO HE ON ARHE.HorarioExclusao_Id = HE.Id
        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO ARHM ON AR.Id = ARHM.AreaRestrita_Id
        INNER JOIN HORARIO_MONITORIZACAO HM ON ARHM.HorarioMonitorizacao_Id = HM.Id
        WHERE RE.Id IN (SELECT Id FROM REGISTO_EVENTOS)
            AND RE.[Timestamp] BETWEEN HE.DataInicio AND HE.DataFim
            AND NOT EXISTS (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
    );

    -- Return the final set of matching RegistoEventos IDs
    SELECT DISTINCT COUNT(*) AS row_count FROM #MatchingRegistoEventos;
    --
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
                        WHERE CONVERT(DATE, RE.[Timestamp]) BETWEEN MAN.DataInicio AND MAN.DataFim;

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
    -- Create a temporary table
    CREATE TABLE #MatchingRegistoEventos (
        RegistoEventos_Id INT
    );
    
    -- Insert the matching RegistoEventos IDs into the temporary table
    INSERT INTO #MatchingRegistoEventos (RegistoEventos_Id)
    SELECT RE.Id
    FROM REGISTO_EVENTOS RE
    
    -- Check if the matching RegistoEventos IDs are within the HORARIO_MONITORIZACAO of the related AREA_RESTRITA and DISPOSITIVO_SEGURANCA
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id NOT IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO ARHM ON AR.Id = ARHM.AreaRestrita_Id
        INNER JOIN HORARIO_MONITORIZACAO HM ON ARHM.HorarioMonitorizacao_Id = HM.Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(TIME, RE.[Timestamp]) BETWEEN HM.HoraInicio AND HM.HoraFim
    );
    
    -- Check if the matching RegistoEventos IDs are NOT in HORARIO_EXCLUSAO
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO ARHE ON AR.Id = ARHE.AreaRestrita_Id
        INNER JOIN HORARIO_EXCLUSAO HE ON ARHE.HorarioExclusao_Id = HE.Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(DATE, RE.[Timestamp]) BETWEEN HE.DataInicio AND HE.DataFim
    );
    
    -- Check if the matching RegistoEventos IDs are NOT IN MANUTENCOES
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN MANUTENCOES M ON AR.Id = M.AreaRestrita_Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(DATE, RE.[Timestamp]) BETWEEN M.DataInicio AND M.DataFim
    );
    
    -- Return the final set of matching RegistoEventos IDs
    SELECT COUNT(*) AS row_count FROM #MatchingRegistoEventos;
END;
GO

EXEC GetRowCountOfEventsInActiveSchedule;
--DROP PROCEDURE GetRowCountOfEventsInActiveSchedule;
GO

--sp: 4
GO
CREATE PROCEDURE getAlarmActivated
AS
BEGIN
    SET NOCOUNT ON;
    -- Procedure to analyze the events and determine if the alarm should be activated
    DECLARE @PastTime DATETIME;
    -- In seconds, time that the alarm should be activated
    --SET @PastTime = CONVERT(DATETIME, '2023-05-01 12:00:00');
    SET @PastTime = DATEADD(SECOND, -120, GETDATE());
    -- Create a temporary table to store the matching RegistoEventos IDs
    CREATE TABLE #MatchingRegistoEventos (
        RegistoEventos_Id INT
    );
    
    -- Insert the matching RegistoEventos IDs into the temporary table
    INSERT INTO #MatchingRegistoEventos (RegistoEventos_Id)
    SELECT RE.Id
    FROM REGISTO_EVENTOS RE
    WHERE RE.[Timestamp] >= @PastTime;
    
    -- Check if the matching RegistoEventos IDs are within the HORARIO_MONITORIZACAO of the related AREA_RESTRITA and DISPOSITIVO_SEGURANCA
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id NOT IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO ARHM ON AR.Id = ARHM.AreaRestrita_Id
        INNER JOIN HORARIO_MONITORIZACAO HM ON ARHM.HorarioMonitorizacao_Id = HM.Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(TIME, RE.[Timestamp]) BETWEEN HM.HoraInicio AND HM.HoraFim
    );
    
    -- Check if the matching RegistoEventos IDs are NOT in HORARIO_EXCLUSAO
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_EXCLUSAO ARHE ON AR.Id = ARHE.AreaRestrita_Id
        INNER JOIN HORARIO_EXCLUSAO HE ON ARHE.HorarioExclusao_Id = HE.Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(DATE, RE.[Timestamp]) BETWEEN HE.DataInicio AND HE.DataFim
    );
    
    -- Check if the matching RegistoEventos IDs are out of MANUTENCOES
    DELETE FROM #MatchingRegistoEventos
    WHERE RegistoEventos_Id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN MANUTENCOES M ON AR.Id = M.AreaRestrita_Id
        WHERE RE.Id IN (SELECT RegistoEventos_Id FROM #MatchingRegistoEventos)
            AND CONVERT(DATE, RE.[Timestamp]) BETWEEN M.DataInicio AND M.DataFim
    );
    
    -- Return the final set of matching RegistoEventos IDs
    SELECT RE.Id AS Reg_id,
        TE.Descricao AS Reg_tipo,
        RE.[Timestamp] AS Reg_timestamp,
        DS.Dispositivo_Mac AS Disp_mac,
        DS.TipoDispositivoSeguranca_Descricao AS Disp_tipo,
        AR.DESCRICAO AS AR_descricao,
        AR.LOCALIZACAO as AR_localizacao
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN TIPO_EVENTO AS TE ON TE.Descricao = RE.TipoEvento_Descricao
            INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON DS.Dispositivo_Mac = RE.DispositivoSeguranca_Mac
                INNER JOIN AREA_RESTRITA AS AR ON AR.Id = DS.AreaRestrita_Id
                    WHERE RE.Id IN (SELECT * FROM #MatchingRegistoEventos)
                        ORDER BY RE.[Timestamp] DESC;
END;
GO

EXEC getAlarmActivated;
--DROP PROCEDURE getAlarmActivated;
