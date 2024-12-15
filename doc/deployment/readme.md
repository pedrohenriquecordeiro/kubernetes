# Deployment
Um **Deployment** no Kubernetes é como um plano de ação que você cria para gerenciar e implantar suas aplicações em um cluster k8s. Ele define o que você quer que o Kubernetes faça, como quantas réplicas de uma aplicação devem estar rodando, qual imagem do container deve ser usada, como lidar com atualizações entre outras configurações.

Na prática, o Deployment é o recurso mais comum no Kubernetes para gerenciar aplicações de forma automatizada. Ele cuida de criar e manter os pods necessários para rodar sua aplicação, garantindo que tudo esteja funcionando conforme o especificado.

## Como Funciona?
#### 1.	Criação:
Quando você cria um Deployment, ele gera automaticamente os pods necessários com base na configuração fornecida (via arquivo YAML). O Deployment garante que o número certo de réplicas esteja sempre rodando.
#### 2.	Gerenciamento:
O Kubernetes monitora os pods criados pelo Deployment. Se um pod parar de funcionar, ele recria outro automaticamente para manter o estado da aplicação.
#### 3.	Atualização:
Ao alterar a configuração do Deployment, como atualizar a imagem do container, o Kubernetes inicia um **rollout**, atualizando os pods gradualmente para evitar indisponibilidade.
#### 4.	Escalabilidade:
Com um único comando, você pode aumentar ou reduzir o número de réplicas para lidar com picos ou quedas de demanda.

## Exemplo de Uso
Imagine que você tenha uma aplicação web e precise rodar três instâncias dela no Kubernetes. Com um Deployment, você pode definir:
- A imagem do container da aplicação (por exemplo, nginx:1.23).
- O número de réplicas que quer manter (três, neste caso).
- Estratégias de atualização, como atualizações gradativas.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
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
          image: nginx:1.23
  
  selector:
    matchLabels:
      env: app

  replicas: 20
```
```shell
kubectl apply -f deployment.yaml && kubectl get all
```

O Kubernetes se encarrega de criar e gerenciar os três pods necessários. Se um deles falhar, ele cria outro automaticamente. Se você precisar atualizar para uma nova versão da aplicação, basta alterar no arquivo de Deployment, aplicar o ```kubectl apply``` novamente e o Kubernetes irá realizar o rollout da nova versão.



## Estratégias de Atualização

O Kubernetes permite duas principais estratégias de atualização para os Deployments:

#### RollingUpdate (padrão):
- Nesta estratégia, os pods antigos são substituídos gradualmente pelos novos, garantindo que a aplicação permaneça disponível durante a transição.
- O comportamento é controlado pelos parâmetros:
	- maxUnavailable: Determina a porcentagem ou o número máximo de pods que podem estar indisponíveis durante a atualização (padrão: 25%).
	- maxSurge: Define quantos pods extras podem ser criados além do número de réplicas desejadas (padrão: 25%).
Exemplo: Para um Deployment com 4 réplicas, até 1 pod pode estar indisponível e 1 pod adicional pode ser criado para acelerar a transição.

#### Recreate:
- Remove todos os pods existentes antes de criar os novos.
- Essa estratégia é útil quando as versões antiga e nova dos pods não podem coexistir, por exemplo, devido a conflitos de estado ou dependências exclusivas.
- Essa estratégia pode causar indisponibilidade temporária durante a atualização.

## Rollouts e Gerenciamento de Versões

Um **rollout** ocorre quando o Deployment aplica alterações, como a atualização da imagem de um container. O Kubernetes oferece ferramentas robustas para monitorar e gerenciar esses rollouts:

#### kubectl rollout status
Monitora o progresso de um rollout em tempo real, indicando se foi concluído com sucesso ou se há problemas.
	
Exemplo:
```shell
kubectl rollout status deployment.apps/frontend-deployment
```

#### kubectl rollout history
Exibe o histórico de rollouts, permitindo rastrear alterações no Deployment. No entanto, ele não reflete mudanças no número de réplicas.
  
Exemplo:
```shell
kubectl rollout history deployment.apps/frontend-deployment
```
Para detalhes de uma revisão específica:
```shell
kubectl rollout history deployment.apps/frontend-deployment --revision=1
```

#### kubectl rollout undo
Caso algo dê errado, é possível reverter para uma versão anterior do Deployment.

Exemplo:
```shell
kubectl rollout undo deployment.apps/frontend-deployment
```
Para reverter a uma revisão específica:
```shell
kubectl rollout undo deployment.apps/frontend-deployment --to-revision=5
```

## Criação e Gerenciamento de Réplicas

O Deployment utiliza **ReplicaSets** para garantir que o número desejado de pods esteja sempre em execução. Ele cria novos **ReplicaSets** durante o deploy e gerencia automaticamente o escalonamento ou a exclusão de pods para manter o estado desejado. Essa funcionalidade assegura que a aplicação esteja sempre disponível e pronta para lidar com mudanças na carga de trabalho.

## Inspeção de Recursos

Para obter informações detalhadas sobre o estado de um Deployment, o comando ```kubectl describe``` é uma ferramenta essencial. Ele exibe detalhes como eventos recentes, ReplicaSets associados e status atual do Deployment.

Exemplo:
```shell
kubectl describe deployment.apps/frontend-deployment
```

