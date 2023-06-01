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
	WHERE U.Utilizador_Id = 1ORDER BY [Timestamp]
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

GO
CREATE FUNCTION dbo.PaginatedEvents(@offset INT, @fetch INT)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM list_ordered_events
    ORDER BY Reg_timestamp DESC
    OFFSET @offset ROWS
    FETCH NEXT @fetch ROWS ONLY
);
GO