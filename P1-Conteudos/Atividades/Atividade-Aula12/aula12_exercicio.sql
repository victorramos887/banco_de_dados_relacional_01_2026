-- Atividade Aula 12

-- Tabelas base
DROP TABLE IF EXISTS carro, pessoa;

CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nascimento DATE
);

CREATE TABLE IF NOT EXISTS carro (
    id_carro INTEGER PRIMARY KEY,
    placa CHAR(7) NOT NULL,
    ano INTEGER,
    id_pessoa INTEGER NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE
);

-- Ajustar caminho dos CSVs no seu PC
COPY pessoa (id_pessoa, nome, nascimento)
FROM 'C:/caminho/aula3_pessoa.csv'
DELIMITER ','
CSV HEADER;

COPY carro (id_carro, placa, ano, id_pessoa)
FROM 'C:/caminho/aula3_carro.csv'
DELIMITER ','
CSV HEADER;

-- Exercicio 1
DROP INDEX IF EXISTS idx_pessoa_nome;
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Ana Silva';
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Joao Santos';
CREATE INDEX idx_pessoa_nome ON pessoa (nome);
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Ana Silva';
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Joao Santos';

-- Exercicio 2
DROP INDEX IF EXISTS idx_pessoa_nome;
DROP INDEX IF EXISTS idx_pessoa_nascimento;
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '1970-01-01';
CREATE INDEX idx_pessoa_nascimento ON pessoa (nascimento);
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nascimento >= DATE '1970-01-01';

-- Exercicio 3
DROP INDEX IF EXISTS idx_pessoa_nascimento;
DROP INDEX IF EXISTS idx_pessoa_nascimento_nome;
EXPLAIN ANALYZE
SELECT * FROM pessoa
WHERE nascimento >= DATE '2000-01-01' AND nome = 'Ana Silva';
CREATE INDEX idx_pessoa_nascimento_nome ON pessoa (nascimento, nome);
EXPLAIN ANALYZE
SELECT * FROM pessoa
WHERE nascimento >= DATE '2000-01-01' AND nome = 'Ana Silva';
EXPLAIN ANALYZE SELECT * FROM pessoa WHERE nome = 'Ana Silva';

-- Exercicio 4
DROP INDEX IF EXISTS idx_pessoa_nascimento_nome;
DROP INDEX IF EXISTS idx_pessoa_nascimento;
DROP INDEX IF EXISTS idx_pessoa_nome;
CREATE INDEX idx_pessoa_nascimento ON pessoa (nascimento);
CREATE INDEX idx_pessoa_nome ON pessoa (nome);
EXPLAIN ANALYZE
SELECT * FROM pessoa
WHERE nascimento >= DATE '2000-01-01' AND nome = 'Ana Silva';

-- Exercicio 5
DROP INDEX IF EXISTS idx_carro_ano;
EXPLAIN ANALYZE SELECT * FROM carro WHERE ano BETWEEN 2015 AND 2020;
CREATE INDEX idx_carro_ano ON carro (ano);
EXPLAIN ANALYZE SELECT * FROM carro WHERE ano BETWEEN 2015 AND 2020;

-- Exercicio 6
DROP INDEX IF EXISTS idx_pessoa_nome;
DROP INDEX IF EXISTS idx_carro_id_pessoa;
EXPLAIN ANALYZE
SELECT p.nome, c.placa
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nome = 'Ana Silva';
CREATE INDEX idx_pessoa_nome ON pessoa (nome);
CREATE INDEX idx_carro_id_pessoa ON carro (id_pessoa);
EXPLAIN ANALYZE
SELECT p.nome, c.placa
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nome = 'Ana Silva';

-- Exercicio 7
DROP INDEX IF EXISTS idx_pessoa_nome;
DROP INDEX IF EXISTS idx_carro_id_pessoa;
DROP INDEX IF EXISTS idx_pessoa_nascimento;
DROP INDEX IF EXISTS idx_carro_id_pessoa_ano;
EXPLAIN ANALYZE
SELECT p.nome, c.placa, c.ano
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nascimento >= DATE '1980-01-01'
  AND c.ano >= 2018;
CREATE INDEX idx_pessoa_nascimento ON pessoa (nascimento);
CREATE INDEX idx_carro_id_pessoa_ano ON carro (id_pessoa, ano);
EXPLAIN ANALYZE
SELECT p.nome, c.placa, c.ano
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nascimento >= DATE '1980-01-01'
  AND c.ano >= 2018;

-- Exercicio 8
DROP INDEX IF EXISTS idx_pessoa_nascimento;
DROP INDEX IF EXISTS idx_pessoa_nascimento_gist;
EXPLAIN ANALYZE
SELECT * FROM pessoa
WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31';
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE INDEX idx_pessoa_nascimento_gist ON pessoa USING GIST (nascimento);
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'pessoa';
EXPLAIN ANALYZE
SELECT * FROM pessoa
WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31';
