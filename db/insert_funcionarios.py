import oracledb 
import pandas as pd 
import os
from dotenv import load_dotenv

load_dotenv()
csv_path = 'funcionarios.csv'


df = pd.read_csv(csv_path)

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
INSERT INTO FUNCIONARIO(
    ID, NOME, SEXO, CARGO, SALARIO
) VALUES (
    :1, :2, :3, :4, :5
)
"""

data = [tuple(row) for row in df.itertuples(index=False)]

cursor.executemany(sql,data)

conn.commit()
cursor.close()
conn.close()

print('Dados inseridos com sucesso na tabela de Funcionário!')