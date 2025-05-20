-- view que retorna a quantidade de consultas por categoria
CREATE VIEW view_qtd_consultas_especialidade as 
SELECT M.ESPECIALIDADE, COUNT(C.ID_CONSULTA) AS NUMERO_CONSULTAS
FROM medicos M 
INNER JOIN consultas C ON C.ID_MEDICO = M.ID_MEDICO 
GROUP BY M.ESPECIALIDADE;



-- VIEW CRIADA PARA CONSULTAR O GASTO TOTAL DA CLINICA;
CREATE VIEW view_gasto_total AS
SELECT 
    (SELECT SUM(SALARIO) FROM funcionarios) +
    (SELECT SUM(SALARIO) FROM medicos) + 
    (SELECT SUM(VALOR) FROM gastos AS TOTAL_GASTO);



-- View retorna o lucro total por especialidade
CREATE VIEW view_consulta_lucro_por_especialidade as
SELECT M.ESPECIALIDADE, SUM(C.VALOR) AS LUCRO
FROM medicos M 
INNER JOIN CONSULTAS C ON C.ID_MEDICO = M.ID_MEDICO
GROUP BY M.ESPECIALIDADE
ORDER BY LUCRO


-- Essa view retorna todo o gasto da clinica ate o momento
CREATE VIEW view_gasto_total as
SELECT SUM(VALOR) AS TOTAL_GASTO 
FROM gastos

-- VIEW PARA TRAZER TODO O LUCRO ATÉ O MOMENTO
CREATE VIEW view_lucro_total AS
SELECT SUM(VALOR) AS LUCRO
FROM CONSULTAS 

