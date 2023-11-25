#### O que é Kubernetes ?
Uma ferramenta de orquestração de containers
- Permite a criação de múltiplos containers em um cluster
- Gerencia serviços, garantindo que as aplicações sejam executadas sempre da mesma forma

#### Fundamentos
- Control Plane: servidor onde ocorre o gerenciamento do controle dos processos dos Nodes
- Nodes: máquinas que são gerenciadas pelo Control Plane (workers do docker swarm)
- Deployment: a execução de uma imagem/projeto em um Pod (docker run)
- Pod: um ou mais **containers** que estão executando (deployment) em um Node 
- Services: serviços que expõe os Pods ao mundo externo
- Kubectl: Cliente de linha de comando para o Kubernetes

#### Minikube
O  [Minikube](https://docs.altinity.com/altinitykubernetesoperator/kubernetesinstallguide/minikubeonlinux/) é uma ferramenta que facilita a execução local de clusters Kubernetes em um único nó para desenvolvimento e teste. Os drivers do Minikube são componentes que permitem sua execução em diferentes ambientes, como VirtualBox, VMware, Hyper-V e **Docker**, fornecendo uma camada de abstração para interagir com a infraestrutura subjacente.

Para inicializar o Minikube vamos utilizar o comando: ``` minikube start --driver=<DRIVER> ```
- Onde o driver vai depender de como foi sua instalação das dependências
- Você pode usar como driver: virtualbox, hyperv e docker
- Podemos testar o Minikube com: ```minikube status ```

Para stopar o Minikube vamos utilizar o comando : ``` minikube stop```

Para acessar ao dashboard do Kubernetes (Minikube) : ```minibuke dashboard --url```
- Nele podemos ver todo o detalhamento de nosso projeto: serviços, pods e etc.

O comando ```kubectl config view``` é usado para exibir a configuração do cliente Kubernetes. Ele mostra informações sobre os clusters, contextos e usuários configurados no arquivo de configuração do Kubernetes, que geralmente está localizado em ~/.kube/config.


#### Deployment

- Com o Deployment criamos nosso serviço que vai rodar nos Pods
- Definimos uma imagem e um nome, para posteriormente ser replicado entre os servidores
- A partir da criação do deployment teremos containers rodando
- Precisamos de uma imagem no Hub do Docker, para gerar um Deployment

Para rodar um projeto no Kubernetes: 
- Vamos precisar de um **Deployment**, que é como submetemos os containers das aplicações aos Pods
- O comando é: ```kubectl create deployment <nome> --image=<image>```
- Esse faz com que o projeto passe a ser orquestrado pelo Kubernetes

Para checar se o Deployment foi criado corretamente:
- ```kubectl get deployments``` (Verifica o Deployment)
- ```kubectl describe deployment <nome-do-deployment>``` (Obtem mais detalhes do Deployment)
- Para deletar um Deployment : ```kubectl delete deployment <nome-do-deployment>```

#### Pod
Um Pod no Kubernetes é a menor unidade executável na plataforma. Ele é uma abstração que representa um grupo de um ou mais contêineres compartilhando armazenamento e rede, e que são colocados e escalonados juntos em um nó do cluster. Os contêineres dentro de um Pod geralmente se comunicam e compartilham recursos. O conceito de Pod facilita a implantação e gerenciamento de aplicações compostas por múltiplos contêineres interdependentes.

Para verificar os Pods (onde os containers realmente são executados) utilizamos: 
- ```kubectl get pods```
- E para saber mais detalhes : ```kubectl describe pod <nome-do-pod>```
- Para deletar um pod : ```kubectl delete pod <nome-do-pod>```
- Para obter logs de um pod : ```kubectl logs <nome-do-pod>```



