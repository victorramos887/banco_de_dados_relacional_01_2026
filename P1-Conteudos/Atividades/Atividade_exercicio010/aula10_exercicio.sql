-- Atividade 10
SELECT e.nome
FROM editora e
LEFT JOIN livro l
	ON l.id_editora = e.id_editora;

SELECT e.nome, COUNT(l.id_livro) AS qnt_livros
FROM editora e
LEFT JOIN livro l
	ON l.id_editora = e.id_editora
GROUP BY e.nome;

SELECT a.nome, COUNT(l.id_livro)
FROM autor a
LEFT JOIN livro l
	ON l.id_autor = a.id_autor
GROUP BY a.nome;

SELECT e.nome AS nome_autor, COUNT(l.id_livro) AS qnt_livros
FROM editora e
LEFT JOIN livro l
	ON l.id_editora = e.id_editora
GROUP BY nome_autor
HAVING COUNT(l.id_livro) > 1;

SELECT
	e.nome AS nome_editora,
	COUNT(l.id_livro) AS qnt_livros,
	COUNT(e2.id_emprestimo) AS qnt_emprestimo
FROM editora e
LEFT JOIN livro l
	ON l.id_editora = e.id_editora
LEFT JOIN empretimo_livro el
	ON el.id_livro = l.id_livro
LEFT JOIN emprestimo e2
	ON e2.id_emprestimo = el.id_emprestimo
GROUP BY e.nome;