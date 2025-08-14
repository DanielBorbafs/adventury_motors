import random
from faker import Faker
import pandas as pd

fake = Faker('pt_BR')

tipos_cargos = ['Gerente', 'Assistente de Vendas', 'Auxiliar administrativo', 'Vendedor']


pesos_cargos = [2, 8, 8, 12]

num_funcionarios = 30
funcionarios = []

for i in range(1, num_funcionarios + 1):
    cargo = random.choices(tipos_cargos, weights=pesos_cargos, k=1)[0]

    sexo = random.choice(['M', 'F'])
    nome = fake.first_name_male() if sexo == 'M' else fake.first_name_female()

    # Salário baseado no cargo
    if cargo == 'Gerente':
        salario = 10000
    elif cargo in ['Assistente de Vendas', 'Auxiliar administrativo']:
        salario = 1518
    elif cargo == 'Vendedor':
        salario = 2500
    else:
        salario = random.randint(2000, 5000)

    funcionario = {
        'id_funcionario': i,
        'nome': nome,
        'sexo': sexo,
        'cargo': cargo,
        'salario': salario
    }
    funcionarios.append(funcionario)


df_funcionarios = pd.DataFrame(funcionarios)
df_funcionarios.to_csv('funcionarios.csv', index=False)
print(df_funcionarios)

