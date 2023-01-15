--1. num dado período (i.e. entre duas datas), por dia da semana, por concelho e no total

/*(
SELECT GROUPING(dia_semana) dia_semana, GROUPING(concelho) concelho, SUM(unidades) tot_artigos
FROM vendas
WHERE ano BETWEEN 2000 AND 20002
GROUP BY GROUPING SETS ((dia_semana), (concelho))
)
UNION
(
SELECT dia_semana, concelho, SUM(unidades) tot_artigos
FROM vendas
WHERE ano BETWEEN 2000 AND 20002
);*/



SELECT dia_semana, concelho, SUM(unidades) tot_artigos
FROM vendas
WHERE ano BETWEEN 2000 AND 20002
GROUP BY GROUPING SETS ((dia_semana), (concelho), ());



--2. num dado distrito (i.e. “Lisboa”), por concelho, categoria, dia da semana e no total

SELECT concelho, cat, dia_semana, SUM(unidades) tot_artigos
FROM vendas
WHERE distrito = 'Braga'
GROUP BY GROUPING SETS ((concelho, cat, dia_semana), ());



