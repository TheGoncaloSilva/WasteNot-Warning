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
CREATE VIEW list_ordered_events AS (
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
                    ORDER BY RE.[Timestamp] DESC
);
GO