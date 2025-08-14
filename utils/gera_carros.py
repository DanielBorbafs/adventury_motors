import pandas as pd
import random

# Listas de referência
marcas = ['Ford', 'Chevrolet', 'Toyota', 'Volkswagen', 'Honda', 'Nissan', 'Hyundai']
modelos = {
    'Ford': ['Ka', 'Fiesta', 'EcoSport'],
    'Chevrolet': ['Onix', 'Prisma', 'Tracker'],
    'Toyota': ['Corolla', 'Yaris', 'Hilux'],
    'Volkswagen': ['Gol', 'Polo', 'T-Cross'],
    'Honda': ['Civic', 'Fit', 'HR-V'],
    'Nissan': ['Sentra', 'Versa', 'Kicks'],
    'Hyundai': ['HB20', 'Creta', 'Tucson']
}
cores = ['Preto', 'Branco', 'Prata', 'Vermelho', 'Azul', 'Cinza', 'Verde']
fornecedores = ['AutoPrime', 'CarMaster', 'VeículoPlus', 'MegaMotors', 'RodaCerta', 'TopCar', 'DriveMax']
condicoes = ['novo', 'usado']


# Quantidade de carros a gerar
num_carros = 1000
carros = []

for i in range(1, num_carros + 1):
    marca = random.choice(marcas)
    modelo = random.choice(modelos[marca])
    condicao = random.choice(condicoes)

    carro = {
        'id_carro': i,
        'marca': marca,
        'modelo': modelo,
        'ano': random.randint(2020, 2025),
        'cor': random.choice(cores),
        'preco': random.randint(40000, 150000),
        'fornecedor': random.choice(fornecedores),
        'condicao': condicao,
        'quilometragem': 0 if condicao == 'novo' else random.randint(20000, 110000)
    }
    carros.append(carro)

# Criar DataFrame e salvar em CSV
df_carros = pd.DataFrame(carros)
df_carros.to_csv("carros.csv", index=False)
print(df_carros)
print("Tabela de carros gerada com sucesso!")