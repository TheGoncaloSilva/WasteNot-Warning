# WasteNot-Warning

Este projeto consiste em um sistema de alarme hipotético no qual possamos usar equipamentos, como câmaras, sensores, computadores que já tenhamos, ou de outras marcas, para integrarem o sistema.

# Autoria
Grupo p1g6:
* Gonçalo Silva, 103244
* Tiago Silvestre, 103554

# Requisitos
1. Um utilizador é caracterizado pelo seu nome, nível de permissão, data de nascimento, um identificador único, password, email e numero de telefone.

2. Existem 3 níveis de permissão, utilizador comum, administrador, utilizador externo

3.  Apenas utilizadores autenticados podem ter acesso ao sistema

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

