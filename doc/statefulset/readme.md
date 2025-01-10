# StatefulSet no Kubernetes

O StatefulSet é um recurso no Kubernetes projetado para gerenciar aplicativos com requisitos de identidade estável, armazenamento persistente e ordens específicas de implantação e atualização. Ele é amplamente utilizado em bancos de dados, sistemas distribuídos e serviços que exigem persistência.

## O Que é um StatefulSet?

Um StatefulSet é semelhante a um Deployment, mas com diferenças importantes que garantem a estabilidade e persistência dos pods. Ele oferece:
 1. Identificadores únicos para pods.
 2. Volumes persistentes para armazenamento de dados.
 3. Implantação, escalonamento e atualização ordenadas.

## YAML

Aqui está um exemplo básico de StatefulSet e Service:

### Service para StatefulSet
```yaml
apiVersion: v1                      # Define a versão da API utilizada.
kind: Service                       # Especifica que o recurso criado será um Service.
metadata:
  name: service-statefulset         # Nome do Service.
spec:
  ports:                            # Lista de portas expostas.
  - port: 80                        # Porta que o serviço irá expor.
  clusterIP: None                   # Define o serviço como headless (sem IP fixo).
  selector:                         # Seleciona os pods gerenciados pelo Service.
    app: nginx-pod                  # Rótulo que os pods devem ter.
```
##### Explicação
O Service headless (clusterIP: None) é necessário para StatefulSets, pois fornece uma resolução de DNS estável para cada pod.

### StatefulSet
```yaml
apiVersion: apps/v1                 # Define a versão da API utilizada.
kind: StatefulSet                   # Especifica que o recurso criado será um StatefulSet.
metadata:
  name: statefulset                 # Nome do StatefulSet.
spec:
  podManagementPolicy: OrderedReady # Define que os pods serão implantados em ordem.
  selector:                         # Seleciona os pods gerenciados pelo StatefulSet.
    matchLabels:
      app: nginx-pod                # Rótulo que os pods devem ter.
  serviceName: "service-statefulset" # Nome do Service associado.
  replicas: 3                       # Número de réplicas (pods) gerenciadas.
  template:                         # Modelo para os pods gerenciados pelo StatefulSet.
    metadata:
      labels:
        app: nginx-pod              # Rótulos aplicados aos pods.
    spec:
      containers:
      - name: nginx-container       # Nome do container.
        image: nginx:1.23.1         # Imagem Docker utilizada.
        volumeMounts:               # Monta volumes persistentes no container.
        - name: persistent-volume   # Nome do volume.
          mountPath: /usr/share/nginx/html # Caminho no container.
  volumeClaimTemplates:             # Templates para PersistentVolumeClaims.
  - metadata:
      name: persistent-volume       # Nome do PersistentVolumeClaim.
    spec:
      accessModes: ["ReadWriteOnce"] # Define os modos de acesso.
      resources:
        requests:
          storage: 128Mi            # Define o tamanho do volume solicitado.
```

## Principais Conceitos e Recursos do StatefulSet

#### Uniqueness of Pods Identifier

Os pods gerenciados pelo StatefulSet possuem identificadores únicos no formato ```<statefulset-name>-<ordinal>```. 
Por exemplo:
 - Para um StatefulSet chamado statefulset, os pods serão nomeados *statefulset-0*, *statefulset-1* e assim por diante.

Essa identificação é essencial para aplicativos que precisam de estabilidade, como bancos de dados.

#### Volume Persistente

Cada pod no StatefulSet possui seu próprio volume persistente, criado automaticamente com base no volumeClaimTemplates. Esses volumes são associados ao nome do pod e mantêm os dados mesmo após o pod ser excluído ou reiniciado.

#### Ordered Deploy, Scaling e Update

O StatefulSet garante que:
 - Os pods sejam implantados em ordem (statefulset-0 antes de statefulset-1).
 - O escalonamento respeite a ordem dos pods.
 - As atualizações sejam feitas uma por vez, garantindo estabilidade.

#### PersistentVolumeClaim

O PersistentVolumeClaim (PVC) é uma solicitação de armazenamento persistente feita pelos pods. No exemplo acima, o PVC solicita um volume de 128Mi com acesso ReadWriteOnce.

#### Reclaim Policy (PersistentVolume)

A política de recuperação (Reclaim Policy) define o que acontece com os volumes quando o PVC é excluído:
 - Retain: O volume não é deletado, permitindo recuperação manual.
 - Delete: O volume é automaticamente excluído quando o PVC associado é deletado.
 - Recycle: Limpa os dados no volume e o torna disponível novamente (obsoleto em versões recentes).

#### Storage Class (PersistentVolumeClaim)

O Storage Class define as propriedades de provisionamento dos volumes. Tipos comuns incluem:
 - **gp2**: Armazenamento padrão da AWS.
 - **standard**: Armazenamento padrão do GCP.
 - **azure**-disk: Armazenamento gerenciado pelo Azure.

### Como Deletar PersistentVolume e PersistentVolumeClaim

###### Excluir o PVC
```
kubectl delete pvc <pvc-name>
```

###### Excluir o PV (se a política de recuperação for Retain)
```
kubectl delete pv <pv-name>
```


### Storage Object in Use Protection

Essa funcionalidade impede que PVCs e PVs sejam excluídos enquanto estiverem sendo usados por um pod, garantindo a integridade dos dados.

#### Comandos Úteis para StatefulSet
###### Criar StatefulSet
```
kubectl apply -f statefulset.yaml
```

###### Listar StatefulSets
```
kubectl get statefulsets
```

###### Ver detalhes de um StatefulSet
```
kubectl describe statefulset <statefulset-name>
```

###### Listar pods gerenciados por um StatefulSet
```
kubectl get pods -l app=<label>
```

###### Escalonar um StatefulSet
```
kubectl scale statefulset <statefulset-name> --replicas=<number>
```

###### Excluir um StatefulSet
```
kubectl delete statefulset <statefulset-name>
```

###### Ver logs de um pod gerenciado
```
kubectl logs <pod-name>
```

###### Ver status dos volumes associados
```
kubectl get pvc
```

###### Excluir PersistentVolume e PersistentVolumeClaim
```
kubectl delete pvc <pvc-name>
kubectl delete pv <pv-name>
```

###### Atualizar um StatefulSet
```
kubectl edit statefulset <statefulset-name>
```
