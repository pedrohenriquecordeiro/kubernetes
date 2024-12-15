# Deployment
Um Deployment no Kubernetes é como um plano de ação que você cria para gerenciar e implantar suas aplicações em um cluster. Ele define o que você quer que o Kubernetes faça, como quantas réplicas de uma aplicação devem estar rodando, qual imagem do container deve ser usada, e como lidar com atualizações.

Na prática, o Deployment é o recurso mais comum no Kubernetes para gerenciar aplicações de forma automatizada. Ele cuida de criar e manter os pods (que são as unidades de execução dos containers) necessários para rodar sua aplicação, garantindo que tudo esteja funcionando conforme o planejado.

## Por Que Usar um Deployment?
•	Automação: Ele automatiza o processo de criar, escalar e atualizar pods.
•	Alta Disponibilidade: Se um pod falhar, o Deployment vai automaticamente substituí-lo por um novo.
•	Atualizações Controladas: Ele permite atualizações graduais ou completas, garantindo que sua aplicação continue funcionando enquanto novas versões são implantadas.

## Como Funciona?
### 1.	Criação:
Quando você cria um Deployment, ele gera automaticamente os pods necessários com base na configuração fornecida (geralmente em um arquivo YAML ou JSON). O Deployment garante que o número certo de réplicas esteja sempre rodando.
### 2.	Gerenciamento:
O Kubernetes monitora os pods criados pelo Deployment. Se um pod parar de funcionar, ele recria outro automaticamente para manter sua aplicação estável.
### 3.	Atualização:
Ao alterar a configuração do Deployment, como atualizar a imagem do container, o Kubernetes inicia um rollout, atualizando os pods gradualmente para evitar indisponibilidade.
### 4.	Escalabilidade:
Com um único comando, você pode aumentar ou reduzir o número de réplicas para lidar com picos ou quedas de demanda.

## Exemplo de Uso

Imagine que você tenha uma aplicação web e precise rodar três instâncias dela no Kubernetes. Com um Deployment, você pode definir:
•	A imagem do container da aplicação (por exemplo, nginx:1.23).
•	O número de réplicas que quer manter (três, neste caso).
•	Estratégias de atualização, como atualizações gradativas.
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

O Kubernetes se encarrega de criar e gerenciar os três pods necessários. Se um deles falhar, ele cria outro automaticamente. Se você precisar atualizar para uma nova versão da aplicação, basta alterar o Deployment, e o Kubernetes faz o rollout da nova versão.

## Benefícios do Deployment
•	Resiliência: Ele lida com falhas automaticamente, garantindo que sua aplicação esteja sempre disponível.
•	Flexibilidade: Você pode atualizar, escalar ou até reverter para versões anteriores facilmente.
•	Simplicidade: Ele abstrai muitos detalhes complexos do Kubernetes, facilitando a gestão de aplicações.

Em resumo, o Deployment é como um controlador que mantém sua aplicação em funcionamento no Kubernetes, cuidando de todos os detalhes necessários para que ela esteja sempre disponível, escalável e atualizada.
