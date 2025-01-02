# LoadBalancer no Kubernetes

O LoadBalancer é um tipo de serviço no Kubernetes que permite expor aplicações para acesso externo, distribuindo o tráfego entre os nós do cluster. Ele é amplamente utilizado em ambientes de produção devido à sua integração com provedores de nuvem, como AWS, GCP e Azure, que automaticamente provisionam um balanceador de carga externo.

## Como o LoadBalancer funciona?

Quando você cria um serviço do tipo LoadBalancer, o Cloud Controller Manager do Kubernetes se comunica com o provedor de nuvem configurado. Este componente solicita ao provedor que provisione um balanceador de carga externo, configure o tráfego para os nós do cluster e associe o IP externo gerado ao serviço.

Esse processo automatizado simplifica a configuração, especialmente em ambientes de nuvem. Diferentemente do NodePort, que expõe o serviço em uma porta específica de cada nó, o LoadBalancer oferece um ponto de acesso mais robusto e amigável para usuários finais.

## Exemplo

Abaixo está um exemplo de configuração para um serviço LoadBalancer:
```
# Criação de um namespace chamado "app"
apiVersion: v1                 # Versão da API Kubernetes para Namespaces
kind: Namespace                # Tipo do recurso: Namespace
metadata:                      
  name: app                    # Nome do namespace: "app"
---
# Criação de um Pod com dois containers no namespace "app"
apiVersion: v1                 # Versão da API Kubernetes para Pods
kind: Pod                      # Tipo do recurso: Pod
metadata:
  name: web-pod                # Nome do Pod: "web-pod"
  namespace: app               # Namespace onde o Pod será criado: "app"
  labels:                      # Rótulos para identificação do Pod
    type: web-app              # Rótulo indicando que o Pod é do tipo "web-app"
spec: 
  containers:                  # Define os containers dentro do Pod
    - name: web-server-apache  # Nome do primeiro container: "web-server-apache"
      image: httpd             # Imagem usada: Apache HTTP Server
      ports:
        - containerPort: 80    # Porta exposta pelo container: 80
    - name: web-server-tomcat  # Nome do segundo container: "web-server-tomcat"
      image: tomcat            # Imagem usada: Tomcat
      ports:
        - containerPort: 8080  # Porta exposta pelo container: 8080
---
# Criação de um Service do tipo LoadBalancer no namespace "app"
apiVersion: v1                 # Versão da API Kubernetes para Services
kind: Service                  # Tipo do recurso: Service
metadata:
  name: frontend-service-loadbalancer  # Nome do serviço: "frontend-service-loadbalancer"
  namespace: app              # Namespace onde o serviço será criado: "app"
spec:
  type: LoadBalancer           # Define o tipo do serviço como LoadBalancer
  selector:                    # Seleciona os Pods gerenciados por este serviço
    type: web-app              # Seleciona Pods com o rótulo "type=web-app"
  ports:                       # Configuração das portas
    - name: http               # Nome da porta (opcional, para identificação)
      port: 80                 # Porta acessível externamente pelo serviço
      targetPort: 80           # Porta no container para onde o tráfego será direcionado
      nodePort: 30003          # Porta fixa nos nós (utilizada internamente pelo LoadBalancer)
```
### Aplicando

```
kubectl apply -f main.yaml
```
Para apagar tudo: ```kubectl delete -f main.yaml```

#### Diferença entre LoadBalancer e NodePort
- NodePort:
	-	Exige acesso direto ao nó do cluster usando o IP e a porta específica configurada.
	-	Não inclui balanceador de carga externo.
	-	Ideal para testes e acesso simples fora do cluster.

-	LoadBalancer:
	-	Cria automaticamente um balanceador de carga externo no provedor de nuvem.
	-	Proporciona um ponto de acesso unificado, como um endereço IP público.
	-	É mais adequado para ambientes de produção onde usuários finais precisam acessar a aplicação.

### Relação com o Cloud Controller Manager

O Cloud Controller Manager é o componente do Kubernetes responsável por interagir com o provedor de nuvem. Ele realiza tarefas como:
-	Provisionar um balanceador de carga externo.
-	Atribuir um endereço IP externo ao serviço.
-	Configurar regras de tráfego para os nós do cluster.

Essa integração é fundamental para o funcionamento do LoadBalancer, automatizando a criação e a gestão de recursos externos no provedor de nuvem.
