# DaemonSet no Kubernetes

O DaemonSet é um recurso do Kubernetes projetado para garantir que cada node no cluster execute uma cópia de um pod específico. Ele é amplamente utilizado para tarefas contínuas, como coleta de logs, monitoramento e outros serviços essenciais. 

## O Que é um Daemon?

Um daemon é um programa que opera continuamente em segundo plano para executar tarefas específicas. No Kubernetes, o DaemonSet é baseado nesse conceito, garantindo que serviços como agentes de monitoramento ou armazenamento sejam executados em cada node do cluster.

## O Funcionamento do DaemonSet

O DaemonSet é vinculado diretamente aos nodes do cluster. Ele cria automaticamente um pod por node e continua criando novos pods em quaisquer novos nodes adicionados ao cluster. Caso um pod seja deletado, ele é recriado automaticamente.

### YAML
```yaml
apiVersion: apps/v1                 # Define a API utilizada para o DaemonSet.
kind: DaemonSet                     # Especifica que o recurso criado será um DaemonSet.
metadata:                           # Metadados do DaemonSet.
  name: daemonset                   # Nome do DaemonSet.
  labels:                           # Rótulos associados ao DaemonSet.
    app: frontend
spec:                               # Especificações do DaemonSet.
  template:                         # Template para os pods gerenciados pelo DaemonSet.
    metadata:                       # Metadados do pod.
      name: pod-web-server          # Nome do pod gerado (não obrigatório).
      labels:                       # Rótulos aplicados ao pod.
        apps: app
        tier: frontend
    spec:                           # Especificações do pod.
      containers:                   # Lista de containers no pod.
      - name: container-nginx       # Nome do container.
        image: nginx                # Imagem Docker usada pelo container.
  selector:                         # Define como selecionar os pods gerenciados.
    matchLabels:                    # Rótulos que os pods devem ter.
      apps: app
```
##### Explicação
 - O DaemonSet garantirá que o pod criado a partir do template seja executado em cada node disponível.
 - O campo selector define quais pods são gerenciados pelo DaemonSet.

#### Comandos Kubectl : DaemonSet

1. Comando: ```kubectl get nodes```
```
NAME           STATUS   ROLES           AGE     VERSION
minikube       Ready    control-plane   3d19h   v1.24.1
minikube-m02   Ready    <none>          99s     v1.24.1
minikube-m03   Ready    <none>          63s     v1.24.1
```

##### Explicação:
 - Lista todos os nodes no cluster.
 - O DaemonSet criará automaticamente um pod em cada node listado.

2. Comando: ```kubectl get ds```
```
NAME        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset   3         3         3       3            3           <none>         41s
```
##### Explicação:

Lista os DaemonSets no cluster Kubernetes e retorna os seguinte parametros:
 - DESIRED: Número de pods esperados (um por node).
 - CURRENT: Número de pods criados.
 - READY: Número de pods prontos para execução.
 - NODE SELECTOR: Indica restrições para quais nodes devem receber os pods (neste caso, nenhum).

3. Comando: ```kubectl get pods -o wide```
```
NAME              READY   STATUS    RESTARTS   AGE     IP           NODE           NOMINATED NODE   READINESS GATES
daemonset-n9zt5   1/1     Running   0          5m28s   172.17.0.2   minikube-m03   <none>           <none>
daemonset-t7xp6   1/1     Running   0          5m28s   172.17.0.4   minikube       <none>           <none>
daemonset-wl5m4   1/1     Running   0          5m28s   172.17.0.2   minikube-m02   <none>           <none>
```
##### Explicação:
 - Lista os pods.
 - Cada pod está rodando em um node diferente.
 - O campo NODE mostra em qual node o pod está sendo executado.

### DaemonSet vs Deployment
 - Um Deployment cria um número especificado de réplicas de pods e distribui essas réplicas entre os nodes disponíveis. Não cria automaticamente pods em novos nodes adicionados ao cluster.
 - O DaemonSet, por outro lado, garante a criação de um pod em cada node e continua criando novos pods automaticamente em novos nodes.


### DaemonSet Orphan Pods

Se o comando de *delete Daemon* com a flag a ```--cascade=orphan``` for executado, todos os pods criados pelo DaemonSet *daemonset* não serão deletados.
```shell
kubectl delete daemonset daemonset --cascade=orphan
```


### Adotar Pods com DaemonSet

Para que um DaemonSet adote pods já existentes, basta ajustar o campo *selector* no yaml para incluir os rótulos dos pods a serem adotados.

## Direcionando Pods para Nodes Específicos

Podemos restringir a criação de pods a nodes específicos usando o campo nodeSelector.

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemonset
  labels:
    app: frontend
spec:
  template:
    metadata:
      name: pod-web-server
      labels:
        apps: app
        tier: frontend
    spec:
      containers:
      - name: container-nginx
        image: nginx
      nodeSelector:                  # Restringe os pods a nodes com o rótulo especificado.
        daemonset: ds1               # Nome do rótulo.
  selector:
    matchLabels:
      apps: app
```

### Comandos
 1. Adicionar label ao node:
```shell
kubectl label nodes minikube-m02 daemonset=ds1
```

 2. Verificar os rótulos dos nodes:
```shell
kubectl get nodes --show-labels
```

 3. Após aplicar o YAML:

    - Execute ```kubectl get ds``` para listar os DaemonSets

    ```
    NAME        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
    daemonset   1         1         1       1            1           daemonset=ds1   93s
    ```
    Note o NODE SELECTOR configurado com a label definida.
    - Execute ```kubectl get pods -o wide``` para listar os pods criados
    ```
    NAME              READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
    daemonset-9hzs4   1/1     Running   0          22s   10.244.1.6   minikube-m02   <none>           <none>
    ```
    Note que o DaemonSet criou um unico pod no node *minikube-m02* especificado.

## Estratégias de Atualização
 1. RollingUpdate:
    - Atualiza os pods gradualmente.
    - maxUnavailable: Define o número máximo de pods indisponíveis durante a atualização.
 2. OnDelete:
    - Os pods antigos são atualizados apenas quando esse forem deletados manualmente.
