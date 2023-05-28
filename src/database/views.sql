USE WasteNot_Warning;
GO

CREATE VIEW events_count_by_category AS SELECT TipoEvento_Descricao, COUNT(*) AS neventos FROM REGISTO_EVENTOS GROUP BY TipoEvento_Descricao;
