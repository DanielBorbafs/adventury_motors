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