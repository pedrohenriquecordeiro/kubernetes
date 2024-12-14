
# ReplicaSet

O ReplicaSet no Kubernetes é um objeto que garante que uma quantidade específica de réplicas de um pod esteja rodando no cluster o tempo todo. Ele é como um “guarda” que verifica se o número de pods desejados está ativo e, caso algum falhe, o ReplicaSet cria automaticamente um novo para substituir.

## Como funciona?
-	Você define no manifesto YAML do ReplicaSet o número desejado de réplicas (por exemplo, 3).
- 	O Kubernetes cria esses 3 pods com base na especificação fornecida.
-	Se um dos pods parar de funcionar ou for excluído, o ReplicaSet detecta isso e inicia outro pod para manter o número configurado.

## Exemplo prático:

Imagine que você tem uma aplicação web e quer garantir que ela esteja sempre disponível com 3 instâncias rodando. Se um servidor falhar ou um pod for removido, o ReplicaSet criará outro automaticamente para garantir que sua aplicação não tenha interrupções.

```yaml
apiVersion: apps/v1 # Specifies the API version to use for this object (apps/v1 for ReplicaSet).
kind: ReplicaSet    # Declares the type of Kubernetes object being created (ReplicaSet).
metadata: 
  name: pod-frontend-replicaset # Name of the ReplicaSet, used to identify it.
  labels: 
    app: frontend               # Label to categorize the ReplicaSet, useful for selection and organization.

spec:
  template:                     # Defines the pod template (used to create the pods).
    metadata:
      name: pod_webserver       # Name of the pod (optional, usually defined by ReplicaSet automatically).
      labels:
        apps: app               # Label applied to the pods, used by the selector to manage them.
        tier: frontend          # Additional label to categorize the pod's role (e.g., frontend tier).
    spec:                       
      containers:               # Specifies the container(s) to run in the pod.
       - name: container        # Name of the container inside the pod.
         image: nginx           # Container image to use (nginx web server in this case).
  selector:                     # Determines which pods the ReplicaSet manages.
    matchLabels:
      apps: app                 # Matches pods with the "apps: app" label to ensure correct management.
  replicas: 4                   # Number of pod replicas that the ReplicaSet should maintain.
```


## Diferença entre ReplicaSet e Deployment:
-	O Deployment é um nível mais alto de abstração que usa internamente o ReplicaSet, mas também oferece funcionalidades adicionais, como atualizações e reversões.
-	Na maioria dos casos, você usará um Deployment, porque ele facilita gerenciar mudanças, enquanto o ReplicaSet puro é usado em casos mais específicos.

Em resumo, o ReplicaSet é como o “motor” que mantém seus pods sempre na quantidade certa dentro do cluster Kubernetes.
