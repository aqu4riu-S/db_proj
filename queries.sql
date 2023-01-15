---------------------------- 3. SQL -----------------------------------
---- PERGUNTA 1 ----
-- Qual o nome do retalhista (ou retalhistas) responsáveis pela reposição do maior número de categorias?

SELECT name
FROM retalhista r JOIN 
        (
        SELECT tin, COUNT(DISTINCT nome_cat)
        FROM responsavel_por
        GROUP BY tin
        HAVING COUNT(DISTINCT nome_cat) >= ALL (
            SELECT COUNT(DISTINCT rp.nome_cat)
            FROM responsavel_por rp
            GROUP BY rp.tin) 
        ) a
ON r.tin = a.tin;



---- PERGUNTA 2 ----
-- Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples?

--WITH INNER JOIN USING
SELECT a.name
FROM (evento_reposicao 
    INNER JOIN retalhista USING (tin)
    INNER JOIN produto USING (ean)
    INNER JOIN categoria ON produto.cat = categoria.nome
    INNER JOIN categoria_simples USING (nome)) a
GROUP BY a.name
HAVING COUNT(DISTINCT a.nome) = (SELECT COUNT(*) FROM categoria_simples);


---- PERGUNTA 3 ----
-- Quais os produtos (ean) que nunca foram repostos?


SELECT p.ean 
FROM produto p
WHERE p.ean NOT IN (
    SELECT DISTINCT er.ean 
    FROM evento_reposicao er);


---- PERGUNTA 4 ----
-- Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista


SELECT ean
FROM evento_reposicao
GROUP BY ean
HAVING COUNT(DISTINCT tin) = 1;
