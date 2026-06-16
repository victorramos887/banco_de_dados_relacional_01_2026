-- Atividade Aula 14

-- Exercicio 1
CREATE OR REPLACE PROCEDURE sp_inserir_livro_se_autor_existir(
    IN p_titulo VARCHAR(200),
    IN p_paginas INTEGER,
    IN p_ano_publicacao INTEGER,
    IN p_id_autor INTEGER,
    IN p_quantidade INTEGER DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM autor WHERE id_autor = p_id_autor) THEN
        RAISE EXCEPTION 'Autor % nao existe.', p_id_autor;
    END IF;

    INSERT INTO livro (titulo, paginas, ano_publicacao, id_autor, quantidade)
    VALUES (p_titulo, p_paginas, p_ano_publicacao, p_id_autor, p_quantidade);
END;
$$;

-- Exercicio 2
CREATE OR REPLACE PROCEDURE sp_atualizar_paginas_livro(
    IN p_id_livro INTEGER,
    IN p_novas_paginas INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_novas_paginas <= 10 THEN
        RAISE EXCEPTION 'Quantidade de paginas deve ser maior que 10.';
    END IF;

    UPDATE livro
    SET paginas = p_novas_paginas
    WHERE id_livro = p_id_livro;
END;
$$;

-- Exercicio 3
CREATE OR REPLACE PROCEDURE sp_excluir_autor_sem_livros(
    IN p_id_autor INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM livro WHERE id_autor = p_id_autor) THEN
        RAISE EXCEPTION 'Autor % possui livros cadastrados.', p_id_autor;
    END IF;

    DELETE FROM autor WHERE id_autor = p_id_autor;
END;
$$;

-- Exercicio 4
CREATE OR REPLACE PROCEDURE sp_media_paginas_por_autor(
    IN p_id_autor INTEGER,
    OUT nome_autor VARCHAR(120),
    OUT media_paginas NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT a.nome, COALESCE(AVG(l.paginas), 0)::NUMERIC(10,2)
    INTO nome_autor, media_paginas
    FROM autor a
    LEFT JOIN livro l ON l.id_autor = a.id_autor
    WHERE a.id_autor = p_id_autor
    GROUP BY a.nome;
END;
$$;

-- Exercicio 5
CREATE OR REPLACE PROCEDURE sp_inserir_livro_validado(
    IN p_titulo VARCHAR(200),
    IN p_paginas INTEGER,
    IN p_ano_publicacao INTEGER,
    IN p_id_autor INTEGER,
    IN p_quantidade INTEGER DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_paginas <= 0 THEN
        RAISE EXCEPTION 'Paginas deve ser maior que zero.';
    END IF;

    IF p_titulo IS NULL OR BTRIM(p_titulo) = '' THEN
        RAISE EXCEPTION 'Titulo nao pode ser vazio.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM autor WHERE id_autor = p_id_autor) THEN
        RAISE EXCEPTION 'Autor % nao existe.', p_id_autor;
    END IF;

    INSERT INTO livro (titulo, paginas, ano_publicacao, id_autor, quantidade)
    VALUES (p_titulo, p_paginas, p_ano_publicacao, p_id_autor, p_quantidade);
END;
$$;

-- Exercicio 6
-- teste de bloqueio de paginas negativas
CALL sp_inserir_livro_validado('Livro invalido', -10, 2026, 1, 1);
