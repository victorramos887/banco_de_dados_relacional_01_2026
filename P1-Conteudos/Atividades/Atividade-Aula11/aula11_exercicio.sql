-- Atividade Aula 11

-- Exercicio 1 - subquery escalar
SELECT
    a.id_autor,
    a.nome,
    (SELECT COUNT(*) FROM livro l WHERE l.id_autor = a.id_autor) AS total_livros,
    (SELECT AVG(l2.paginas)::NUMERIC(10,2) FROM livro l2 WHERE l2.id_autor = a.id_autor) AS media_paginas
FROM autor a
ORDER BY a.nome;

-- Exercicio 1 - CTE
WITH agregados AS (
    SELECT id_autor, COUNT(*) AS total_livros, AVG(paginas)::NUMERIC(10,2) AS media_paginas
    FROM livro
    GROUP BY id_autor
)
SELECT
    a.id_autor,
    a.nome,
    COALESCE(ag.total_livros, 0) AS total_livros,
    COALESCE(ag.media_paginas, 0) AS media_paginas
FROM autor a
LEFT JOIN agregados ag ON ag.id_autor = a.id_autor
ORDER BY a.nome;

-- Exercicio 2
WITH paginas_por_autor AS (
    SELECT id_autor, SUM(paginas) AS soma_paginas
    FROM livro
    GROUP BY id_autor
)
SELECT a.id_autor, a.nome, ppa.soma_paginas
FROM paginas_por_autor ppa
JOIN autor a ON a.id_autor = ppa.id_autor
WHERE ppa.soma_paginas > (SELECT AVG(soma_paginas) FROM paginas_por_autor)
ORDER BY ppa.soma_paginas DESC;

-- Exercicio 3 - A (subconsulta correlacionada)
SELECT
    a.id_autor,
    a.nome,
    (SELECT COUNT(*) FROM livro l WHERE l.id_autor = a.id_autor) AS total_livros
FROM autor a
WHERE (
    SELECT COUNT(*) FROM livro l WHERE l.id_autor = a.id_autor
) > (
    SELECT AVG(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM livro
        GROUP BY id_autor
    ) t
);

-- Exercicio 3 - B (CTE pre-agrupada)
WITH livros_por_autor AS (
    SELECT id_autor, COUNT(*) AS total_livros
    FROM livro
    GROUP BY id_autor
),
media_geral AS (
    SELECT AVG(total_livros) AS media_livros
    FROM livros_por_autor
)
SELECT a.id_autor, a.nome, lpa.total_livros
FROM livros_por_autor lpa
JOIN autor a ON a.id_autor = lpa.id_autor
CROSS JOIN media_geral mg
WHERE lpa.total_livros > mg.media_livros;
