USE WasteNot_Warning;
-- SAMPLE WASTE NOT WARNING DATA

INSERT INTO NIVEL_PERMISSAO(Nivel) VALUES ('utilizador comum');
INSERT INTO NIVEL_PERMISSAO(Nivel) VALUES ('administrador');
INSERT INTO NIVEL_PERMISSAO(Nivel) VALUES ('utilizador externo');

-- INSERT statements
INSERT INTO UTILIZADOR (Nome, PW_Hash, Salt, Telefone, DataNascimento, NivelPermissao_Nivel)
VALUES
    ('João Silva', 
        0xb47958e9e761da3b448522da07f287289a2bee3e32438bbe8eee725aad2cd60a,
        0x0123456789ABCDEF0123456789ABCDEF,
        123456789, '1990-01-01', 'administrador'),
    ('Maria Furtado', 
        0xb47958e9e761da3b448522da07f287289a2bee3e32438bbe8eee725aad2cd60a,
        0x0123456789ABCDEF0123456789ABCDEF,
        939939939, '2000-02-03', 'utilizador comum'),
    ('Paulo Alberto', 
        0xb47958e9e761da3b448522da07f287289a2bee3e32438bbe8eee725aad2cd60a,
        0x0123456789ABCDEF0123456789ABCDEF,
        919919919, '1982-05-04', 'utilizador externo'),
    ('Joana Santos', 
        0xb47958e9e761da3b448522da07f287289a2bee3e32438bbe8eee725aad2cd60a,
        0x0123456789ABCDEF0123456789ABCDEF,
        929929929, '1995-10-12', 'administrador'),
    ('Francisco Lourenço', 
        0xb47958e9e761da3b448522da07f287289a2bee3e32438bbe8eee725aad2cd60a,
        0x0123456789ABCDEF0123456789ABCDEF,
        999999999, '1993-07-02', 'utilizador comum');
    

INSERT INTO HORARIO_MONITORIZACAO (HoraInicio, HoraFim, Estado)
VALUES
    ('00:00:00', '07:00:00', 1),
    ('19:00:00', '23:00:00', 0);

INSERT INTO AREA_RESTRITA (DESCRICAO, LOCALIZACAO)
VALUES
    ('Sala de Reuniões', 'Edifício A, 3º Andar'),
    ('Laboratório de Informática', 'Edifício B, 2º Andar'),
    ('Sala de Convívio', 'Edifício C, 1º Andar');

INSERT INTO AREA_RESTRITA_HORARIO_MONITORIZACAO (AreaRestrita_Id, HorarioMonitorizacao_Id)
VALUES
    (1, 1),
    (1, 2),
    (2, 2);

INSERT INTO AREA_RESTRITA_CONTACTA_UTILIZADOR (AreaRestrita_Id, Utilizador_Id, HoraInicio, HoraFim)
VALUES
    (1, 1, '06:00:00', '12:00:00'),
    (2, 2, '18:00:00', '23:00:00');

INSERT INTO AREA_RESTRITA_PERTENCE_UTILIZADOR (AreaRestrita_Id, Utilizador_Id)
VALUES
    (1, 1),
    (2, 2),
    (2, 3),
    (3, 3),
    (3, 4),
    (3, 5);

INSERT INTO HORARIO_EXCLUSAO (DataInicio, DataFim)
VALUES
    ('2023-05-20 08:00:00', '2023-05-20 12:00:00'),
    ('2023-05-21 14:00:00', '2023-05-21 18:00:00'),
    ('2023-05-22 09:00:00', '2023-05-22 13:00:00');

INSERT INTO AREA_RESTRITA_HORARIO_EXCLUSAO (AreaRestrita_Id, HorarioExclusao_Id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

INSERT INTO ESTADO_MANUTENCAO (Descricao)
VALUES
    ('Pendente'),
    ('Em Progresso'),
    ('Concluída');

INSERT INTO MANUTENCOES(DataInicio, DataFim, Comentatio, EstadoManutencao_Descricao, AreaRestrita_Id) 
VALUES 
    ('2023-05-01', '2023-05-03', 'Manutenção preventiva', 'Concluída', 1),
    ('2023-05-10', '2023-05-10', 'Troca de peças', 'Pendente', 2),
    ('2023-05-12', '2023-05-13', 'Limpeza geral', 'Em Progresso', 3),
    ('2023-05-08', '2023-05-09', 'Substituição do sensor', 'Concluída', 3),
    ('2023-05-04', '2023-05-05', 'Atualização de software', 'Concluída', 2);

INSERT INTO DISPOSITIVO(Mac, IP, Modelo, Fabricante) 
VALUES 
    ('ABCD12', '192.168.0.10', 'Sensor de temperatura', 'Fabricante A'),
    ('EFGH34', '192.168.0.11', 'Câmera de segurança', 'Fabricante B'),
    ('IJKL56', '192.168.0.12', 'Leitor biométrico', 'Fabricante C'),
    ('MNOP78', '192.168.0.13', 'Sensor de presença', 'Fabricante D'),
    ('QRST90', '192.168.0.14', 'Alarme de incêndio', 'Fabricante E');

INSERT INTO TIPO_DISPOSITIVO_SEGURANCA(Descricao) 
VALUES 
    ('Sensor de temperatura'),
    ('Câmera de segurança'),
    ('Leitor biométrico'),
    ('Sensor de presença'),
    ('Alarme de incêndio');


INSERT INTO DISPOSITIVO_SEGURANCA(Dispositivo_Mac, TipoDispositivoSeguranca_Descricao, AreaRestrita_Id) 
VALUES 
    ('ABCD12', 'Sensor de temperatura', 1),
    ('EFGH34', 'Câmera de segurança', 2),
    ('IJKL56', 'Leitor biométrico', 2),
    ('MNOP78', 'Sensor de presença', 3),
    ('QRST90', 'Alarme de incêndio', 3);

INSERT INTO DISPOSITIVO_ACESSO(Dispositivo_Mac) 
VALUES 
    ('ABCD12'),
    ('EFGH34'),
    ('IJKL56'),
    ('MNOP78'),
    ('QRST90');

INSERT INTO TIPO_EVENTO(Descricao) 
VALUES 
    ('Intrusão detectada'),
    ('Temperatura elevada'),
    ('Leitura biométrica válida'),
    ('Sensor de presença acionado');

INSERT INTO TIPO_EVENTO (Descricao)
VALUES	('Acesso permitido'), 
		('Acesso negado'), 
		('Alarme disparado'), 
		('Sensor de movimento ativado'), 
		('Sensor de porta aberta');

INSERT INTO REGISTO_EVENTOS ([Timestamp], TipoEvento_Descricao, DispositivoSeguranca_Mac)
VALUES ('2023-05-13 20:00:07', 'Acesso permitido', 'IJKL56'), 
       ('2023-05-13 10:05:13', 'Acesso negado', 'IJKL56'), 
       ('2023-05-13 11:00:6', 'Sensor de movimento ativado', 'MNOP78'), 
       ('2023-05-13 21:09:51', 'Alarme disparado', 'MNOP78'),
       ('2023-05-22 10:00:00', 'Sensor de movimento ativado', 'MNOP78'),
       ('2023-05-04 12:00:00', 'Intrusão detectada', 'EFGH34')
       ;

INSERT INTO UTILIZADOR_REGISTO_EVENTOS (Utilizador_Id, RegistoEventos_Id)
VALUES	(1, 1), 
		(2, 2), 
		(3, 3), 
		(4, 4);