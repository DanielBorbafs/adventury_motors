/* 
Como o valor de venda dos carros estão iguas ao de preco de custo
vamos dar um update na tabela de vendas para trazer uma margem de 25% de lucro em cada venda.
*/

update vendas v
   set
   v.valor_venda = (
      select case
                when c.preco * 1.25 > v.valor_venda then
                   c.preco * 1.25
                else
                   v.valor_venda  -- Mantém se já for maior que 25%
             end
        from carro c
       where c.id = v.carro_id
   )
 where exists (
   select 1
     from carro c
    where c.id = v.carro_id
);