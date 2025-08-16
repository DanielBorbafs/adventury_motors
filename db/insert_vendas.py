import oracledb 
import pandas as pd 
import os
from dotenv import load_dotenv

# Carregar variáveis de ambiente
load_dotenv()
csv_path = 'vendas.csv'

# Ler CSV
df = pd.read_csv(csv_path)

# Credenciais do banco
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_SERVICE")

# Conectando ao Oracle
conn = oracledb.connect(
    user=user,
    password=password,
    dsn=host
)

cursor = conn.cursor()

# SQL de INSERT
sql = """
INSERT INTO VENDAS(
    ID, CARRO_ID, CLIENTE_ID, VENDEDOR_ID, DATA_VENDA, VALOR_VENDA 
) VALUES (
    :1, :2, :3, :4, TO_DATE(:5, 'YYYY-MM-DD'), :6
)
"""

# Converter DataFrame em lista de tuplas
data = [tuple(row) for row in df.itertuples(index=False, name=None)]

# Executar o insert
cursor.executemany(sql, data)
conn.commit()

# Fechar conexões
cursor.close()
conn.close()

print('Dados inseridos com sucesso na tabela de VENDAS!')
