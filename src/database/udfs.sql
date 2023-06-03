USE p1g6;
GO

CREATE FUNCTION dbo.GetLastUserEvents(@UserID INT, @TopCount INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@TopCount) Id,[Timestamp],TipoEvento_Descricao,Mac,Modelo,Fabricante
	FROM UTILIZADOR_REGISTO_EVENTOS AS U INNER JOIN REGISTO_EVENTOS AS R ON U.RegistoEventos_Id=R.Id 
	INNER JOIN DISPOSITIVO as D ON DispositivoSeguranca_Mac=D.Mac
	WHERE U.Utilizador_Id = @UserID ORDER BY [Timestamp]
);

GO
CREATE FUNCTION dbo.GetAreasRestritasByUserId(@UserId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT a.[Id], a.[DESCRICAO], a.[LOCALIZACAO]
    FROM AREA_RESTRITA a
    INNER JOIN AREA_RESTRITA_PERTENCE_UTILIZADOR apu ON a.Id = apu.AreaRestrita_Id
    WHERE apu.Utilizador_Id = @UserId
);
GO

CREATE FUNCTION dbo.GetLastRepairsOfARestrictedArea(@restrictedAreaID INT, @maxRows INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@maxRows)  DataInicio, DataFim, Comentatio, EstadoManutencao_Descricao, AreaRestrita_Id
    FROM MANUTENCOES AS M
    INNER JOIN AREA_RESTRITA AS A ON M.AreaRestrita_Id = A.Id
    WHERE A.Id = @restrictedAreaID
    ORDER BY DataInicio
);
GO

CREATE FUNCTION dbo.GetDeviceListOfARestrictedArea(@restrictedAreaID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Dispositivo_Mac, TipoDispositivoSeguranca_Descricao FROM DISPOSITIVO_SEGURANCA AS D
    INNER JOIN AREA_RESTRITA AS A
    ON D.AreaRestrita_Id = A.Id
    WHERE A.Id = @restrictedAreaID
);
GO

CREATE FUNCTION dbo.GetHorariosMonitorizacaoByRestrictedArea(@RestrictedAreaID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT HoraInicio,HoraFim,Estado FROM AREA_RESTRITA_HORARIO_MONITORIZACAO AS T1
    INNER JOIN AREA_RESTRITA AS T2 ON T1.AreaRestrita_Id=T2.Id
    INNER JOIN HORARIO_MONITORIZACAO AS T3 ON T1.HorarioMonitorizacao_Id=T3.Id
    WHERE T2.Id = @RestrictedAreaID
);
GO

CREATE FUNCTION dbo.GetEventIdsInExclusionTimeFunc()
RETURNS @MatchingRegistoEventos TABLE (
    Event_id INT
)
AS
BEGIN
    -- Insert the matching RegistoEventos IDs into the table variable
    INSERT INTO @MatchingRegistoEventos (Event_id)
    SELECT RE.Id
    FROM REGISTO_EVENTOS RE

    -- Check if the matching RegistoEventos IDs are NOT IN the HORARIO_MONITORIZACAO of the related AREA_RESTRITA and DISPOSITIVO_SEGURANCA
    DELETE FROM @MatchingRegistoEventos
    WHERE Event_id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN AREA_RESTRITA_HORARIO_MONITORIZACAO ARHM ON AR.Id = ARHM.AreaRestrita_Id
        INNER JOIN HORARIO_MONITORIZACAO HM ON ARHM.HorarioMonitorizacao_Id = HM.Id
        WHERE RE.Id IN (SELECT Event_id FROM @MatchingRegistoEventos)
            AND CONVERT(TIME, RE.[Timestamp]) BETWEEN HM.HoraInicio AND HM.HoraFim
    );

    -- Check if the matching RegistoEventos IDs are NOT IN MANUTENCOES
    DELETE FROM @MatchingRegistoEventos
    WHERE Event_id IN (
        SELECT RE.Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        INNER JOIN MANUTENCOES M ON AR.Id = M.AreaRestrita_Id
        WHERE RE.Id IN ((SELECT Event_id FROM @MatchingRegistoEventos))
            AND CONVERT(DATE, RE.[Timestamp]) BETWEEN M.DataInicio AND M.DataFim
    );

    -- Check if the matching RegistoEventos IDs are in HORARIO_EXCLUSAO
    INSERT INTO @MatchingRegistoEventos (Event_id)
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
        AND NOT EXISTS (SELECT Event_id FROM @MatchingRegistoEventos);

    -- Return the final set of matching RegistoEventos IDs
    RETURN;
END;
GO

GO
CREATE FUNCTION dbo.GetEventIdsInRepairingScheduleFunc()
RETURNS TABLE
AS
RETURN (
    SELECT RE.Id AS Event_id
    FROM REGISTO_EVENTOS AS RE
    INNER JOIN DISPOSITIVO_SEGURANCA AS DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
    INNER JOIN AREA_RESTRITA AS AR ON DS.AreaRestrita_Id = AR.Id
    INNER JOIN MANUTENCOES AS MAN ON MAN.AreaRestrita_Id = AR.Id
    WHERE CONVERT(DATE, RE.[Timestamp]) BETWEEN MAN.DataInicio AND MAN.DataFim
);
GO

GO
CREATE FUNCTION dbo.GetEventIdsInActiveScheduleFunc()
RETURNS TABLE
AS
RETURN (
    WITH MatchingRegistoEventos AS (
        SELECT RE.Id AS RegistoEventos_Id
        FROM REGISTO_EVENTOS RE
        INNER JOIN DISPOSITIVO_SEGURANCA DS ON RE.DispositivoSeguranca_Mac = DS.Dispositivo_Mac
        INNER JOIN AREA_RESTRITA AR ON DS.AreaRestrita_Id = AR.Id
        WHERE NOT EXISTS (
            SELECT 1
            FROM AREA_RESTRITA_HORARIO_MONITORIZACAO ARHM
            INNER JOIN HORARIO_MONITORIZACAO HM ON ARHM.HorarioMonitorizacao_Id = HM.Id
            WHERE AR.Id = ARHM.AreaRestrita_Id
                AND CONVERT(TIME, RE.[Timestamp]) BETWEEN HM.HoraInicio AND HM.HoraFim
        )
        AND NOT EXISTS (
            SELECT 1
            FROM AREA_RESTRITA_HORARIO_EXCLUSAO ARHE
            INNER JOIN HORARIO_EXCLUSAO HE ON ARHE.HorarioExclusao_Id = HE.Id
            WHERE AR.Id = ARHE.AreaRestrita_Id
                AND CONVERT(DATE, RE.[Timestamp]) BETWEEN HE.DataInicio AND HE.DataFim
        )
        AND NOT EXISTS (
            SELECT 1
            FROM MANUTENCOES M
            WHERE AR.Id = M.AreaRestrita_Id
                AND CONVERT(DATE, RE.[Timestamp]) BETWEEN M.DataInicio AND M.DataFim
        )
    )
    SELECT RegistoEventos_Id AS Event_id
    FROM MatchingRegistoEventos
);
GO

GO
CREATE FUNCTION dbo.PaginatedEvents(@offset INT, @fetch INT, @type VARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM (
        SELECT *
        FROM list_ordered_events
        WHERE
            (@type = 'all')
            OR
            (
                (@type = 'active') AND (Reg_id IN (SELECT Event_id FROM dbo.GetEventIdsInActiveScheduleFunc()))
            )
            OR
            (
                (@type = 'excluded') AND (Reg_id IN (SELECT Event_id FROM dbo.GetEventIdsInExclusionTimeFunc()))
            )
            OR
            (
                (@type = 'maintenance') AND (Reg_id IN (SELECT Event_id FROM dbo.GetEventIdsInRepairingScheduleFunc()))
            )
    ) AS Subquery
    ORDER BY Reg_timestamp DESC
    OFFSET @offset ROWS
    FETCH NEXT @fetch ROWS ONLY
);
GO

