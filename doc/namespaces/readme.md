# O Que São Namespaces no Kubernetes e Como Utilizá-los

Namespaces no Kubernetes são uma forma de organizar e isolar recursos dentro do cluster. 
Eles são úteis especialmente em ambientes compartilhados, onde múltiplos times ou aplicações convivem no mesmo cluster. 
Em vez de ter todos os recursos em um único espaço, os namespaces permitem criar *divisões lógicas* que facilitam a gestão e a separação de responsabilidades.

Por padrão, o Kubernetes vem com alguns namespaces já configurados. 
O namespace *default* é o mais comumente usado e onde os recursos são criados quando não especificamos um namespace. Além dele, existem outros namespaces padrão, como *kube-system*, que armazena recursos internos do cluster, e *kube-public*, que geralmente contém informações acessíveis publicamente. 
Há também o namespace *kube-node-lease*, relacionado a informações sobre os nós do cluster.

Um comando básico que trabalha com namespaces é o *kubectl get pods -n <namespace>*, que lista todos os pods dentro de um namespace específico. 
Por exemplo, para ver os pods no namespace *kube-system*, você pode executar:

```shell
kubectl get pods -n kube-system
```

Se você precisar criar recursos, como um deployment, em um namespace específico, pode fazer isso usando o parâmetro namespace no manifesto. 

```shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
  namespace: meu-namespace # :)
  labels:
    app: frontend

spec:
  template:
    metadata:
      name: nginx
      labels:
        env: app
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.14.2
  
  selector:
    matchLabels:
      env: app

  replicas: 20
```
```shell
kubectl apply -f deployment.yaml
```
Essa abordagem garante que os recursos definidos no arquivo de manifesto sejam associados ao namespace correto.

## Criando e Deletando Namespaces

A criação de um namespace no Kubernetes é simples e pode ser feita diretamente via linha de comando ou utilizando um arquivo de manifesto. 
Para criar um namespace chamado *meu-namespace*, você pode criar um arquivo de manifesto YAML, como este:
```yaml
apiVersion: v1
kind: Namespace

metadata:
  name: meu-namespace
  labels:
    apps: namespace-apps
```

E aplicar com:
```shell
kubectl apply -f namespace.yaml
```

Se precisar deletar um namespace, o comando é:
```shell
kubectl delete namespace meu-namespace
```

Este comando removerá o namespace e **todos os recursos associados** a ele, então deve ser usado com cuidado.

## Trabalhando com um Namespace como Default

Por padrão, o Kubernetes utiliza o namespace default, mas é possível alterar isso para um namespace de sua escolha. 
Você pode fazer isso usando o seguinte comando:
```shell
kubectl config set-context --current --namespace=meu-namespace
```

A partir desse comando, todos os comandos seguintes do kubectl que você executar irão operar no namespace especificado, sem necessidade de usar o parâmetro -n.

Por exemplo, se você configurar o namespace meu-namespace como default, o comando:
```shell
kubectl get pods
```
Será equivalente a:
```shell
kubectl get pods -n meu-namespace
```

## Um Exemplo Prático

Imagine que você está gerenciando um cluster compartilhado por dois times: time-dev e time-qa. 
Você decide criar dois namespaces para separar os recursos de cada time. Primeiro, você cria os namespaces com:
```yaml
apiVersion: v1
kind: Namespace

metadata:
  name: time-dev
  labels:
    apps: time-dev-apps
----
apiVersion: v1
kind: Namespace

metadata:
  name: time-qa
  labels:
    apps: time-qa-apps
```
```shell
kubectl apply -f namespace.yaml
```
Em seguida, cada time aplica seu deployment e pod no respectivo namespace:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
  namespace: time-dev # :)
  labels:
    app: frontend

spec:
  template:
    metadata:
      name: nginx
      labels:
        env: app
    spec:
      containers:
        - name: nginx-container
          image: nginx
  
  selector:
    matchLabels:
      env: app

  replicas: 2
```
```yaml
apiVersion: v1
kind: Pod

metadata:
 name: pod-webserver
 namespace: time-qa # :)
 labels:
  apps: app
  tier: frontend

spec:
 containers:
 - name: container-nginx
   image: nginx
```
```shell
kubectl apply -f deployment.yaml && kubectl apply -f pod.yaml 
```
Para listar os recursos do time-dev, você executa:
```shell
kubectl get all -n time-dev
```
E, se for comum trabalhar no namespace time-dev, você o define como default:
```shell
kubectl config set-context --current --namespace=time-dev
```

