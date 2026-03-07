-- =====================================================================
-- AULA 04 - Exercícios: INSERT, ORDER BY, ORDER BY + LIMIT
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Inserir pelo menos 2 registros em tabela com chave estrangeira
--    (Evento depende de TipoEvento e Localizacao)
-- ---------------------------------------------------------------------

INSERT INTO TipoEvento (idTipoEvento, nome, descricao)
VALUES
  (2, 'Enchente',  'Alagamento de ruas e áreas habitadas por chuvas intensas.'),
  (3, 'Deslizamento', 'Movimento de massa de terra em encostas ou morros.');

INSERT INTO Localizacao (idLocalizacao, latitude, longitude, cidade, estado)
VALUES
  (6, -23.548700, -46.638200, 'São Paulo',    'SP'),
  (7, -22.903500, -43.172900, 'Rio de Janeiro', 'RJ');

INSERT INTO Evento (idEvento, titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao)
VALUES
  (
    2,
    'Enchente no centro histórico',
    'Ruas alagadas após chuva de 80mm em 2 horas.',
    '2025-09-10 08:00:00',
    'Em Monitoramento',
    2,
    6
  ),
  (
    3,
    'Deslizamento em encosta do morro',
    'Queda de barreira atingiu duas residências.',
    '2025-10-22 03:45:00',
    'Ativo',
    3,
    7
  );

-- ---------------------------------------------------------------------
-- 2. Consulta com ORDER BY — eventos ordenados por data_hora (mais antigo primeiro)
-- ---------------------------------------------------------------------

SELECT
  idEvento,
  titulo,
  status,
  dataHora
FROM Evento
ORDER BY dataHora ASC;

-- ---------------------------------------------------------------------
-- 3. Consulta com ORDER BY + LIMIT — os 3 eventos mais recentes
-- ---------------------------------------------------------------------

SELECT
  idEvento,
  titulo,
  status,
  dataHora
FROM Evento
ORDER BY dataHora DESC
LIMIT 3;
