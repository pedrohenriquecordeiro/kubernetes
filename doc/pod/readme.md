# Pods no Kubernetes

Os Pods são o menor e mais básico objeto de execução no Kubernetes. Eles representam uma instância de execução de um ou mais containers no cluster. Todo aplicativo executado no Kubernetes roda dentro de um pod. 

## O Que é um Pod?

Um pod é a unidade mínima de implantação no Kubernetes. Ele pode conter um único container ou múltiplos containers que compartilham os mesmos recursos, como rede e volumes. Embora o uso mais comum seja um único container por pod, múltiplos containers podem ser utilizados para cenários onde há uma relação muito próxima entre eles, como um container principal e um auxiliar (sidecar).

### Exemplo Básico de Pod

Abaixo, temos um exemplo simples de YAML para criar um pod que executa um container do Nginx:
```yaml
apiVersion: v1                   # Define a versão da API usada para o recurso.
kind: Pod                        # Especifica que o recurso criado será um Pod.
metadata:                        # Metadados associados ao pod.
  name: pod-webserver            # Nome do pod.
  labels:                        # Rótulos do pod para identificação.
    apps: app
    tier: frontend
spec:                            # Especificações do pod.
  containers:                    # Lista de containers dentro do pod.
  - name: container-nginx        # Nome do container.
    image: nginx                 # Imagem Docker usada pelo container.
```
##### Explicação
 - apiVersion: Define a API usada para descrever o recurso (neste caso, um pod).
 - kind: Especifica que o objeto criado será um pod.
 - metadata: Contém informações como o nome do pod e rótulos para sua identificação.
 - spec: Define as especificações do pod, incluindo os containers que ele contém.
 - containers: Lista os containers dentro do pod, com nome e a imagem que será utilizada.

### Direcionando o Pod para um Nó Específico

#####  Utilizando nodeName

O campo nodeName no YAML pode ser usado para direcionar o pod para um nó específico. Isso é útil para alocar workloads em nós que possuem características específicas, como GPUs ou alto poder de processamento.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-webserver
  labels:
    apps: app
    tier: frontend
spec:
  containers:
  - name: container-nginx
    image: nginx
  nodeName: minikube-m02          # Nome do nó onde o pod será executado.
```

Nota:
 - O nome do nó deve ser conhecido e informado diretamente.
 - Este método é estático, ou seja, o pod será sempre agendado no nó especificado.

#### Utilizando nodeSelector

O campo nodeSelector permite direcionar pods para nós com base em rótulos. Diferentemente de nodeName, ele é mais flexível, pois permite o uso de rótulos genéricos para definir a elegibilidade de um nó.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-webserver
  labels:
    apps: app
    tier: frontend
spec:
  containers:
  - name: container-nginx
    image: nginx
  nodeSelector:                   # Define critérios de seleção do nó.
    tier: frontend-node           # Rótulo do nó onde o pod será executado.
```

#### Configuração dos Rótulos do Nó

Para usar nodeSelector, o nó deve ter um rótulo correspondente. Isso pode ser feito com o comando:
```shell
kubectl label nodes <nome-do-node> tier=frontend-node
```
Para remover o rótulo: ```kubectl label nodes <nome-do-node> tier-```

###### Quando Usar Cada Método?
 - nodeName: Ideal para cenários onde o nó exato é conhecido e você deseja controle total.
 - nodeSelector: Útil para balancear cargas ou aplicar critérios dinâmicos baseados em rótulos.

## Pods no Contexto do Kubernetes

Os pods são fundamentais para o Kubernetes e servem como base para outros objetos, como Deployments, ReplicaSets e DaemonSets. Eles oferecem uma camada de abstração sobre containers, permitindo que o Kubernetes gerencie a alocação de recursos e a comunicação entre os componentes do cluster.