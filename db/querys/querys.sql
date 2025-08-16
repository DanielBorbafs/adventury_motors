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

-------------------------------------------------------------------------------------

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