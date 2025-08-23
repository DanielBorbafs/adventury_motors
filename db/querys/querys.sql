/* ----------- clientes ------------ */

/* Perfil dos clientes por estado (UF)
 - Quantos clientes temos por estado e qual é a média de venda por cliente
 em cada estado
*/
select c.uf,
       count(distinct c.id) as qtd_clientes,
       round(
          sum(v.valor_venda) / count(distinct c.id),
          2
       ) as ticket_uf
  from cliente c
  join vendas v
on v.cliente_id = c.id
 group by c.uf
 order by ticket_uf desc;
 
-- Carros que ainda não foram vendidos
select *
  from carro c
 where not exists (
   select 1
     from vendas v
    where v.carro_id = c.id
);

-- Quantos clientes compraram mais de um carro no último ano?
select count(distinct cliente_id)
  from vendas
 where cliente_id in (
   select cliente_id
     from vendas
   having count(id) > 1
    group by cliente_id
);

-- Qual é a média de renda de nossos clientes?
select round(
   avg(faixa_renda),
   2
) as média_salarial
  from cliente;


-- Lucro por faixa etária de idade
select case
   when trunc(months_between(
      sysdate,
      c.data_nascimento
   ) / 12) between 18 and 30 then
      'Jovem'
   when trunc(months_between(
      sysdate,
      c.data_nascimento
   ) / 12) between 31 and 59 then
      'Adulto'
   when trunc(months_between(
      sysdate,
      c.data_nascimento
   ) / 12) >= 60             then
      'Idoso'
   else
      'Menor de 18'
       end as faixa_etaria,
       'R$ '
       || to_char(
          sum(v.valor_venda),
          '999G999G999D99'
       ) as lucro_total
  from cliente c
  join vendas v
on v.cliente_id = c.id
 group by
   case
      when trunc(months_between(
         sysdate,
         c.data_nascimento
      ) / 12) between 18 and 30 then
         'Jovem'
      when trunc(months_between(
         sysdate,
         c.data_nascimento
      ) / 12) between 31 and 59 then
         'Adulto'
      when trunc(months_between(
         sysdate,
         c.data_nascimento
      ) / 12) >= 60             then
         'Idoso'
      else
         'Menor de 18'
   end
 order by faixa_etaria;

-- Clientes cadastrados na plataforma que nunca fizeram uma compra.
select nome,
       email,
       telefone
  from cliente c
 where not exists (
   select *
     from vendas v
    where v.cliente_id = c.id
);



/* ----------- VENDAS ------------ */

/* Volume e valor de vendas por marca:
"Quantos carros de cada marca foram vendidos nos últimos 6 meses 
e qual foi o valor total de vendas por marca nesse período."
*/

select c.marca,
       sum(v.valor_venda) as valor_vendido,
       count(v.id) as qtd_vendas
  from carro c
  join vendas v
on v.carro_id = c.id
 where v.data_venda >= sysdate - 180
 group by c.marca
 order by valor_vendido desc;


with vendas_semestre as (
   select c.marca,
          v.valor_venda
     from carro c
     join vendas v
   on v.carro_id = c.id
    where v.data_venda >= sysdate - 180
)
select marca,
       count(*) as qtd_vendas,
       sum(valor_venda) as valor_vendido
  from vendas_semestre
 group by marca
 order by valor_vendido desc;

/* Ticket médio por condição
Qual é o ticket médio de venda de carros novos e usados?
*/
select c.condicao,
       round(
          (sum(v.valor_venda) / count(v.id)),
          2
       ) as ticket_médio
  from carro c
 inner join vendas v
on v.carro_id = c.id
 group by c.condicao;

-- calcule o lucro médio por fornecedor.
select c.fornecedor,
       sum(v.valor_venda) - sum(c.preco) as lucro
  from carro c
  join vendas v
on v.carro_id = c.id
 group by c.fornecedor
 order by lucro desc;

-- Lucro por venda de cada carro e o percentual lucrado
select c.modelo,
       c.preco,
       v.valor_venda,
       v.valor_venda - c.preco as lucro,
       round(
          (v.valor_venda - c.preco) / c.preco * 100,
          2
       )
       || '%' as percentual_lucro
  from vendas v
  join carro c
on v.carro_id = c.id;

--- Faturamento por mes
select to_char(
   data_venda,
   'Month',
   'NLS_DATE_LANGUAGE=PORTUGUESE'
) as mes,
       sum(valor_venda) as faturamento,
       to_char(
          data_venda,
          'MM'
       ) as num_mes
  from vendas
 group by to_char(
   data_venda,
   'Month',
   'NLS_DATE_LANGUAGE=PORTUGUESE'
),
          to_char(
             data_venda,
             'MM'
          )
 order by num_mes;

-- Estados com maior Faturamento
select c.uf,
       to_char(
          sum(v.valor_venda),
          '999G999G999D99'
       ) as faturamento
  from cliente c
 inner join vendas v
on v.cliente_id = c.id
 group by c.uf
 order by faturamento desc;

-- Ticket médio por forma de pagamento
select c.forma_pagamento,
       round(
          sum(v.valor_venda) / count(distinct v.id),
          2
       ) as ticket_medio
  from cliente c
 inner join vendas v
on v.cliente_id = c.id
 group by c.forma_pagamento
 order by ticket_medio desc;





 /* ----------- CARROS -----------  */

 -- Ranking de modelos de carros vendidos
select c.modelo,
       sum(v.valor_venda) as faturamento
  from carro c
  join vendas v
on v.carro_id = c.id
 group by c.modelo
 order by faturamento desc;
 
-- Quantidade de carros adquiridos por fornecedor.
select count(id) as carros_adquiridos,
       fornecedor
  from carro
 group by fornecedor
 order by carros_adquiridos desc;

-- Carros que ainda não foram vendidos
select c.id,
       c.marca,
       c.modelo
  from carro c
 where not exists (
   select *
     from vendas v
    where v.vendedor_id = c.id
);

-- Lucro potencial se todo o estoque de carros disponiveis forem vendidos.
select sum(c.preco * 1.25) as lucro_potencial
  from carro c
 where not exists (
   select *
     from vendas v
    where v.vendedor_id = c.id
);

/* ----------- FUNCIONARIOS -----------  */
-- Distribuição salarial por cargo
select cargo,
       sum(salario) as salario
  from funcionario
 group by cargo;

/* Evolução do desempenho de vendas por mes (crescimento ou queda de vendas por vendedor) 
-- CRIAR UMA FUNÇÃO ONDE PASSAMOS O NOME DO VENDEDOR E TRAZ O DESEMPENHO DE VENDAS.
*/
select f.nome,
       to_char(
          v.data_venda,
          'MM'
       ) as mes_num,
       to_char(
          v.data_venda,
          'Month',
          'NLS_DATE_LANGUAGE=PORTUGUESE'
       ) as mes,
       sum(v.valor_venda) as faturamento
  from funcionario f
  join vendas v
on v.vendedor_id = f.id
 group by f.nome,
          to_char(
             v.data_venda,
             'MM'
          ),
          to_char(
             v.data_venda,
             'Month',
             'NLS_DATE_LANGUAGE=PORTUGUESE'
          )
 order by f.nome,
          mes_num;

-- Ranking de vendedores que mais venderam
select f.nome,
       sum(v.valor_venda) as valor_vendido
  from funcionario f
  join vendas v
on v.vendedor_id = f.id
 group by f.nome
 order by valor_vendido desc;

--  Qual nossa despesa total com pagamentos mensais
-- Despesa mensal com os salarios dos funcionarios
select sum(salario)
       || ',00 ' as salarios_funcionarios
  from funcionario;

-- Projeção anual dos gastos com os salarios dos funcionarios
select sum(salario) * 12 as projecao_anual
  from funcionario;

/* Ranking de vendedores
  3 vendedores com maior volume de vendas (em valor) no último trimestre."
*/

select f.nome,
       f.cargo,
       to_char(
          sum(v.valor_venda),
          '999G999G999D99'
       ) as valor_em_vendas
  from funcionario f
  join vendas v
on v.vendedor_id = f.id
 group by f.nome,
          f.cargo
 order by valor_em_vendas desc
 fetch first 3 rows only;