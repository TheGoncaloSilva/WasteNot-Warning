USE WasteNot_Warning;
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