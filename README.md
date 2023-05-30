# WasteNot-Warning

Este projeto consiste em um sistema de alarme hipotético no qual possamos usar equipamentos, como câmaras, sensores, computadores que já tenhamos, ou de outras marcas, para integrarem o sistema.

# Autoria

Grupo p1g6:

* Gonçalo Silva, 103244
* Tiago Silvestre, 103554

# Tecnologias Usadas

As seguintes tecnologias foram usadas neste projeto:
 * Frontend: [VUEjs](https://vuejs.org/) 
 * Backend: Python [Flask](https://flask.palletsprojects.com/en/2.3.x/)
 * Base de Dados: [Microsoft Sql Server](https://www.microsoft.com/en-us/sql-server)
 * Ambiente: [Docker](https://www.docker.com/)

# Sistema Operativo utilizado

Esta plataforma foi desenvolvida e testada para executar em Ubuntu 22.04, configurações extras podem ter de ser efetuadas para suporte de outros Sistemas Operativos.

# Configuração

Antes de continuar com a execução, vai ser preciso ter as ferramentas Docker e Docker compose na sua máquina. Caso não as tenha, for favor siga as instruções em [get docker](https://docs.docker.com/get-docker/) e [install compose](https://docs.docker.com/compose/install/).

Após ter as ferramentas instaladas, execute o comando:
```bash
docker compose build
```

Para construir o ambiente docker, com todas as dependências e serviços.

# Execução

Para executar a plataforma, execute o comando:
```bash
docker compose up
```

**Nota**: Para reiniciar a base de dados, pode tirar partido de um script para esse efeito, por executar o comando com a seguinte Flag:
```bash
DB_RESET_FLAG=true docker compose up
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

# Requisitos

1. Um utilizador é caracterizado pelo seu nome, nível de permissão, data de nascimento, um identificador único, password, email e numero de telefone.
2. Existem 3 níveis de permissão, utilizador comum, administrador, utilizador externo
3. Apenas utilizadores autenticados podem ter acesso ao sistema
4. Um administrador tem acesso a tudo.
5. Apenas certos dispositívos podem aceder ao sistema para efetuar alterações ou visualizar informação. Esses sistemas são adicionados pelo administrador e caraterizados pelo fabricante, modelo, numero MAC e endereço IP
6. Dispositivos de segurança são caracterizados por um tipo, área restrita a que pertencem, numero MAC e endereço IP, fabricante, modelo, estado (Ligado/Desligado).
7. Os tipos possiveis de dispositivos de segurança são portões, portas, cameras de vigilancia, sensores de movimento, alarmes
8. Eventos em dispositivos de segurança devem ser registados, guardando-se a data,hora e tipo de evento que ocorreu, qual utilizador utilizou o dispositivo.
9. Os tipos possíveis de eventos são abrir, fechar,deteção de movimento, ativação de alarme
10. Cada área restrita é caracterizada por uma localização, descrição, utilizadores que a podem aceder.
11. Uma área restrita tem uma lista de utilizadores que devem ser contactados em caso de emergencia, caso hajam vários cada um tem um horário em que podem ser contactados (tipo ter vários seguranças por turnos), código de utilização de dispositivos
12. Uma área restrita pode ser configurada para ter dias da semana, com hora de inicio e de fim, recorrentes em que os dispositivos estão ativos em modo de monitorização (Não acionam o alarme). Também deve ser possível colocar essa regra ativa ou inativa.
13. Deve ser possível configurar dias de exclusão para as alturas de funcionamento (data/hora inicio e fim).
14. Dispositivos podem sofrer manutenções, a uma manutenção está associada uma área restrita, sendo caracterizada pela data de inicio, data de fim, estado, comentários (opcional) e uma lista de  utilizadores externos (mandatório).

# Diagramas
Com base nos requisitos e nas necessidades do sistema, modelámos os seguintes diagramas:

## Diagrama Entidade-Relacionamento

Diagrama DER ![DER diagram](./documentation/WasteNot_Warning_DER.jpg)

# Esquema Relacional

Esquema Relacional ![esquema relaciona](./documentation/WasteNot_Warning_Relational_Diagram.jpg)

# SQL Scripts

De forma a tornar o nosso sistema mais modular, decidimos colocar os vários elements SQL em ficheiros separados. Para os executar todos juntos e popular a base de dados, fazemos uso da funcionalidade descrita na secção de *Execução*.

## Modelação tabela

## Inserts

## Update

## Delete

## Drop

## Queries

## User Defined Functions

## Stored Procedures

## Views

## Triggers

## Indexes

## Paginação

## Transaction Flow

## Login

# Funcionalidades e Descrição

## Login

* Habilidade de fazer login e manter sessão, usando alguma espécie de encriptação na base de dados (Criar script para pegar em dummy password e encriptá-las)

## Dashboard

* Armar, Desarmar e Informar ao utilizador que o alarme foi acionado
* Gráfico de Donut:
  * Número Total de eventos (SELECT normal)
  * Número Total de eventos ocorridos em horário de exclusão (SP)
  * Número Total de eventos ocorridos em horário de manutenção
  * Número Total de eventos que acionaram o sistema
* Gráfico de Tarte:
  * Número de Eventos por tipo
* Gráfico de linhas:
  * Eventos ordenados por data de adição (SELECT normal)
  * Eventos ordenados por data ocorridos em horário de exclusão
  * Eventos ordenados por data ocorridos em horário de manutenção
  * Eventos ordenados por data que acionaram o sistema
* Informação se o sistema se encontra em manutenção e quais as áreas afetadas, bem como o estado da manutenção (SELECT das manutenções, com Join das áreas e do estado da manutenção)
* Informação das próximas manutenções e a que áreas (VIEW)
* Lista dos ultimos eventos e informação a indicar qual é o seu status, como manutenção, fora de horário, "importante" (VIEW)
* CRUD para dispositivos de acesso?

## Users

* CRUD os utilizadores, com permissões
* (CRUD as permissões de utilizadores)?
* CRUD para áreas que pertencem a utilizadores
* CRUD para áreas que contactam utilizadores

## Eventos

* Listar, com funcionalidade de filtração
  * Eventos dentro de horário de manutenção
  * Eventos dentro de horário de exclusão
  * Eventos dentro de horário de "trabalho"
  * Eventos pertencentes a utilizadores
  * Tipos de evento

## Exclusões

* Dispositivos e Áreas restritas (Ficam apenas definidos com dados pré-populados)

## Geral

* Quando inserido um registo de eventos, tem de ser verificado o tipo e é de um dispositivo que pertence a uma área restrita, se for. O sistema tem de verificar se está dentro das regras para ser acionado (dentro do horário da área e fora de exclusão ou manutenção), se estiver, aciona (trigger)
* Temos que ter uma aplicação (CLI) externa para falsificar a ocorrência de um evento por um dispositivo
* **Trigger** para quando se adiciona um evento, se o timestamp não for fornecido, ele preencher sozinho (Ou se for fornecido um no futuro, substituir pelo atual ou não executar)
* Script para carregar a base de dados inteira para o docker
* **Trigger** para garantir que as datas (por exemplo nas manutençoes) de inicio e fim são corretas (Inicio < Fim)
* 1 dispositivo só pode pertencer a uma e uma só area restrita
* Um horário de exclusão só pode estar associado a uma área restrita, se estiver dentro do horário de monitorização da mesma (Trigger)

## Ferramentas a incorporar

* View
* Index
* Cursor
* Batches
* Stored Procedures
* UDF
* Trigger
