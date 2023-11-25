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
O  [Minikube]([https://link-url-here.org](https://docs.altinity.com/altinitykubernetesoperator/kubernetesinstallguide/minikubeonlinux/) é uma ferramenta que facilita a execução local de clusters Kubernetes em um único nó para desenvolvimento e teste. Os drivers do Minikube são componentes que permitem sua execução em diferentes ambientes, como VirtualBox, VMware, Hyper-V e **Docker**, fornecendo uma camada de abstração para interagir com a infraestrutura subjacente.

Para inicializar o Minikube vamos utilizar o comando: ``` minikube start --driver=<DRIVER> ```
- Onde o driver vai depender de como foi sua instalação das dependências
- Você pode usar como driver: virtualbox, hyperv e docker
- Podemos testar o Minikube com: ```minikube status ```
