-- Atividade Aula 16

-- tabela de log para o exercicio 2
CREATE TABLE IF NOT EXISTS log_exclusao_livro (
    id_log SERIAL PRIMARY KEY,
    id_livro INTEGER,
    titulo VARCHAR(200),
    data_hora_exclusao TIMESTAMP NOT NULL DEFAULT NOW(),
    mensagem TEXT NOT NULL
);

-- Exercicio 1
CREATE OR REPLACE FUNCTION bloquear_exclusao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.quantidade > 0 THEN
        RAISE EXCEPTION 'Exclusao bloqueada: livro "%" possui quantidade em estoque (%).', OLD.titulo, OLD.quantidade;
    END IF;
    RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_bloquear_exclusao ON livro;
CREATE TRIGGER trg_bloquear_exclusao
BEFORE DELETE ON livro
FOR EACH ROW
EXECUTE FUNCTION bloquear_exclusao();

-- Exercicio 2
CREATE OR REPLACE FUNCTION log_exclusao_livro()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO log_exclusao_livro (id_livro, titulo, data_hora_exclusao, mensagem)
    VALUES (OLD.id_livro, OLD.titulo, NOW(), 'Livro removido pelo sistema de auditoria.');
    RETURN OLD;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_exclusao ON livro;
CREATE TRIGGER trg_log_exclusao
AFTER DELETE ON livro
FOR EACH ROW
EXECUTE FUNCTION log_exclusao_livro();

-- Exercicio 3
CREATE OR REPLACE FUNCTION validar_limite_estoque()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.quantidade > 100 THEN
        RAISE EXCEPTION 'Atualizacao bloqueada: quantidade (%) excede o limite de 100.', NEW.quantidade;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_validar_limite ON livro;
CREATE TRIGGER trg_validar_limite
BEFORE UPDATE ON livro
FOR EACH ROW
EXECUTE FUNCTION validar_limite_estoque();

-- Exercicio 4 - respostas curtas
-- a) BEFORE roda antes da operacao e AFTER roda depois.
-- b) Validacao deve ficar no BEFORE.
-- c) Auditoria/log deve ficar no AFTER.
-- d) A ordem importa para evitar gravacao invalida e manter log consistente.

-- Exercicio 5 - reflexao curta
-- a) risco: dados invalidos entram se a aplicacao falhar.
-- b) vantagem no banco: regra centralizada para qualquer sistema que acesse o BD.
-- c) triggers ajudam a manter integridade automatica.
-- d) exemplo real: log de alteracao de salario, estoque ou status de pedido.
