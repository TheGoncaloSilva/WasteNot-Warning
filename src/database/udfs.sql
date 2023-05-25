-- UDF's

CREATE FUNCTION dbo.[checkLogin] (@InName VARCHAR(32), @InPassword VARCHAR(32))
RETURNS BIT
AS
BEGIN
	IF EXISTS(SELECT * FROM UTILIZADOR WHERE @InName=Nome AND @InPassword=[Password] AND NivelPermissao_Nivel='administrador')
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END
	RETURN 0
END
