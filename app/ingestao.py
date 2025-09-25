import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

db_user = os.getenv("POSTGRES_USER")
db_password = os.getenv("POSTGRES_PASSWORD")
db_name = os.getenv("POSTGRES_DB")
db_host = "postgres"
db_port = "5432"

csv_file_path = '/app/dataset/netflix_titles.csv'
table_name = 'raw_titles'

DATABASE_URL = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

engine = create_engine(DATABASE_URL)

df = pd.read_csv(csv_file_path)
df.to_sql(table_name, engine, if_exists='replace', index=False)

print("PROCESSO DE INGESTÃO CONCLUÍDO COM SUCESSO!")