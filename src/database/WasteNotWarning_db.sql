CREATE DATABASE WasteNot_Warning;

USE WasteNot_Warning;

CREATE TABLE NIVEL_PERMISSAO (
	[Nivel] VARCHAR(20) PRIMARY KEY
);

CREATE TABLE UTILIZADOR(
	[Id] INTEGER IDENTITY PRIMARY KEY,
	[Nome] VARCHAR(256) NOT NULL,
	[Password] VARCHAR(256) NOT NULL,
	[Telefone] INTEGER NOT NULL,
	[DataNascimento] DATE NOT NULL,
	[NivelPermissao_Nivel] VARCHAR(20) REFERENCES NIVEL_PERMISSAO(Nivel) NOT NULL
);

CREATE TABLE HORARIO_MONITORIZACAO(
	[Id] INTEGER IDENTITY PRIMARY KEY,
	[HoraInicio] TIME,
	[HoraFim] TIME,
	[Estado] BIT NOT NULL,
);

CREATE TABLE AREA_RESTRITA(
	[Id] INTEGER IDENTITY PRIMARY KEY,
	[DESCRICAO] VARCHAR(512),
	[LOCALIZACAO] VARCHAR(512)
);

CREATE TABLE AREA_RESTRITA_HORARIO_MONITORIZACAO(
	[AreaRestrita_Id] INTEGER REFERENCES AREA_RESTRITA(Id),
	[HorarioMonitorizacao_Id] INTEGER REFERENCES HORARIO_MONITORIZACAO(Id),
	PRIMARY KEY (AreaRestrita_Id, HorarioMonitorizacao_Id)
);

CREATE TABLE AREA_RESTRITA_CONTACTA_UTILIZADOR(
	[AreaRestrita_Id] INTEGER REFERENCES AREA_RESTRITA(Id),
	[Utilizador_Id] INTEGER REFERENCES UTILIZADOR(Id) ON DELETE CASCADE,
	[HoraInicio] DATE NOT NULL,
	[HoraFim] DATE NOT NULL,
	PRIMARY KEY (AreaRestrita_Id, Utilizador_Id)
);

CREATE TABLE AREA_RESTRITA_PERTENCE_UTILIZADOR(
	[AreaRestrita_Id] INTEGER REFERENCES AREA_RESTRITA(Id) ON DELETE CASCADE,
	[Utilizador_Id] INTEGER REFERENCES UTILIZADOR(Id) ON DELETE CASCADE,
	PRIMARY KEY (AreaRestrita_Id, Utilizador_Id)
);

CREATE TABLE HORARIO_EXCLUSAO(
	[Id] INTEGER IDENTITY PRIMARY KEY,
	[DataInicio] DATETIME NOT NULL,
	[DataFim] DATETIME NOT NULL
);

CREATE TABLE AREA_RESTRITA_HORARIO_EXCLUSAO(
	[AreaRestrita_Id] INTEGER REFERENCES AREA_RESTRITA(Id),
	[HorarioExclusao_Id] INTEGER REFERENCES HORARIO_EXCLUSAO(Id),
	PRIMARY KEY (AreaRestrita_Id, HorarioExclusao_Id)
);

CREATE TABLE ESTADO_MANUTENCAO(
	[Descricao] VARCHAR(64) PRIMARY KEY
);

CREATE TABLE MANUTENCOES(
	[Id] INTEGER IDENTITY PRIMARY KEY,
	[DataInicio] DATE NOT NULL,
	[DataFim] DATE NOT NULL,
	[Comentatio] VARCHAR(1024),
	[EstadoManutencao_Descricao] VARCHAR(64) REFERENCES ESTADO_MANUTENCAO(Descricao) NOT NULL,
	[AreaRestrita_Id] INTEGER REFERENCES AREA_RESTRITA(Id) NOT NULL
);

CREATE TABLE DISPOSITIVO(
	[Mac] VARCHAR(6) PRIMARY KEY,
	[IP] VARCHAR(16),
	[Modelo] VARCHAR(128),
	[Fabricante] VARCHAR(128)
);

CREATE TABLE TIPO_DISPOSITIVO_SEGURANCA(
	[Descricao] VARCHAR(64) PRIMARY KEY
);

CREATE TABLE DISPOSITIVO_SEGURANCA(
	[Dispositivo_Mac] VARCHAR(6) PRIMARY KEY REFERENCES DISPOSITIVO(Mac),
	[TipoDispositivoSeguranca_Descricao] VARCHAR(64) REFERENCES TIPO_DISPOSITIVO_SEGURANCA(Descricao),
	[AreaRestrita_Id] INTEGER REFERENCES AREA_RESTRITA(Id) NOT NULL
);

CREATE TABLE DISPOSITIVO_ACESSO(
	[Dispositivo_Mac] VARCHAR(6) PRIMARY KEY REFERENCES DISPOSITIVO(Mac)
);

CREATE TABLE TIPO_EVENTO(
	[Descricao] VARCHAR(64) PRIMARY KEY
);

CREATE TABLE REGISTO_EVENTOS(
	[Id] INTEGER IDENTITY PRIMARY KEY,
	[Timestamp] DATETIME NOT NULL,
	[TipoEvento_Descricao] VARCHAR(64) NOT NULL REFERENCES TIPO_EVENTO(Descricao),
	[DispositivoSeguranca_Mac] VARCHAR(6) NOT NULL REFERENCES DISPOSITIVO_SEGURANCA(Dispositivo_Mac)/* Analisar pq se calhar era melhor estar ligado ao dispositivo*/
);

CREATE TABLE UTILIZADOR_REGISTO_EVENTOS(
	[Utilizador_Id] INTEGER REFERENCES UTILIZADOR(Id) ON DELETE CASCADE,
	[RegistoEventos_Id] INTEGER REFERENCES REGISTO_EVENTOS(Id),
	PRIMARY KEY (Utilizador_Id, RegistoEventos_Id)
);	
