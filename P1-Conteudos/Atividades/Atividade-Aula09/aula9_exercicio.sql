-- Exercicio 1
SELECT Evento.titulo, TipoEvento.nome FROM Evento INNER JOIN TipoEvento ON
Evento.idTipoEvento = TipoEvento.idTipoEvento;
-- Exercicio 2
SELECT Evento.titulo, Localizacao.cidade, Localizacao.estado AS sigla_estado FROM
Evento INNER JOIN Localizacao ON Evento.idLocalizacao = Localizacao.idLocalizacao
Evento INNER JOIN TipoEvento ON Evento.idTipoEvento = TipoEvento.idTipoEvento
LEFT JOIN Localizacao ON Evento.idLocalizacao = Localizacao.idLocalizacao;
-- Exercicio 4
SELECT Evento.titulo, Localizacao.cidade, Localizacao.estado AS sigla_estado FROM
Localizacao RIGHT JOIN Evento ON Localizacao.idLocalizacao = Evento.idLocalizacao;
-- Exercicio 5
SELECT Localizacao.cidade, COUNT(Evento.idEvento) AS quantidade_eventos FROM
Localizacao INNER JOIN Evento ON Localizacao.idLocalizacao = Evento.idLocalizacao
GROUP BY Localizacao.cidade;