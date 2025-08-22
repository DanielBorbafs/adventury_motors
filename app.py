import oracledb
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import os

load_dotenv()

#credenciais
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_SERVICE")

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # libera para todos (pode restringir se quiser)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_connection():
    return oracledb.connect(
        user=user,
        password=password,
        dsn=host
    )


@app.get('/')
def home():
    return {"mensagem": "Api de vendas rodando!"}

@app.get("/total_vendas")
def get_total_vendas():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT SUM(VALOR_VENDA) FROM VENDAS")
    total = cur.fetchone()[0]
    cur.close()
    conn.close()
    return {"total_vendas": total}


@app.get('/ticket_medio')
def get_ticket_medio():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT ROUND(SUM(VALOR_VENDA) / COUNT(DISTINCT CLIENTE_ID),2) AS TICKET_MEDIO FROM VENDAS")
    total_ticket = cur.fetchone()[0]
    cur.close()
    conn.close()
    return{"ticket_medio": total_ticket}

@app.get('/venda_mes_atual')
def get_venda_mes_atual():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        "SELECT TO_CHAR(SYSDATE, 'Month', 'NLS_DATE_LANGUAGE=PORTUGUESE') AS MES, "
        "SUM(VALOR_VENDA) AS TOTAL_VENDAS "
        "FROM VENDAS "
        "WHERE TRUNC(DATA_VENDA, 'MM') = TRUNC(SYSDATE, 'MM') "
        "GROUP BY TO_CHAR(SYSDATE, 'Month', 'NLS_DATE_LANGUAGE=PORTUGUESE')"
    )
    
    result = cur.fetchone()
    cur.close()
    conn.close()
    
    if result:
        mes, total_vendas = result
        return {"mes": mes.strip(), "total_vendas": float(total_vendas)}
        
    else:
        return {"mes": None, "total_vendas": 0.0}
    

@app.get('/qtd_cliente')
def get_ticket_medio():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT COUNT(DISTINCT ID) AS QTD_CLIENTE FROM CLIENTE ")
    total_clientes = cur.fetchone()[0]
    cur.close()
    conn.close()
    return{"total_clientes": total_clientes}
    
   



