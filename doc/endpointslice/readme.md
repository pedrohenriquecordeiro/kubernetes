# **Entendendo EndpointSlices no Kubernetes**

Os **EndpointSlices** são uma evolução do recurso tradicional **Endpoints** no Kubernetes. Projetados para melhorar a escalabilidade e eficiência, os EndpointSlices dividem os endpoints de um Service em "fatias" menores, cada uma contendo um subconjunto dos endpoints. Este artigo explora as diferenças entre Endpoints e EndpointSlices, seus casos de uso e fornece exemplos para esclarecer o conceito.

---

## **EndpointSlices vs. Endpoints**

### **Semelhanças**
1. Ambos associam um **Service** a um ou mais endpoints, permitindo o roteamento de tráfego para os Pods ou outros recursos.
2. Os dois são gerados automaticamente pelo Kubernetes quando um Service é criado.

### **Diferenças**
| **Aspecto**               | **Endpoints**                                                         | **EndpointSlices**                                                   |
|---------------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|
| **Estrutura**             | Contém todos os endpoints em um único recurso.                       | Divide os endpoints em múltiplas fatias menores (slices).            |
| **Escalabilidade**        | Não é ideal para clusters grandes com muitos Pods/Services.          | Suporta grandes clusters, reduzindo a carga no etcd e no kube-apiserver. |
| **Tamanho Máximo**        | Não possui limite explícito; cresce de forma não gerenciável.        | Cada slice contém até 100 endpoints por padrão (configurável).       |
| **Atualizações**          | Todas as mudanças impactam o único objeto.                          | Alterações afetam apenas as fatias relevantes, melhorando a eficiência. |
| **Uso Padrão**            | Compatível, mas considerado legado em clusters modernos.            | Adotado como padrão em versões recentes do Kubernetes.               |

---

## **YAML de Exemplo**

Abaixo está um exemplo de um Service e dois EndpointSlices associados, demonstrando como o Kubernetes cria fatias de endpoints.

### **1. Service**
```yaml
apiVersion: v1                        # Define a versão da API para o Service.
kind: Service                         # Especifica que o recurso criado será um Service.
metadata:
  name: my-eps-service                # Nome do Service.
spec:
  ports:                              # Define as portas expostas pelo Service.
    - name: http                      # Nome da porta.
      port: 80                        # Porta que o Service escutará.
```

- **Explicação**: Este Service expõe a porta `80` e roteará tráfego para os endpoints especificados nos EndpointSlices.

---

### **2. Primeiro EndpointSlice**
```yaml
apiVersion: discovery.k8s.io/v1       # Define a API para EndpointSlices.
kind: EndpointSlice                   # Especifica que o recurso criado será um EndpointSlice.
metadata:
  name: my-eps                        # Nome do EndpointSlice.
  labels:
    kubernetes.io/service-name: my-eps-service # Associa o EndpointSlice ao Service.
addressType: IPv4                     # Tipo de endereço (IPv4 neste caso).
endpoints:                            # Lista de endpoints associados.
- addresses:
  - 10.244.0.10                       # Endereço IP do Apache.
ports:                                # Define as portas associadas ao endpoint.
- name: http                          # Nome da porta.
  port: 80                            # Porta que o endpoint escutará.
  protocol: TCP                       # Protocolo utilizado.
```

- **Explicação**: Este slice inclui o IP `10.244.0.10` (do Apache), vinculado ao Service `my-eps-service`.

---

### **3. Segundo EndpointSlice**
```yaml
apiVersion: discovery.k8s.io/v1       # Define a API para EndpointSlices.
kind: EndpointSlice                   # Especifica que o recurso criado será um EndpointSlice.
metadata:
  name: my-eps-2                      # Nome do EndpointSlice.
  labels:
    kubernetes.io/service-name: my-eps-service # Associa o EndpointSlice ao Service.
addressType: IPv4                     # Tipo de endereço (IPv4 neste caso).
endpoints:                            # Lista de endpoints associados.
- addresses:
  - 10.244.0.11                       # Endereço IP do Nginx.
ports:                                # Define as portas associadas ao endpoint.
- name: http                          # Nome da porta.
  port: 80                            # Porta que o endpoint escutará.
  protocol: TCP                       # Protocolo utilizado.
```

- **Explicação**: Este slice inclui o IP `10.244.0.11` (do Nginx), vinculado ao mesmo Service.

---

## **Por Que Usar EndpointSlices?**

1. **Escalabilidade**:
   - Em clusters grandes, um único recurso Endpoints pode sobrecarregar o etcd e o kube-apiserver.
   - EndpointSlices dividem o tráfego entre fatias menores, reduzindo o impacto.

2. **Melhor Gerenciamento**:
   - Atualizações afetam apenas a fatia correspondente, em vez de todo o conjunto de endpoints.

3. **Compatibilidade com IPv6**:
   - EndpointSlices suportam endereços IPv4 e IPv6 no mesmo cluster.

4. **Configurações Personalizáveis**:
   - O número máximo de endpoints por slice é configurável, permitindo ajustes baseados no ambiente.

---

## **10 Comandos Úteis para Gerenciar Endpoints**

1. **Listar Endpoints de um Service**:
   ```bash
   kubectl get endpoints my-eps-service
   ```

2. **Listar EndpointSlices de um Service**:
   ```bash
   kubectl get endpointslices -l kubernetes.io/service-name=my-eps-service
   ```

3. **Descrever um EndpointSlice**:
   ```bash
   kubectl describe endpointslice my-eps
   ```

4. **Visualizar todos os EndpointSlices no cluster**:
   ```bash
   kubectl get endpointslices
   ```

5. **Observar alterações em EndpointSlices em tempo real**:
   ```bash
   kubectl get endpointslices -w
   ```

6. **Filtrar EndpointSlices por namespace**:
   ```bash
   kubectl get endpointslices -n <namespace>
   ```

7. **Excluir um EndpointSlice**:
   ```bash
   kubectl delete endpointslice my-eps
   ```

8. **Criar EndpointSlices personalizados**:
   ```bash
   kubectl apply -f endpointslice.yaml
   ```

9. **Depurar conectividade com EndpointSlices**:
   ```bash
   kubectl exec -it <pod-name> -- curl <endpoint-ip>:<port>
   ```

10. **Exportar EndpointSlices para análise**:
    ```bash
    kubectl get endpointslices -o yaml > endpointslices.yaml
    ```

