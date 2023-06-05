# Relatório Complementar

Este relatório serve como complemento ao relatório [principal](./README.md).

# Tecnologias Usadas

As seguintes tecnologias foram usadas neste projeto:

* Frontend: [VUEjs](https://vuejs.org/)
* Backend: Python [Flask](https://flask.palletsprojects.com/en/2.3.x/)
* Base de Dados: [Microsoft Sql Server](https://www.microsoft.com/en-us/sql-server)
* Ambiente: [Docker](https://www.docker.com/)

# Sistema Operativo utilizado

Esta plataforma foi desenvolvida e testada para executar em Ubuntu 22.04, configurações extras podem ter de ser efetuadas para suporte de outros Sistemas Operativos.

# Organização das pastas

```
.
├── documentation                   # ficheiros de documentação  
├── src                             # ficheiros de código fonte
│   ├── back                        # ficheiros de código fonte para a API
│   ├── database                    # ficheiros com o código da base de dados
│   └── front                       # pasta de conteúdo relacionado com o frontend
│       └── src                     # pasta contendo um conjunto de pastas relacionadas com o frontend
│           |── pages               # ficheiros de código que representam as páginas visiveis ao utilizador
│           |── services            # pasta com os servicços do projeto
│               └── backend-api     # pasta com os endpoints to frontend para ligar à API
│           └── ...
└── ...
```

Queremos salientar:

* a pasta `src/back` que contém os ficheiros da API
* o ficheiro `src/front/src/pages/backend-api/backend-api.ts`, que contém o código de pedidos às API
* as pastas `src/front/src/pages/admin/dashboard`, `src/front/src/pages/admin/restricted-areas` e `src/front/src/pages/admin/users` que contém o código das páginas de UI que foram desenvolvidas, includindo a chamada às funções que comunicam com a API

# Configuração

Antes de continuar com a execução, vai ser preciso ter as ferramentas Docker e Docker compose na sua máquina. Caso não as tenha, for favor siga as instruções em [get docker](https://docs.docker.com/get-docker/) e [install compose](https://docs.docker.com/compose/install/).

Após ter as ferramentas instaladas, execute uma das seguintes opções.

### Desenvolvimento

Com esta configuração o sistema usará a base de dados local do Docker.

```bash

docker compose build

```

### Produção

Com esta configuração o sistema usará a base de dados de produção, localizada no IEETA.

```bash

docker compose -f docker-compose-prod.yml build

```

Para construir o ambiente docker, com todas as dependências e serviços.

# Execução

Para executar a plataforma, execute uma das seguintes opções

### Desenvolvimento

Com esta configuração o sistema usará a base de dados local do Docker.

```bash

docker compose up

```

### Produção

Com esta configuração o sistema usará a base de dados de produção, localizada no IEETA.

```bash

DB_RESET_FLAG=true docker compose -f docker-compose-prod.yml up

```

**Nota**: Para reiniciar a base de dados, pode tirar partido de um script para esse efeito, por executar o comando com a seguinte Flag:

```bash

DB_RESET_FLAG=true <opcao_de_execucao (docker compose...)>

```

### Primeira execução

Na primeira execução, execute primeiro só o container só com o sql server:

```bash

docker compose up sql-server

```

Executando em seguida o comando para reiniciar a base de dados:

```bash

DB_RESET_FLAG=true docker compose up

```

# Interação entre o backend e a interface

O backend (flask) disponibiliza vários endpoints, sempre que o frontend pede informação ao backend estes endpoints são utilizados. Cada endpoint é capaz de aceder à base de dados, obtendo assim informações de forma segura. Os endpoints estão no ficheiro `src/back/App.py`. Para comunicação entre a API e o frontend, estes endpoints da API são usados em conjunção com os do frontend, localizados na pasta `src/front/src/services/backend-api`.

A filtragem de dados, pesquisas são sempre feitas pelas queries da base de dados, ou seja a interface só mostra informação proveniente destes endpoints.

# Template

Como referido no [README](./src/front/README.md) na pasta do frontend, nós optámos por usar um template de VueJs com bastantes components já criados e construímos os nós desenvolvimentos "por cima".
