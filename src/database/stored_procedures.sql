USE p1g6;

------------------------------------------- sp: 1 -----------------------------------------------------
GO
CREATE PROCEDURE GetEventIdsInExclusionTime
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
    SELECT DISTINCT RegistoEventos_Id AS Event_id FROM #MatchingRegistoEventos;

END;
GO

------------------------------------------- sp: 1.2 -----------------------------------------------------
GO
CREATE PROCEDURE GetRowCountOfEventsInExclusionTime
AS
BEGIN
    SET NOCOUNT ON;

    -- Create a table variable to store the result of the called stored procedure
    DECLARE @Result TABLE (
        Event_id INT
    );

    -- Call the stored procedure and insert the result into the table variable
    INSERT INTO @Result (Event_id)
    EXEC GetEventIdsInExclusionTime;

    -- Get the count of the result
    DECLARE @Count INT;
    SET @Count = (SELECT COUNT(*) FROM @Result);

    -- Return the count
    SELECT @Count AS row_count;
END;
GO

------------------------------------------- sp: 2 -----------------------------------------------------
CREATE PROCEDURE GetEventIdsInRepairingSchedule
AS
BEGIN
    SET NOCOUNT ON;

    SELECT RE.Id AS Event_id
    FROM REGISTO_EVENTOS AS RE
        INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
            INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
                INNER JOIN MANUTENCOES AS MAN ON MAN.AreaRestrita_Id = AR.Id
                        WHERE CONVERT(DATE, RE.[Timestamp]) BETWEEN MAN.DataInicio AND MAN.DataFim;
END;
GO

------------------------------------------- sp: 2.2 -----------------------------------------------------
GO
CREATE PROCEDURE GetRowCountOfEventsInRepairingSchedule
AS
BEGIN
    SET NOCOUNT ON;

    -- Create a table variable to store the result of the called stored procedure
    DECLARE @Result TABLE (
        Event_id INT
    );

    -- Call the stored procedure and insert the result into the table variable
    INSERT INTO @Result (Event_id)
    EXEC GetEventIdsInRepairingSchedule;

    -- Get the count of the result
    DECLARE @Count INT;
    SET @Count = (SELECT COUNT(*) FROM @Result);

    -- Return the count
    SELECT @Count AS row_count;
END;
GO

------------------------------------------- sp: 3 -----------------------------------------------------
GO
CREATE PROCEDURE GetEventIdsInActiveSchedule
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
    SELECT RegistoEventos_Id AS Event_id FROM #MatchingRegistoEventos;
END;
GO

------------------------------------------- sp: 3.2 -----------------------------------------------------
GO
CREATE PROCEDURE GetRowCountOfEventsInActiveSchedule
AS
BEGIN
    SET NOCOUNT ON;

    -- Create a table variable to store the result of the called stored procedure
    DECLARE @Result TABLE (
        Event_id INT
    );

    -- Call the stored procedure and insert the result into the table variable
    INSERT INTO @Result (Event_id)
    EXEC GetEventIdsInActiveSchedule;

    -- Get the count of the result
    DECLARE @Count INT;
    SET @Count = (SELECT COUNT(*) FROM @Result);

    -- Return the count
    SELECT @Count AS row_count;
END;
GO

------------------------------------------- sp: 4 -----------------------------------------------------
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

------------------------------------------- sp: 5 -----------------------------------------------------

CREATE PROCEDURE AddUserEvent
    @timestamp TIMESTAMP,
    @tipo_ev_desc VARCHAR(64),
    @disp_seg_MAC VARCHAR(6),
    @user_id INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @registo_id INT;

        INSERT INTO REGISTO_EVENTOS (Timestamp, TipoEvento_Descricao, DispositivoSeguranca_Mac)
        VALUES (@timestamp, @tipo_ev_desc, @disp_seg_MAC);

        -- Get the inserted RegistoEventos_Id
        SET @registo_id = SCOPE_IDENTITY();

        INSERT INTO UTILIZADOR_REGISTO_EVENTOS (Utilizador_Id, RegistoEventos_Id)
        VALUES (@user_id, @registo_id);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @errorMessage NVARCHAR(500);
        SET @errorMessage = 'An error occurred while adding the user event. Error: ' + ERROR_MESSAGE();
        THROW 51000, @errorMessage, 1;
    END CATCH;
END;
GO

------------------------------------- Some SPs in this file -------------------------------------------
/*EXEC GetEventIdsInExclusionTime;
-- DROP PROC GetEventIdsInExclusionTime;
GO
EXEC GetRowCountOfEventsInExclusionTime;
-- DROP PROC GetRowCountOfEventsInExclusionTime;
GO
EXEC GetEventIdsInRepairingSchedule;
--DROP PROC GetEventIdsInRepairingSchedule;
GO
EXEC GetRowCountOfEventsInRepairingSchedule
--DROP PROC GetRowCountOfEventsInRepairingSchedule;
GO
EXEC GetEventIdsInActiveSchedule;
--DROP PROC GetEventIdsInActiveSchedule;
GO
EXEC GetRowCountOfEventsInActiveSchedule;
--DROP PROC GetRowCountOfEventsInActiveSchedule;
GO*/