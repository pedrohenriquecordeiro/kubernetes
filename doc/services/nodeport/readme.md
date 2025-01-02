# NodePort no Kubernetes

O NodePort é um tipo de serviço no Kubernetes que permite expor aplicações para acesso externo ao cluster. Ele disponibiliza um serviço em uma porta específica de todos os nós do cluster, tornando possível o acesso direto à aplicação de fora do ambiente Kubernetes.

Vamos então entender os principais campos do NodePort, seus comportamentos padrão e como configurá-lo, usando um exemplo prático baseado no YAML fornecido.

## Exemplo

![image](https://github.com/user-attachments/assets/777814f6-bc0a-4195-bc6b-2d0a4d7dac3f)


```yaml
# Criação de um namespace chamado "test"
apiVersion: v1       # Define a versão da API utilizada (v1 é a versão para Namespaces)
kind: Namespace      # Especifica que o recurso sendo criado é um Namespace
metadata:            
  name: test         # Nome do namespace: "test"
---
# Criação de um Pod no namespace "test"
apiVersion: v1       # Versão da API para Pods
kind: Pod            # Especifica que o recurso sendo criado é um Pod
metadata:
  name: web-pod      # Nome do Pod: "web-pod"
  namespace: test    # Namespace no qual o Pod será criado: "test"
  labels:            # Rótulos para identificação e seleção do Pod
    type: web-app    # Rótulo indicando que o Pod é do tipo "web-app"
spec: 
  containers:        # Define os containers que compõem o Pod
    - name: web-server-apache   # Nome do primeiro container: "web-server-apache"
      image: httpd              # Imagem do Apache HTTP Server
      ports:
        - containerPort: 80     # Porta exposta pelo container: 80
    - name: web-server-tomcat   # Nome do segundo container: "web-server-tomcat"
      image: tomcat             # Imagem do Tomcat
      ports:
        - containerPort: 8080   # Porta exposta pelo container: 8080
---
# Criação de um Service do tipo NodePort no namespace "test"
apiVersion: v1                   # Versão da API para Services
kind: Service                    # Especifica que o recurso sendo criado é um Service
metadata:
  name: frontend-service-nodeport # Nome do serviço: "frontend-service-nodeport"
  namespace: test                 # Namespace onde o serviço será criado: "test"
spec:
  type: NodePort                  # Tipo do serviço: NodePort, para acesso externo
  selector:                       # Define como identificar os Pods que o serviço gerencia
    type: web-app                 # Seleciona Pods com o rótulo "type=web-app"
  ports:                          # Configuração das portas do serviço
    - name: http                  # Nome da porta (opcional, útil para identificação)
      port: 80                    # Porta onde o serviço estará disponível internamente
      targetPort: 80              # Porta no container que receberá o tráfego (opcional)
      nodePort: 30003             # Porta externa no nó (opcional; sem ela, valor aleatório seria atribuído)
````

### Entendendo os Campos do NodePort
1.	port (Obrigatório):
Este campo define a porta interna em que o serviço estará acessível no cluster. No exemplo, o valor é 80.

2.	targetPort (Opcional):
Especifica a porta no container para onde o tráfego será redirecionado. Quando omitido, assume o mesmo valor de port.

3.	nodePort (Opcional):
Define a porta externa usada para acessar o serviço no nó do cluster. Quando omitido, o Kubernetes atribui automaticamente um valor entre 30000 e 32767.

4.	Comportamentos Padrão:
- targetPort: Assume o valor de port caso não seja definido.
- nodePort: Recebe um número aleatório dentro do intervalo permitido.

### Testando o Serviço com Minikube

Após aplicar o YAML, você pode verificar o acesso externo ao serviço usando o seguinte comando do Minikube:

```
minikube service --url frontend-service-nodeport --namespace=test
```
```
kubectl get nodes -o yaml | grep address
```
Este comando retorna uma URL que pode ser usada para acessar o serviço externamente. Para confirmar, execute um curl:
```
curl <URL_retornada_pelo_comando>
```
### Resumo

O NodePort é ideal para expor aplicações diretamente do cluster em cenários simples. Embora não seja a abordagem mais robusta para produção, é uma maneira eficaz de facilitar o acesso externo durante o desenvolvimento e testes. No exemplo fornecido, o serviço frontend-service-nodeport direciona o tráfego externo na porta 30003 para os containers Apache e Tomcat em execução nos Pods selecionados.
