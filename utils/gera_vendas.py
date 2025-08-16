import pandas as pd 
import random 
from faker import Faker 

fake = Faker('pt_BR')

df_carros = pd.read_csv('carros.csv')


# depois trocar para puxar automaticamente do CSV
num_clientes = 1000
num_funcionarios = 30

clientes_ids = list(range(1, num_clientes + 1))
funcionarios_ids = list(range(1, num_funcionarios + 1))

# Quantidade de vendas (Não pode ser maior do que o número de carros)
num_vendas = 1000

carros_vendidos_ids = random.sample(df_carros['id_carro'].tolist(), num_vendas)

# Criando a tabela
vendas = []

for venda_id, carro_id in enumerate(carros_vendidos_ids, start=1):
    venda = {
        'id_venda': venda_id,
        'carro_id': carro_id,
        'cliente_id': random.choice(clientes_ids),
        'vendedor_id': random.choice(funcionarios_ids),
        'data_venda': fake.date_between(start_date='-5y', end_date = 'today'),
        'valor_venda': df_carros.loc[df_carros['id_carro'] == carro_id,'preco'].values[0]
    }
    vendas.append(venda)


df_vendas = pd.DataFrame(vendas)
df_vendas.to_csv("vendas.csv", index=False)

print(f"Tabela de vendas gerada com sucesso! ({len(df_vendas)} registros)")