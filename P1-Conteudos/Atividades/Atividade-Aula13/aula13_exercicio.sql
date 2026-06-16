-- Atividade Aula 13

-- Exercicio 1
CREATE OR REPLACE VIEW vw_livros_titulo_paginas AS
SELECT titulo, paginas
FROM livro;

-- Exercicio 2
CREATE OR REPLACE VIEW vw_autores_com_mais_de_um_livro AS
SELECT a.id_autor, a.nome, COUNT(l.id_livro) AS total_livros
FROM autor a
JOIN livro l ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome
HAVING COUNT(l.id_livro) > 1;

-- Exercicio 3
CREATE OR REPLACE VIEW vw_livros_acima_media_paginas AS
SELECT l.*
FROM livro l
WHERE l.paginas > (SELECT AVG(paginas) FROM livro);

-- Exercicio 4
CREATE OR REPLACE VIEW vw_autor_livro_ano AS
SELECT a.nome AS autor, l.titulo, l.ano_publicacao
FROM livro l
JOIN autor a ON a.id_autor = l.id_autor;

-- Exercicio 5
CREATE OR REPLACE VIEW vw_resumo_autor_livros AS
SELECT a.nome AS autor, COUNT(l.id_livro) AS total_livros, MAX(l.paginas) AS maior_numero_paginas
FROM autor a
LEFT JOIN livro l ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome;
