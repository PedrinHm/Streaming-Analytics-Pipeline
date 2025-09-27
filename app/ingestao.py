import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv
import time
import sqlalchemy

load_dotenv()

db_user = os.getenv("POSTGRES_USER")
db_password = os.getenv("POSTGRES_PASSWORD")
db_name = os.getenv("POSTGRES_DB")
db_host = "postgres"
db_port = "5432"

csv_file_path = '/app/dataset/netflix_titles.csv'
table_name = 'raw_titles'

DATABASE_URL = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

max_attempts = 10
for attempt in range(max_attempts):
    try:
        engine = sqlalchemy.create_engine(DATABASE_URL)
        conn = engine.connect()
        conn.close()
        break
    except Exception as e:
        print(f"Tentativa {attempt+1}/{max_attempts}: Banco ainda não disponível. Aguardando...")
        time.sleep(5)
else:
    print("Não foi possível conectar ao banco após várias tentativas.")
    exit(1)

df = pd.read_csv(csv_file_path)
df.to_sql(table_name, engine, if_exists='replace', index=False)

print("PROCESSO DE INGESTÃO CONCLUÍDO COM SUCESSO!")