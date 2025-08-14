import pandas as pd
import random 
from faker import Faker 

fake = Faker('pt_BR')

tipos_carros = [
    'Hatch',
    'Sedan',
    'SUV',
    'Crossover',
    'Picape',
    'Conversível',
    'Coupé',
    'Minivan',
    'Esportivo',
    'Off-road',
    'Van',
    'Elétrico',
    'Híbrido',
    'Compacto',
    'Médio',
    'Luxo',
    'Utilitário'
]

tipos_pagamento = [
    'Cartão de Crédito',
    'Cartão de Débito',
    'Pix',
    'Boleto Bancário',
    'Transferência Bancária',
    'Dinheiro',
    'Financiamento',
    'Leasing',
    'Carteira Digital'
]


num_clientes = 1000
clientes = []

for i in range(1, num_clientes + 1):
    sexo = random.choice(['M', 'F'])
    nome = fake.first_name_male() if sexo == 'M' else fake.first_name_female()
    data_nascimento = fake.date_of_birth(minimum_age=18, maximum_age=80)
    uf = fake.estado_sigla()
    email = fake.email()
    telefone = fake.cellphone_number()
    faixa_renda = round(random.uniform(5000.0, 60000.0),2)
    tipo_carro = random.choice(tipos_carros)
    forma_pagamento = random.choice(tipos_pagamento)

    cliente = {
        'id': i,
        'nome': nome,
        'sexo': sexo, 
        'data_nascimento': data_nascimento.strftime('%d/%m/%Y'),
        'uf': uf,
        'email': email,
        'telefone': telefone,
        'faixa_renda': faixa_renda,
        'tipo_carro': tipo_carro,
        'forma_pagamento' : forma_pagamento
    }
    clientes.append(cliente)

df_clientes = pd.DataFrame(clientes)
df_clientes.to_csv("clientes.csv", index=False)
print(df_clientes)