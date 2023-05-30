USE WasteNot_Warning;
GO


CREATE INDEX idx_registo_eventos_timestamp ON REGISTO_EVENTOS (Timestamp);

CREATE INDEX idx_dispositivo_mac ON DISPOSITIVO(Mac);

CREATE INDEX idx_utilizador_telefone ON UTILIZADOR(Telefone);


