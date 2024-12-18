# O Que São Namespaces no Kubernetes e Como Utilizá-los

Namespaces no Kubernetes são uma forma de organizar e isolar recursos dentro do cluster. 
Eles são úteis especialmente em ambientes compartilhados, onde múltiplos times ou aplicações convivem no mesmo cluster. 
Em vez de misturar todos os recursos, como pods, serviços e volumes, em um único espaço, os namespaces permitem criar *divisões lógicas* que facilitam a gestão e a separação de responsabilidades.

Por padrão, o Kubernetes vem com alguns namespaces já configurados. 
O namespace *default* é o mais comumente usado e onde os recursos são criados quando não especificamos um namespace. Além dele, existem outros namespaces padrão, como *kube-system*, que armazena recursos internos do cluster, e *kube-public*, que geralmente contém informações acessíveis publicamente. 
Há também o namespace *kube-node-lease*, relacionado a informações sobre os nós do cluster.

Um comando básico para trabalhar com namespaces é o *kubectl get pods -n <namespace>*, que lista todos os pods dentro de um namespace específico. 
Por exemplo, para ver os pods no namespace *kube-system*, você pode executar:

```shell
kubectl get pods -n kube-system
```

Se você precisar criar recursos, como um deployment, em um namespace específico, pode fazer isso usando o parâmetro --namespace. 
Um exemplo seria aplicar um arquivo de manifesto ao namespace *prod*:

```shell
kubectl apply -f deployment.yaml --namespace=prod
```

Essa abordagem garante que os recursos definidos no arquivo de manifesto sejam associados ao namespace correto.

## Criando e Deletando Namespaces

A criação de um namespace no Kubernetes é simples e pode ser feita diretamente via linha de comando ou utilizando um arquivo de manifesto. 
Para criar um namespace chamado *meu-namespace*, basta executar:
```shell
kubectl create namespace meu-namespace
```
Alternativamente, você pode criar um arquivo de manifesto YAML, como este:
```yaml
apiVersion: v1
kind: Namespace

metadata:
  name: meu-namespace
  labels:
    apps: namespace-apps
```

E aplicar esse arquivo com:
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
```shell
kubectl create namespace time-dev
kubectl create namespace time-qa
```
Em seguida, cada time aplica seus deployments no respectivo namespace, como este exemplo para o time-dev:
```shell
kubectl apply -f deployment-dev.yaml --namespace=time-dev
```
```shell
kubectl apply -f deployment-qa.yaml --namespace=time-qa
```
Para listar os pods do time-dev, você executa:
```shell
kubectl get pods -n time-dev
```
E, se for comum trabalhar no namespace time-dev, você o define como default:
```shell
kubectl config set-context --current --namespace=time-dev
```

## A Importância de Usar Arquivos Manifestos no Kubernetes

Embora seja possível criar e gerenciar recursos no Kubernetes diretamente pela linha de comando, o uso de arquivos manifesto traz uma série de vantagens, especialmente em ambientes de produção ou em times que colaboram no mesmo cluster. 
Manifestos YAML fornecem uma forma declarativa e reutilizável de gerenciar recursos, permitindo versionamento, revisão e automação com ferramentas como Git e CI/CD.

Ao definir recursos em um arquivo manifesto, você obtém uma visão clara do estado desejado do recurso, o que torna a configuração mais previsível e fácil de replicar em diferentes ambientes, como desenvolvimento, homologação e produção. 
Além disso, é possível especificar diretamente no manifesto qual namespace o recurso deve utilizar, garantindo que ele seja isolado corretamente e evitando erros manuais que podem ocorrer ao esquecer de adicionar o parâmetro ```--namespace``` em comandos kubectl.

### Exemplo de Criação de um Pod e um Deployment com Namespace no YAML

Abaixo está um exemplo de como criar um Pod e um Deployment em um namespace específico diretamente no arquivo YAML.


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: meu-pod
  namespace: meu-namespace # :)
  labels:
    app: minha-aplicacao
spec:
  containers:
  - name: meu-container
    image: nginx:latest
    ports:
    - containerPort: 80
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-deployment
  namespace: meu-namespace # :)
  labels:
    app: minha-aplicacao
spec:
  replicas: 3
  selector:
    matchLabels:
      app: minha-aplicacao
  template:
    metadata:
      labels:
        app: minha-aplicacao
    spec:
      containers:
      - name: meu-container
        image: nginx:latest
        ports:
        - containerPort: 80
```
### Aplicando os Manifestos

Para aplicar esses recursos no Kubernetes, basta executar:
```shell
kubectl apply -f pod.yaml &&
kubectl apply -f deployment.yaml
```



### Verificando os Recursos

Após aplicar os manifestos, você pode listar os recursos criados no namespace com:
```shell
kubectl get pods -n meu-namespace &&
kubectl get deployments -n meu-namespace
```
