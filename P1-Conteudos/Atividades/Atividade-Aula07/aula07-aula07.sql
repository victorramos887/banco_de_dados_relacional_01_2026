-- atividade 07

SELECT COUNT(*) AS total_usuarios FROM Usuario;
SELECT idTipoEvento, COUNT(*) as quantidade_eventos FROM Evento GROUP BY idTipoEvento;
SELECT MIN(dataHora) AS evento_mais_antigo, MAX(dataHora) AS evento_mais_recente
FROM Evento;
SELECT(SELECT COUNT(*) FROM Evento) * 1.0 / (SELECT COUNT(DISTINCT cidade) FROM
Localizacao) AS media_eventos_por_cidade;