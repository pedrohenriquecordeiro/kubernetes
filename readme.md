## O que é Kubernetes ?
Uma ferramenta de orquestração de containers
- Permite a criação de múltiplos containers em um cluster
- Gerencia serviços, garantindo que as aplicações sejam executadas sempre da mesma forma

### Fundamentos
- Control Plane: servidor onde ocorre o gerenciamento do controle dos processos dos Nodes
- Nodes: máquinas que são gerenciadas pelo Control Plane (workers do docker swarm)
- Deployment: a execução de uma imagem/projeto em um Pod (docker run)
- Pod: um ou mais **containers** que estão executando (deployment) em um Node 
- Services: serviços que expõe os Pods ao mundo externo
- Kubectl: Cliente de linha de comando para o Kubernetes


## Deployment

- Com o Deployment criamos nosso serviço que vai rodar nos Pods
- Definimos uma imagem e um nome, para posteriormente ser replicado entre os servidores
- A partir da criação do deployment teremos containers rodando
- Precisamos de uma imagem no Hub do Docker, para gerar um Deployment

Para rodar um projeto no Kubernetes: 
- Vamos precisar de um **Deployment**, que é como submetemos os containers das aplicações aos Pods
- O comando é: ```kubectl create deployment <nome_deployment> --image=<nome_imagem>```
- Esse faz com que o projeto passe a ser orquestrado pelo Kubernetes



## Pod
Um Pod no Kubernetes é a menor unidade executável na plataforma. Ele é uma abstração que representa um grupo de um ou mais contêineres compartilhando armazenamento e rede, e que são colocados e escalonados juntos em um nó do cluster. Os contêineres dentro de um Pod geralmente se comunicam e compartilham recursos. O conceito de Pod facilita a implantação e gerenciamento de aplicações compostas por múltiplos contêineres interdependentes.



## Service
Um **service** é um recurso que define um conjunto lógico de pods e uma política por meio da qual eles **podem ser acessados**. 
Ele fornece uma abstração para os pods subjacentes, permitindo que outros serviços ou usuários se comuniquem com eles de maneira consistente, independentemente de sua localização exata na infraestrutura.

Existem diferentes tipos de serviços no Kubernetes, incluindo:

- ClusterIP: Expõe o serviço em um IP interno do cluster. É acessível apenas de dentro do cluster.
- NodePort: Expõe o serviço em um ponto fixo em cada nó do cluster. O serviço é acessível externamente usando o IP do nó e a porta designada.
- LoadBalancer: Provisionando um balanceador de carga externo para encaminhar o tráfego para o serviço.
- ExternalName: Mapeia o serviço para um nome externo (por exemplo, um registro DNS externo).

As aplicações do Kubernetes não tem conexão com o mundo externo, por isso precisamos criar um Service, que é o que possibilita **expor os Pods**. Isso acontece pois os Pods são criados para serem destruídos e perderem tudo, ou seja, os dados gerados neles também são apagados. Então o Service é uma entidade separada dos Pods, que expõe eles a uma rede.


