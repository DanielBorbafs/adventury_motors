import oracledb 
import pandas as pd 
import os
from dotenv import load_dotenv

load_dotenv()
csv_path = 'carros.csv'


colunas = ['id', 'marca', 'modelo', 'ano', 'cor', 'preco', 'fornecedor', 'condicao', 'quilometragem']
df = pd.read_csv(
    csv_path,
    names = colunas,
    header = 0
)


#credenciais
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_SERVICE")

#conectando no banco
conn = oracledb.connect(
    user=user,
    password=password,
    dsn=host
)


cursor = conn.cursor()

sql = """
INSERT INTO CARRO(
    ID, MARCA, MODELO, ANO, COR, PRECO, FORNECEDOR, CONDICAO, QUILOMETRAGEM
) VALUES (
    :1, :2, :3, :4, :5, :6, :7, :8, :9
)
"""

data = [tuple(row) for row in df.itertuples(index=False)]

cursor.executemany(sql,data)

conn.commit()
cursor.close()
conn.close()

print('Dados inseridos com sucesso na tabela de Carros!')