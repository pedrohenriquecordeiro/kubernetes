# Gerenciamento de Recursos no Kubernetes

O gerenciamento de recursos no Kubernetes é fundamental para garantir que as aplicações utilizem os recursos de CPU e memória de forma eficiente e equilibrada nos nós do cluster. Ele envolve a definição de solicitações mínimas (requests) e limites máximos (limits) para cada container em um Pod, permitindo que o Kubernetes distribua cargas de trabalho de maneira inteligente e estável.

## O que são Recursos (Resources)?

Recursos no Kubernetes referem-se à quantidade de CPU e memória que um container pode consumir. Eles podem ser definidos no nível de cada container dentro de um Pod, mas a soma desses recursos reflete a demanda total do Pod. O escalador do Kubernetes garante que a somatória das solicitações (requests) de cada Pod não exceda a capacidade do nó onde ele está sendo agendado.

## Regras de Recursos do Pod:
1. Obrigatórios: Os recursos definidos no Pod são mandatórios e têm prioridade sobre configurações específicas do container.
2. Equilíbrio: O Kubernetes respeita as restrições de recursos para alocar Pods de maneira eficiente e evitar sobrecarga dos nós.

## Exemplo de YAML para Gerenciamento de Recursos

Aqui está um exemplo YAML que ilustra o gerenciamento de recursos em um Pod com dois containers:
```yaml
# Criação de um Namespace chamado "app"
apiVersion: v1                # Define a versão da API Kubernetes
kind: Namespace               # Tipo do recurso: Namespace
metadata:
  name: app                   # Nome do namespace: "app"
---
# Criação de um Pod no namespace "app"
apiVersion: v1                # Versão da API Kubernetes para Pods
kind: Pod                     # Tipo do recurso: Pod
metadata: 
  name: app-pod               # Nome do Pod: "app-pod"
  namespace: app              # Namespace onde o Pod será criado
spec: 
  containers:                 # Define os containers do Pod
  - name: apache-container    # Nome do primeiro container: "apache-container"
    image: httpd              # Imagem do Apache HTTP Server
    resources:                # Configuração de recursos para o container
      requests:               # Solicitação mínima de recursos
        cpu: "250m"           # 250 milicores de CPU (0.25 vCPU)
        memory: "64Mi"        # 64 Megabytes de memória
      limits:                 # Limite máximo de recursos
        cpu: "500m"           # 500 milicores de CPU (0.5 vCPU)
        memory: "128Mi"       # 128 Megabytes de memória

  - name: redis-container     # Nome do segundo container: "redis-container"
    image: redis              # Imagem do Redis
    resources:                # Configuração de recursos para o container
      requests:               # Solicitação mínima de recursos
        cpu: "500m"           # 500 milicores de CPU (0.5 vCPU)
        memory: "256Mi"       # 256 Megabytes de memória
      limits:                 # Limite máximo de recursos
        cpu: "1000m"          # 1000 milicores de CPU (1 vCPU)
        memory: "512Mi"       # 512 Megabytes de memória
```

## Requests e Limits: Gerenciando Recursos Efetivamente
1. Tag **Requests**:
Representa o mínimo de recursos garantido para o container. Durante o agendamento, o Kubernetes assegura que o nó escolhido tenha pelo menos os recursos solicitados disponíveis.
    - Exemplo: O apache-container solicita 250m de CPU e 64Mi de memória.
2. Tag **Limits**:
Representa o máximo de recursos que o container pode consumir. Se o container exceder esses limites, ele pode ser restringido ou interrompido, dependendo do recurso.
    - Exemplo: O redis-container está limitado a 1000m de CPU e 512Mi de memória.
3. Soma de Recursos no Pod:
A soma dos recursos de todos os containers define o total de recursos necessários para o Pod.
    - Exemplo:
        - CPU Total Solicitada: 250m + 500m = 750m
        - Memória Total Solicitada: 64Mi + 256Mi = 320Mi

## Unidade de Recursos: CPU e Memória
##### CPU
- 1 CPU equivale a um núcleo de um processador físico ou virtual.
    - Fracionado como milicores (m), onde 1000m = 1 CPU.
    - Exemplo: 250m é equivalente a 25% de 1 núcleo.
##### Memória
- Expressa em bytes, geralmente com as seguintes unidades:
    - Ki: Kibibytes (1 Ki = 1024 bytes).
    - Mi: Mebibytes (1 Mi = 1024 Ki).
    - Gi: Gibibytes (1 Gi = 1024 Mi).

## Como o Kubernetes Garante o Gerenciamento de Recursos?
1. Escalador do Kubernetes:
Antes de agendar um Pod, o Kubernetes verifica se o nó possui recursos disponíveis suficientes para acomodar a soma dos requests de CPU e memória de todos os containers.
2. Respeitando os Limites:
Durante a execução, o Kubernetes monitora os containers para garantir que eles não excedam os limites definidos. Caso excedam:
    - CPU: O container é estrangulado, limitando seu uso ao máximo permitido.
    - Memória: O container pode ser finalizado se consumir mais memória do que o limite definido.
