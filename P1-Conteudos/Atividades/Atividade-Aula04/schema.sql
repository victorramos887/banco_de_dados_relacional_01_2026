CREATE DATABASE clima_alerta;

-- B) TipoEvento
CREATE TABLE IF NOT EXISTS TipoEvento (
  idTipoEvento SERIAL,
  nome         VARCHAR(80) NOT NULL,
  descricao    VARCHAR(255) NULL,
  CONSTRAINT pk_TipoEvento PRIMARY KEY (idTipoEvento),
  CONSTRAINT uk_TipoEvento_nome UNIQUE (nome)
);

-- C) Localizacao
CREATE TABLE IF NOT EXISTS Localizacao (
  idLocalizacao SERIAL PRIMARY KEY,
  latitude      DECIMAL(9,6)  NOT NULL,
  longitude     DECIMAL(9,6)  NOT NULL,
  cidade        VARCHAR(80)   NOT NULL,
  estado        CHAR(2)       NOT NULL
);

CREATE INDEX ix_Localizacao_cidade_estado
ON Localizacao (cidade, estado);



-- D) Usuario
CREATE TABLE IF NOT EXISTS Usuario (
  idUsuario  SERIAL PRIMARY KEY,
  nome       VARCHAR(120) NOT NULL,
  email      VARCHAR(254) NOT NULL,
  senhaHash  VARCHAR(255) NOT NULL,
  CONSTRAINT uk_Usuario_email UNIQUE (email)
);

-- A) Evento
CREATE TABLE IF NOT EXISTS Evento (
  idEvento       SERIAL PRIMARY KEY,
  titulo         VARCHAR(160) NOT NULL,
  descricao      TEXT,
  dataHora       TIMESTAMP NOT NULL, -- ou TIMESTAMPTZ (recomendado)
  status         VARCHAR(30) NOT NULL,
  idTipoEvento   INT NOT NULL,
  idLocalizacao  INT NOT NULL,

  CONSTRAINT fk_Evento_TipoEvento
    FOREIGN KEY (idTipoEvento)
    REFERENCES TipoEvento (idTipoEvento)
    ON DELETE RESTRICT,

  CONSTRAINT fk_Evento_Localizacao
    FOREIGN KEY (idLocalizacao)
    REFERENCES Localizacao (idLocalizacao)
    ON DELETE RESTRICT,

  CONSTRAINT chk_Evento_status
    CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido'))
);

-- Índices (equivalentes aos KEY do MySQL)
CREATE INDEX IF NOT EXISTS ix_Evento_dataHora
  ON Evento (dataHora);

CREATE INDEX IF NOT EXISTS ix_Evento_status
  ON Evento (status);

CREATE INDEX IF NOT EXISTS ix_Evento_idTipoEvento
  ON Evento (idTipoEvento);

CREATE INDEX IF NOT EXISTS ix_Evento_idLocalizacao
  ON Evento (idLocalizacao);
  
  

-- E) Relato
CREATE TABLE IF NOT EXISTS Relato (
  idRelato   SERIAL PRIMARY KEY,
  texto      TEXT NOT NULL,
  dataHora   TIMESTAMP NOT NULL,
  idEvento   INT NOT NULL,
  idUsuario  INT NOT NULL,

  CONSTRAINT fk_Relato_Evento
    FOREIGN KEY (idEvento)
    REFERENCES Evento (idEvento)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_Relato_Usuario
    FOREIGN KEY (idUsuario)
    REFERENCES Usuario (idUsuario)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS ix_Relato_dataHora
	ON Relato (dataHora);
	
CREATE INDEX IF NOT EXISTS ix_Relato_idEvento
	ON Relato (idEvento);

CREATE INDEX IF NOT EXISTS ix_Relato_idUsuario
	ON Relato (idUsuario);

-- F) Alerta
CREATE TABLE IF NOT EXISTS Alerta (
  idAlerta   SERIAL PRIMARY KEY,
  mensagem   TEXT NOT NULL,
  dataHora   TIMESTAMP NOT NULL,
  nivel      VARCHAR(20) NOT NULL,
  idEvento   INT NOT NULL,

  CONSTRAINT fk_Alerta_Evento
    FOREIGN KEY (idEvento)
    REFERENCES Evento (idEvento)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Valores esperados (conforme enunciado): Baixo, Médio, Alto, Crítico
  CONSTRAINT chk_Alerta_nivel
    CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico'))
);

CREATE INDEX IF NOT EXISTS ix_Alerta_dataHora
	ON Alerta (dataHora);
	
CREATE INDEX IF NOT EXISTS ix_Alerta_nivel
	ON Alerta (nivel);

CREATE INDEX IF NOT EXISTS ix_Alerta_idEvento
	ON Alerta (idEvento);

-- 6) Tabela auxiliar (não estava no modelo inicial)
-- Exemplo útil: histórico de mudança de status do evento
CREATE TABLE IF NOT EXISTS HistoricoEvento (
  idHistorico      SERIAL PRIMARY KEY,
  idEvento         INT NOT NULL,
  statusAnterior   VARCHAR(30) NULL,
  statusNovo       VARCHAR(30) NOT NULL,
  dataHora         TIMESTAMP NOT NULL,
  observacao       VARCHAR(255) NULL,

  CONSTRAINT fk_HistoricoEvento_Evento
    FOREIGN KEY (idEvento)
    REFERENCES Evento (idEvento)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT chk_HistoricoEvento_statusNovo
    CHECK (statusNovo IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
  CONSTRAINT chk_HistoricoEvento_statusAnterior
    CHECK (statusAnterior IS NULL OR statusAnterior IN ('Ativo', 'Em Monitoramento', 'Resolvido'))
);


CREATE INDEX IF NOT EXISTS ix_HistoricoEvento_idEvento_dataHora
	ON HistoricoEvento (idEvento, dataHora);