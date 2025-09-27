### Passos para Execução

1.  **Clonar o Repositório:**

    ```bash
    git clone https://github.com/PedrinHm/Streaming-Analytics-Pipeline.git
    cd Streaming-Analytics-Pipeline
    ```

2.  **Configurar Variáveis de Ambiente:**
    Copie o arquivo de exemplo `.env.example` para um novo arquivo chamado `.env`. Os valores padrão já são suficientes para executar o projeto localmente.

    ```bash
    cp .env.example .env
    ```

3.  **Iniciar os Contêineres:**
    Este comando irá iniciar o container do banco de dados PostgreSQL e o servidor Jupyter Notebook em background.

    ```bash
    docker-compose up -d
    ```

## Estrutura do Projeto

  * `app/`: Contém os scripts Python (`ingestao.py`) e o Jupyter Notebook (`Visualizacao_de_Dados_Streaming.ipynb`) com as análises.
  * `Scripts_SQL/`: Contém os scripts SQL para a criação do schema, transformação/carga dos dados e limpeza final.
  * `docker-compose.yml`: Arquivo de orquestração que define e gerencia os contêineres do projeto (PostgreSQL, Python App e Jupyter).
  * `.env.example`: Template para as variáveis de ambiente necessárias para a conexão com o banco de dados.