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

### Minikube
O  [Minikube](https://docs.altinity.com/altinitykubernetesoperator/kubernetesinstallguide/minikubeonlinux/) é uma ferramenta que facilita a execução local de clusters Kubernetes em um único nó para desenvolvimento e teste. Os drivers do Minikube são componentes que permitem sua execução em diferentes ambientes, como VirtualBox, VMware, Hyper-V e **Docker**, fornecendo uma camada de abstração para interagir com a infraestrutura subjacente.


- Para inicializar o Minikube vamos utilizar o comando: ```minikube start --driver=<driver>```
  - Onde o driver vai depender de como foi sua instalação das dependências
  - Você pode usar como driver: virtualbox, hyperv e *docker*
- Podemos testar o Minikube com: ```minikube status```
- Para **parar** o Minikube vamos utilizar o comando : ```minikube stop```

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖
- Para acessar ao dashboard do Kubernetes (Minikube) : ```minikube dashboard --url```
  - Nele podemos ver todo o detalhamento de nosso projeto: serviços, pods e etc.

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖ 
- O comando ```kubectl config view``` é usado para exibir a configuração do cliente Kubernetes. Ele mostra informações sobre os clusters, contextos e usuários configurados no arquivo de configuração do Kubernetes, que geralmente está localizado em ~/.kube/config.


## Deployment

- Com o Deployment criamos nosso serviço que vai rodar nos Pods
- Definimos uma imagem e um nome, para posteriormente ser replicado entre os servidores
- A partir da criação do deployment teremos containers rodando
- Precisamos de uma imagem no Hub do Docker, para gerar um Deployment

Para rodar um projeto no Kubernetes: 
- Vamos precisar de um **Deployment**, que é como submetemos os containers das aplicações aos Pods
- O comando é: ```kubectl create deployment <nome_deployment> --image=<nome_imagem>```
- Esse faz com que o projeto passe a ser orquestrado pelo Kubernetes

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

Para checar se o Deployment foi criado corretamente:
- ```kubectl get deployments```(Verifica o Deployment)
- ```kubectl describe deployment <nome-do-deployment>```(Obtem mais detalhes do Deployment)
- Para deletar um Deployment : ```kubectl delete deployment <nome-do-deployment>```

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

Para criar novas replicas (pods) devemos usar o comando (pode ser usado para diminuir o numero de replicas também):
```
kubectl scale deployment/<nome> --replicas=<numero>
```
Para acompanhar os status dos pods in live use o comando: ```kubectl get pods --watch``` ou ```kubectl describe  deployment <nome-do-deployment> | grep Replicas:```

Para checar o número de replicas: ```kubectl get rs```

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

Podemos **atualizar a imagem do deployment**, isso pode ser necessário caso seja necessário corrigir algum erro ou adicionar uma nova feature a aplicação.

Para isso usamos o comando : ``` kubectl set image deployment/<nome_deployment> <nome_antiga_imagem>=<nome_tag_nova_imagem>```

  * Note que devemos fazer o push da nova imagem para o docker hub com uma **nova tag** (para indicar nova versão)
  
  * Para descobrir o nome da <nome_antiga_imagem> user: ```kubectl describe deployment <nome_deployment> | grep Image:```

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

Podemos **desfazer alteração** realizadas no deployment

- Para desfazer uma alteração utilizamos uma ação conhecida como rollback;
- O comando para debugar uma alteração é: ```kubectl rollout status deployment/<nome_deployment>```
  - Com ele e com o ```kubectl get pods```, podemos identificar problemas
- Para voltar a alteração utilizamos: ```kubectl rollout undo deployment/<nome_deployment>```


## Pod
Um Pod no Kubernetes é a menor unidade executável na plataforma. Ele é uma abstração que representa um grupo de um ou mais contêineres compartilhando armazenamento e rede, e que são colocados e escalonados juntos em um nó do cluster. Os contêineres dentro de um Pod geralmente se comunicam e compartilham recursos. O conceito de Pod facilita a implantação e gerenciamento de aplicações compostas por múltiplos contêineres interdependentes.

Para verificar os Pods (onde os containers realmente são executados) utilizamos: 
- ```kubectl get pods```
- E para saber mais detalhes : ```kubectl describe pod <nome-do-pod>```
- Para deletar um pod : ```kubectl delete pod <nome-do-pod>```
- Para obter logs de um pod : ```kubectl logs <nome-do-pod>```




## Service
Um **service** é um recurso que define um conjunto lógico de pods e uma política por meio da qual eles **podem ser acessados**. 
Ele fornece uma abstração para os pods subjacentes, permitindo que outros serviços ou usuários se comuniquem com eles de maneira consistente, independentemente de sua localização exata na infraestrutura.

Existem diferentes tipos de serviços no Kubernetes, incluindo:

- ClusterIP: Expõe o serviço em um IP interno do cluster. É acessível apenas de dentro do cluster.
- NodePort: Expõe o serviço em um ponto fixo em cada nó do cluster. O serviço é acessível externamente usando o IP do nó e a porta designada.
- LoadBalancer: Provisionando um balanceador de carga externo para encaminhar o tráfego para o serviço.
- ExternalName: Mapeia o serviço para um nome externo (por exemplo, um registro DNS externo).

As aplicações do Kubernetes não tem conexão com o mundo externo, por isso precisamos criar um Service, que é o que possibilita **expor os Pods**. Isso acontece pois os Pods são criados para serem destruídos e perderem tudo, ou seja, os dados gerados neles também são apagados. Então o Service é uma entidade separada dos Pods, que expõe eles a uma rede.


- Para criar um serviço e expor nossos Pods devemos utilizar o comando:
  ```
    kubectl expose deployment <nome-do-deployment> --type=<tipo> --port=<porta>
  ```
  - Colocamos o nome do Deployment já criado
  - --port :  Este argumento especifica a porta no serviço. Ou seja, os clientes que se conectam ao serviço usarão esta porta.

    
- Listar Serviços: ```kubectl get services```
- Detalhes de um Serviço Específico:```kubectl describe service <nome-do-servico>```
- Excluir um Serviço:```kubectl delete service <nome-do-servico> ```

➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖

Após criar o service no kubernetes, devemos criar o serviço dentro do servidor do **minikube**:```minikube service <nome-service>```

Para listar os serviços dentro do cluster do Minikube: ```minikube service list```

