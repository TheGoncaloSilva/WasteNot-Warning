USE WasteNot_Warning;
GO

-- VIEW: 1
CREATE VIEW events_count_by_category AS SELECT 
    TipoEvento_Descricao, COUNT(*) AS neventos 
        FROM REGISTO_EVENTOS 
            GROUP BY TipoEvento_Descricao;
GO
--DROP VIEW events_count_by_category;
GO

--VIEW: 2
CREATE VIEW next_repairs AS (
    SELECT MAN.Id as Man_id, 
        Man.DataInicio as Man_inicio, 
            Man.DataFim as Man_fim, 
                Man.Comentatio as Man_comentario, 
                    Man.EstadoManutencao_Descricao as Man_estado,
                        AR.Id as AR_id,
                            AR.DESCRICAO AS AR_descricao,
                                AR.LOCALIZACAO AS AR_localizacao
    FROM MANUTENCOES AS MAN
        INNER JOIN ESTADO_MANUTENCAO AS EM ON EM.Descricao = MAN.EstadoManutencao_Descricao
            INNER JOIN AREA_RESTRITA AS AR ON AR.Id = MAN.AreaRestrita_Id
                WHERE (CONVERT(DATE, GETDATE()) < MAN.DataInicio) AND 
                    (CONVERT(DATE, GETDATE()) < MAN.DataFim)
);
GO
--DROP VIEW next_repairs;

--VIEW: 3
