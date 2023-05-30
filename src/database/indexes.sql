USE WasteNot_Warning;
GO


CREATE CLUSTERED INDEX idx_registo_eventos_timestamp ON REGISTO_EVENTOS (Timestamp);

CREATE CLUSTERED INDEX idx_dispositivo_mac ON DISPOSITIVO(Mac);

CREATE CLUSTERED INDEX idx_utilizador_telefone ON UTILIZADOR(Telefone);


