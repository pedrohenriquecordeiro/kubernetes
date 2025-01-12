# Recurso Endpoints no Kubernetes

O recurso Endpoints no Kubernetes desempenha um papel crucial ao conectar um Service aos Pods ou recursos externos associados. Ele define uma lista de endereços IP e portas que correspondem aos endpoints de um Service. Diferentemente dos Services, os Endpoints fornecem um mapeamento direto para os endereços de rede subjacentes.

# O Que é um Endpoint?

Os Endpoints no Kubernetes são objetos que armazenam os endereços IP e as portas dos recursos associados a um Service. Esses recursos podem ser Pods executando no cluster ou serviços externos fora do ambiente Kubernetes. Quando um Service é criado, o Kubernetes automaticamente gera um objeto Endpoints correspondente, que é atualizado dinamicamente com base no seletor do Service e no estado atual dos Pods.

# Motivação
A principal motivação para criar um recurso Endpoints em vez de simplesmente confiar no Service é a necessidade de controle manual e flexibilidade adicional em cenários onde o comportamento padrão do Service não é suficiente ou adequado. Vamos explorar em profundidade os motivos e casos de uso em que Endpoints se tornam essenciais.

## O Comportamento do Service

No Kubernetes, um Service funciona como um ponto de acesso para os Pods, abstraindo a comunicação e fornecendo um único DNS estável, mesmo que os Pods subjacentes sejam escalados ou reiniciados. O Service gerencia dinamicamente seus próprios Endpoints com base nos Pods que correspondem ao seletor definido em sua configuração.

**Por exemplo**: Se um Service tiver o seletor app: nginx, ele automaticamente criará um recurso Endpoints que aponta para todos os Pods que têm o rótulo app: nginx.

# Quando o Recurso Endpoint é Necessário

Há casos em que o comportamento padrão do Service não atende às suas necessidades. Aqui estão os principais motivos para criar manualmente um recurso Endpoints:

## 1) Roteamento para Recursos Externos

Um Service padrão só pode direcionar tráfego para Pods dentro do cluster Kubernetes. No entanto, há cenários em que você precisa incluir IPs externos (por exemplo, um banco de dados externo, um serviço SaaS ou uma API de terceiros). Usar um recurso Endpoints permite adicionar esses IPs e associá-los a um Service Kubernetes.

Você pode criar um Endpoints manual que inclua o IP de um banco de dados fora do cluster:
```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: external-db
subsets:
  - addresses:
      - ip: 192.168.1.100  # IP de um banco de dados externo.
    ports:
      - port: 5432         # Porta do banco de dados PostgreSQL.
```

## 2) Recursos Sem Selectors

O comportamento dinâmico do Service depende de selectors para associar Pods ao Service. No entanto, em alguns casos:
 - Os Pods podem não usar rótulos, ou os rótulos podem ser inconsistentes.
 - Você deseja associar recursos específicos, como múltiplos Pods ou IPs externos, que não compartilham um rótulo comum.

Nesse caso, você pode definir um Endpoints manual e vinculá-lo ao Service, ignorando completamente os selectors.


## Exemplo
---
Este YAML ilustra como configurar um Endpoints manualmente e associá-lo a um Service quando não há selectors ou quando os Pods ou recursos não possuem rótulos consistentes. Vamos analisar cada parte:

#### Definição de Pods

```yaml
apiVersion: v1                        # Define a versão da API utilizada.
kind: Pod                             # Especifica que o recurso criado será um Pod.
metadata:
  name: pod-apache                    # Nome único do Pod (Apache).
spec:
  containers:                         # Lista de containers no Pod.
  - name: container-apache            # Nome do container no Pod.
    image: httpd                      # Imagem Docker para o servidor Apache.

---

apiVersion: v1                        # Define a versão da API utilizada.
kind: Pod                             # Especifica que o recurso criado será um Pod.
metadata:
  name: pod-nginx                     # Nome único do Pod (Nginx).
spec:
  containers:                         # Lista de containers no Pod.
  - name: container-nginx             # Nome do container no Pod.
    image: nginx                      # Imagem Docker para o servidor Nginx.

```

- Cria um Pod que executa o servidor Apache HTTP (httpd) e cria um Pod que executa o servidor Nginx (nginx). Não há rótulos associados aos Pods, o que torne impossível o uso de um seletor no Service para identificá-lo.



#### Definição de Endpoints
```yaml
apiVersion: v1                        # Define a versão da API utilizada.
kind: Endpoints                       # Especifica que o recurso criado será um Endpoints.
metadata:
  name: endpoint-service              # O nome do Endpoints deve ser idêntico ao nome do Service associado.
subsets:                              # Subsets definem os IPs e portas dos Endpoints.
  - addresses:                        # Lista de endereços IPs associados ao Endpoint.
      - ip: 10.244.0.9                # IP do Pod Apache.
      - ip: 10.244.0.11               # IP do Pod Nginx.
    ports:
      - port: 80                      # Porta do serviço para onde o tráfego será direcionado.
```
- Nome: O nome do Endpoints (endpoint-service) precisa corresponder ao nome do Service para que a associação seja estabelecida.
- Endereços:
    - Inclui IPs dos Pods (10.244.0.9 para Apache e 10.244.0.11 para Nginx).
- Porta: Define que os recursos associados estão disponíveis na porta 80.


#### Definição de Service
```yaml
apiVersion: v1                        # Define a versão da API utilizada.
kind: Service                         # Especifica que o recurso criado será um Service.
metadata:
  name: endpoint-service              # O nome do Service deve ser idêntico ao nome do Endpoints associado.
spec:
  ports:                              # Define as portas expostas pelo Service.
    - protocol: TCP                   # Especifica o protocolo usado.
      port: 80                        # Porta na qual o Service estará escutando.
      targetPort: 80                  # Porta para a qual o tráfego será direcionado.
```
- Nome: O nome do Service (endpoint-service) deve corresponder ao nome do Endpoints manual.
- Portas:
- O Service escuta na porta 80 e encaminha o tráfego para a mesma porta (targetPort: 80).

Objetivo: Este Service não usa selectors. Em vez disso, ele é associado ao Endpoints manual para direcionar o tráfego aos IPs especificados.

##### Por Que Usar Endpoints Manuais Aqui?
1. Falta de Selectors:
    - Os Pods (pod-apache e pod-nginx) não possuem rótulos. Um Service padrão não consegue identificar Pods sem rótulos usando selectors.
2. Controle Fino:
    - Permite especificar explicitamente quais IPs e portas devem ser associados ao Service, fornecendo maior controle sobre o tráfego.

##### Fluxo de Tráfego
 1. Um cliente faz uma solicitação para o DNS do Service (endpoint-service).
 2. O Service usa o Endpoints associado para roteá-lo para um dos IPs especificados:
 - 10.244.0.9 (Pod Apache).
 - 10.244.0.11 (Pod Nginx).

---

### Tutorial : Realizando uma Requisição ao DNS do Service no Kubernetes

Para verificar a resolução DNS e a conectividade com um Service no Kubernetes, podemos criar um Pod de teste e utilizar ferramentas como nslookup e curl. Este guia detalha os comandos, resultados esperados e a interpretação de cada etapa.

#### 1 - Criar um Pod de Teste com Debian

Crie um Pod temporário baseado na imagem Debian para executar os testes:
```
kubectl run -it --image debian pod-test
```
 - -it: Permite interatividade no terminal do Pod.
 - --image debian: Usa a imagem Debian como base.
 - pod-test: Nome do Pod criado.

#### 2 - Instalar Ferramentas Necessárias

No terminal do Pod, atualize os pacotes e instale as ferramentas dnsutils (para nslookup) e curl:
```
apt update && apt install dnsutils -y && apt install curl -y
```
 - dnsutils: Inclui ferramentas para resolver nomes DNS, como nslookup.
 - curl: Ferramenta para realizar requisições HTTP.

#### 3 - Verificar a Resolução DNS do Service

Execute o comando nslookup para resolver o nome DNS do Service:
```
nslookup endpoints-service
```
Resultado Esperado
```
root@test-eps:/# nslookup endpoints-service
Server: 10.96.0.10
Address: 10.96.0.10#53

Name: endpoints-service.default.svc.cluster.local
Address: 10.100.0.236
```
##### Interpretação:
1. Server: Mostra o endereço do servidor DNS interno do Kubernetes.
2. Name: Nome completo do Service no formato FQDN:
    - endpoints-service: Nome do Service.
    - default: Namespace onde o Service foi criado.
    - svc.cluster.local: Sufixo DNS padrão no Kubernetes.
3. Address: O endereço IP atribuído ao Service pelo Kubernetes (10.100.0.236 neste caso).

#### Fazer uma Requisição HTTP ao Service

Utilize o curl para realizar uma requisição HTTP ao DNS do Service:
```
curl endpoints-service.default.svc.cluster.local
```
Resultado Esperado
```
root@test-eps:/# curl endpoints-service.default.svc.cluster.local
<html><body><hl>It works!</hl></body></html>
root@test-eps:/#
```
##### Interpretação:
- A resposta HTML indica que a solicitação foi roteada com sucesso para um dos Endpoints associados ao Service (por exemplo, o Pod Apache ou Nginx no exemplo anterior).

##### Explicação do Fluxo
 1. DNS Interno do Kubernetes:
O Kubernetes fornece um servidor DNS interno que resolve o nome do Service para o IP do cluster atribuído ao Service.
 2. Resolução de DNS:
O comando nslookup endpoints-service verifica se o DNS está corretamente configurado e mapeado para o IP do Service.
 3. Roteamento do Service:
O Service utiliza os Endpoints para rotear a solicitação para um dos IPs definidos (como os IPs dos Pods ou IP externo no exemplo anterior).
 4. Requisição HTTP:
O curl envia uma requisição HTTP ao Service, que direciona o tráfego ao Endpoint correto. A resposta indica que o serviço subjacente (Apache ou Nginx) processou a solicitação.

---


## 3) Configuração Estática e Controle Fino

Os Services são dinâmicos por design. Eles monitoram os Pods correspondentes e atualizam automaticamente os Endpoints. Isso é ótimo para a maioria dos casos, mas pode não ser ideal quando você precisa de controle total ou configurações estáticas. Um recurso Endpoints manual oferece:
 - Consistência: Permite configurar manualmente IPs/portas, garantindo que o tráfego sempre vá para os destinos desejados.
 - Segurança: Limita quais recursos recebem tráfego, evitando seleção acidental de Pods indesejados.

## 4) Multiport Applications

Se você precisa associar diferentes combinações de IPs e portas, o recurso Endpoints permite especificar isso manualmente, algo que nem sempre é possível com Services padrão.

Exemplo:
```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: endpoint-service
subsets:
  - addresses:
      - ip: 10.244.0.10
    ports:
      - port: 80
  - addresses:
      - ip: 10.244.0.11
    ports:
      - port: 443
```
## 5) Solução de Problemas e Testes

Ao depurar ou testar aplicativos em um cluster Kubernetes, você pode querer substituir temporariamente o comportamento padrão de um Service. Criar e modificar manualmente um recurso Endpoints pode ser uma maneira rápida de redirecionar tráfego para destinos específicos sem alterar a configuração do Service.

# Diferenças Fundamentais: Endpoints vs. Service
| **Aspecto**              | **Service**                                                                                 | **Endpoints**                                                                                       |
|--------------------------|---------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| **Automação**             | Cria e gerencia automaticamente os Endpoints com base no seletor.                          | Configurado manualmente pelo usuário.                                                             |
| **IP externo**            | Não pode incluir IPs externos diretamente.                                                 | Permite definir IPs externos explicitamente.                                                      |
| **Seletores**             | Depende de selectors para vincular Pods ao Service.                                         | Não depende de selectors; IPs/portas são definidos manualmente.                                   |
| **Comportamento dinâmico**| Atualiza-se automaticamente com base no estado dos Pods.                                    | Estático; não muda automaticamente, mesmo que os Pods sejam alterados.                            |
| **Casos de uso**          | Ideal para conectar Pods dentro do cluster.                                                | Usado para recursos externos, configurações estáticas ou quando os Pods não têm rótulos consistentes. |

# Quando Não Criar Endpoints Manualmente

Você deve evitar criar Endpoints manuais quando:
1. O comportamento padrão do Service atende às suas necessidades. Por exemplo, quando os Pods têm rótulos bem definidos e estão dentro do cluster.
2. Os IPs são altamente dinâmicos. Se os Pods ou os recursos associados mudam frequentemente, confiar na configuração dinâmica do Service é melhor.
3. Manutenção a longo prazo: Configurações manuais de Endpoints podem ser difíceis de gerenciar em ambientes grandes ou altamente dinâmicos.

