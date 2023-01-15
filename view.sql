CREATE VIEW vendas(ean, cat, ano, mes, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT a.ean, cat, ano, mes, dia_mes, dia_semana, distrito, a.concelho, unidades
FROM 
(SELECT ean, EXTRACT(YEAR FROM er.instante) AS ano, EXTRACT(MONTH FROM er.instante) AS mes, EXTRACT(DAY FROM er.instante) AS dia_mes, EXTRACT(DOW FROM er.instante) AS dia_semana, concelho, SUM(unidades) AS unidades
    FROM evento_reposicao er 
    JOIN instalada_em i ON er.num_serie=i.num_serie
    JOIN ponto_de_retalho pr ON i.local=pr.nome 
    GROUP BY ean, EXTRACT(YEAR FROM er.instante), EXTRACT(MONTH FROM er.instante), EXTRACT(DAY FROM er.instante), EXTRACT(DOW FROM er.instante), concelho) AS a
JOIN produto p ON a.ean=p.ean
JOIN ponto_de_retalho pr ON a.concelho=pr.concelho;


/*
unidades: evento_reposicao
ean: produto
cat: categoria
distrito, concelho: ponto_de_retalho
ano, trimestre, mes, dia_mes, dia_semana: DERIVADOS DE instante
*/


-- ponto de retalho -> instalada em -> evento reposicao

/* funcoes para conseguirmos info a partir da timestamp (ou da date) */
/* SELECT EXTRACT(YEAR FROM TIMESTAMP '...');
SELECT EXTRACT(... FROM TIMESTAMP '...'); -> trimestre?
SELECT EXTRACT(MONTH FROM TIMESTAMP '...');
SELECT EXTRACT(DAY FROM TIMESTAMP '...');
SELECT EXTRACT(DOW FROM TIMESTAMP '...');


SELECT EXTRACT(... FROM DATE '...)';*/


