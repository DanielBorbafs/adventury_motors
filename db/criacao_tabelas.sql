create table carro (
   id            int primary key,
   marca         varchar2(20),
   modelo        varchar2(20),
   ano           varchar2(4),
   cor           varchar(20),
   preco         number(10,2),
   fornecedor    varchar(20),
   condicao      varchar2(10) check ( condicao in ( 'novo',
                                               'usado' ) ),
   quilometragem int
);

create table cliente (
   id              int primary key,
   nome            varchar2(20),
   sexo            varchar(1),
   data_nascimento date,
   uf              varchar(2),
   email           varchar(40),
   telefone        varchar(30),
   faixa_renda     number(10,2),
   tipo_carro      varchar2(20), -- Tipo de carro que o cliente tem interesse
   forma_pagamento varchar2(20)
);

create table funcionario (
   id      int primary key,
   nome    varchar2(20),
   sexo    varchar(1),
   cargo   varchar(25),
   salario number(10,2)
);

create table vendas (
   id          int primary key,
   carro_id    int,
   cliente_id  int,
   vendedor_id int,
   data_venda  date,
   valor_venda number(10,2),
   constraint fk_carro_id foreign key ( carro_id )
      references carro ( id ),
   constraint fk_cliente_id foreign key ( cliente_id )
      references cliente ( id ),
   constraint fk_funcionario_id foreign key ( vendedor_id )
      references funcionario ( id )
);