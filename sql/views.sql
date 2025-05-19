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
