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



/* Ranking de vendedores
 "Traga os 3 vendedores com maior volume de vendas (em valor) no último trimestre."
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

-- Considerando que o preco do carro é o custo de compra e valor_venda é o preço de venda, calcule o lucro médio por fornecedor.
select c.fornecedor,
       sum(v.valor_venda) - sum(c.preco) as lucro
  from carro c
  join vendas v
on v.carro_id = c.id
 group by c.fornecedor
 order by lucro desc;


-- Traga o lucro por venda de cada carro e o percentual lucrado
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




--  Qual nossa despesa total com pagamentos mensais
select sum(salario)
       || ',00 ' as salarios_funcionarios
  from funcionario;

-- Qual a projeção anual total para pagamentos de funcionários
select sum(salario) * 12 as projecao_anual
  from funcionario;

-- qual é a média de renda de nossos clientes?
select round(
   avg(faixa_renda),
   2
) as média_salarial
  from cliente;