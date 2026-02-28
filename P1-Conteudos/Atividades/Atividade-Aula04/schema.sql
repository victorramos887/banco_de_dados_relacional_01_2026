-- Banco de Dados Relacional - Atividade Prática Aula 4
-- Tema: Manipulação de Dados com INSERT, UPDATE e DELETE
-- Curso: Desenvolvimento de Dispositivos Multiplataforma
-- Observação: script pensado para MySQL 8+ (InnoDB / utf8mb4)

-- 1) Criar o banco de dados
CREATE DATABASE IF NOT EXISTS clima_alerta
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE clima_alerta;

-- 2) Criar todas as tabelas do modelo normalizado

-- B) TipoEvento
CREATE TABLE IF NOT EXISTS TipoEvento (
  idTipoEvento INT NOT NULL AUTO_INCREMENT,
  nome         VARCHAR(80) NOT NULL,
  descricao    VARCHAR(255) NULL,
  PRIMARY KEY (idTipoEvento),
  UNIQUE KEY uk_TipoEvento_nome (nome)
) ENGINE=InnoDB;

-- C) Localizacao
CREATE TABLE IF NOT EXISTS Localizacao (
  idLocalizacao INT NOT NULL AUTO_INCREMENT,
  latitude      DECIMAL(9,6)  NOT NULL,
  longitude     DECIMAL(9,6)  NOT NULL,
  cidade        VARCHAR(80)   NOT NULL,
  estado        CHAR(2)       NOT NULL,
  PRIMARY KEY (idLocalizacao),
  KEY ix_Localizacao_cidade_estado (cidade, estado)
) ENGINE=InnoDB;

-- D) Usuario
CREATE TABLE IF NOT EXISTS Usuario (
  idUsuario  INT NOT NULL AUTO_INCREMENT,
  nome       VARCHAR(120) NOT NULL,
  email      VARCHAR(254) NOT NULL,
  senhaHash  VARCHAR(255) NOT NULL,
  PRIMARY KEY (idUsuario),
  UNIQUE KEY uk_Usuario_email (email)
) ENGINE=InnoDB;

-- A) Evento
CREATE TABLE IF NOT EXISTS Evento (
  idEvento       INT NOT NULL AUTO_INCREMENT,
  titulo         VARCHAR(160) NOT NULL,
  descricao      TEXT NULL,
  dataHora       DATETIME NOT NULL,
  status         VARCHAR(30) NOT NULL,
  idTipoEvento   INT NOT NULL,
  idLocalizacao  INT NOT NULL,
  PRIMARY KEY (idEvento),

  KEY ix_Evento_dataHora (dataHora),
  KEY ix_Evento_status (status),
  KEY ix_Evento_idTipoEvento (idTipoEvento),
  KEY ix_Evento_idLocalizacao (idLocalizacao),

  CONSTRAINT fk_Evento_TipoEvento
    FOREIGN KEY (idTipoEvento)
    REFERENCES TipoEvento (idTipoEvento)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_Evento_Localizacao
    FOREIGN KEY (idLocalizacao)
    REFERENCES Localizacao (idLocalizacao)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Valores esperados (conforme enunciado): Ativo, Em Monitoramento, Resolvido
  CONSTRAINT chk_Evento_status
    CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido'))
) ENGINE=InnoDB;

-- E) Relato
CREATE TABLE IF NOT EXISTS Relato (
  idRelato   INT NOT NULL AUTO_INCREMENT,
  texto      TEXT NOT NULL,
  dataHora   DATETIME NOT NULL,
  idEvento   INT NOT NULL,
  idUsuario  INT NOT NULL,
  PRIMARY KEY (idRelato),

  KEY ix_Relato_dataHora (dataHora),
  KEY ix_Relato_idEvento (idEvento),
  KEY ix_Relato_idUsuario (idUsuario),

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
) ENGINE=InnoDB;

-- F) Alerta
CREATE TABLE IF NOT EXISTS Alerta (
  idAlerta   INT NOT NULL AUTO_INCREMENT,
  mensagem   TEXT NOT NULL,
  dataHora   DATETIME NOT NULL,
  nivel      VARCHAR(20) NOT NULL,
  idEvento   INT NOT NULL,
  PRIMARY KEY (idAlerta),

  KEY ix_Alerta_dataHora (dataHora),
  KEY ix_Alerta_nivel (nivel),
  KEY ix_Alerta_idEvento (idEvento),

  CONSTRAINT fk_Alerta_Evento
    FOREIGN KEY (idEvento)
    REFERENCES Evento (idEvento)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  -- Valores esperados (conforme enunciado): Baixo, Médio, Alto, Crítico
  CONSTRAINT chk_Alerta_nivel
    CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico'))
) ENGINE=InnoDB;

-- 6) Tabela auxiliar (não estava no modelo inicial)
-- Exemplo útil: histórico de mudança de status do evento
CREATE TABLE IF NOT EXISTS HistoricoEvento (
  idHistorico      INT NOT NULL AUTO_INCREMENT,
  idEvento         INT NOT NULL,
  statusAnterior   VARCHAR(30) NULL,
  statusNovo       VARCHAR(30) NOT NULL,
  dataHora         DATETIME NOT NULL,
  observacao       VARCHAR(255) NULL,
  PRIMARY KEY (idHistorico),

  KEY ix_HistoricoEvento_idEvento_dataHora (idEvento, dataHora),

  CONSTRAINT fk_HistoricoEvento_Evento
    FOREIGN KEY (idEvento)
    REFERENCES Evento (idEvento)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT chk_HistoricoEvento_statusNovo
    CHECK (statusNovo IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
  CONSTRAINT chk_HistoricoEvento_statusAnterior
    CHECK (statusAnterior IS NULL OR statusAnterior IN ('Ativo', 'Em Monitoramento', 'Resolvido'))
) ENGINE=InnoDB;


-- =====================================================================
-- DADOS DE EXEMPLO (INSERT) - alinhados ao enunciado
-- (IDs explícitos para bater com os valores citados: TipoEvento=1, Localizacao=5, Usuario=2, Evento=1)
-- =====================================================================

-- TipoEvento (id=1)
INSERT INTO TipoEvento (idTipoEvento, nome, descricao)
VALUES (1, 'Queimada', 'Incêndio de grandes proporções em áreas urbanas ou rurais.');

-- Localizacao (id=5)
INSERT INTO Localizacao (idLocalizacao, latitude, longitude, cidade, estado)
VALUES (5, -23.305000, -45.965000, 'Jacareí', 'SP');

-- Usuario (id=2)
INSERT INTO Usuario (idUsuario, nome, email, senhaHash)
VALUES (2, 'Maria Oliveira', 'maria.oliveira@email.com', '2b6c7f64f76b09d0a7b9e...');

-- Evento (id=1)
INSERT INTO Evento (idEvento, titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao)
VALUES (
  1,
  'Queimada em área de preservação',
  'Fogo se alastrando na mata próxima à represa.',
  '2025-08-15 14:35:00',
  'Ativo',
  1,
  5
);

-- Relato (id=1)
INSERT INTO Relato (idRelato, texto, dataHora, idEvento, idUsuario)
VALUES (
  1,
  'Fumaça intensa e chamas visíveis a partir da rodovia.',
  '2025-08-15 15:10:00',
  1,
  2
);

-- Alerta (id=1)
INSERT INTO Alerta (idAlerta, mensagem, dataHora, nivel, idEvento)
VALUES (
  1,
  'Evacuação imediata da área próxima à represa.',
  '2025-08-15 15:20:00',
  'Crítico',
  1
);

-- Histórico inicial (opcional)
INSERT INTO HistoricoEvento (idEvento, statusAnterior, statusNovo, dataHora, observacao)
VALUES (1, NULL, 'Ativo', '2025-08-15 14:35:00', 'Evento criado');


-- =====================================================================
-- EXEMPLOS (UPDATE / DELETE) - para a Aula 4
-- (Deixe comentado se a entrega exigir apenas o schema.)
-- =====================================================================

-- UPDATE: mudar status do evento e registrar no histórico
-- UPDATE Evento
-- SET status = 'Em Monitoramento'
-- WHERE idEvento = 1;
--
-- INSERT INTO HistoricoEvento (idEvento, statusAnterior, statusNovo, dataHora, observacao)
-- VALUES (1, 'Ativo', 'Em Monitoramento', NOW(), 'Mudança de status após verificação em campo');

-- DELETE: excluir um alerta (exemplo)
-- DELETE FROM Alerta
-- WHERE idAlerta = 1;
