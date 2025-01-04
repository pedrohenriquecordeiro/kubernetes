# Volumes no Kubernetes

Volumes no Kubernetes são um conceito fundamental para o gerenciamento de dados em containers. Eles permitem que dados sejam compartilhados entre containers em um mesmo pod ou persistam além do ciclo de vida de um pod. 

## O Que é um Volume no Kubernetes?

No Kubernetes, um volume é um diretório que pode ser acessado pelos containers de um pod. Ele fornece uma maneira de armazenar e compartilhar dados de forma controlada. Diferentemente do Docker, os volumes no Kubernetes podem ser configurados para persistir além do ciclo de vida do pod ou serem usados apenas temporariamente.

Existem dois principais tipos de volumes:
 - **Volume Efêmeros**: Estão vinculados ao ciclo de vida do pod e são excluídos quando o pod é encerrado. Esses volumes são definidos no nível do pod, permitindo que todos os containers dentro do pod tenham acesso a eles. Isso significa que, mesmo que um container falhe e seja reiniciado, o volume permanece inalterado, pois ele está associado ao ciclo de vida do pod.
 - **Volume Persistentes**: Podem sobreviver ao término do pod e são usados para armazenar dados a longo prazo. Fica localizado no Node do Servidor Kubernetes.


### Exemplo Volume Efêmero
```yaml
apiVersion: v1                    # Define a versão da API.
kind: Pod                         # Especifica que este manifesto cria um pod.
metadata:                         # Metadados associados ao pod.
  name: redis-pod                 # Nome do pod.
spec:                             # Especificações do pod.
  containers:                     # Define os containers dentro do pod.
  - name: redis-container         # Nome do container.
    image: redis                  # Imagem do Redis usada pelo container.
    volumeMounts:                 # Monta volumes no container.
    - name: "cache-storage"       # Nome do volume referenciado.
      mountPath: "/volume"        # Caminho no container onde o volume será montado.
  
  volumes:                        # Define os volumes disponíveis para o pod.
  - name: cache-storage           # Nome do volume.
    emptyDir: {}                  # Define o Volume Efêmero, e cria um diretório vazio .
```

Neste exemplo, o volume emptyDir é um diretório temporário criado no momento em que o pod é iniciado. Ele é útil para armazenar dados que não precisam persistir além do ciclo de vida do pod.

### Exemplo Volume Persistente
```yaml
apiVersion: v1                    # Define a versão da API.
kind: Pod                         # Especifica que este manifesto cria um pod.
metadata:                         # Metadados associados ao pod.
  name: redis-pod                 # Nome do pod.
spec:                             # Especificações do pod.
  containers:                     # Define os containers dentro do pod.
  - name: redis-container         # Nome do container.
    image: redis                  # Imagem do Redis usada pelo container.
    volumeMounts:                 # Monta volumes no container.
    - mountPath: "/external_data" # Caminho no container onde o volume será montado.
      name: "data"                # Nome do volume referenciado.
  volumes:                        # Define os volumes disponíveis para o pod.
  - name: "data"                  # Nome do volume.
    hostPath:                     # Define o volume como Persistente.
      path: "/var/lib/datapod"    # Caminho no sistema de arquivos do Node Kubernetes.
```


### Kubernetes Volumes vs Docker Volumes
 - Kubernetes Volumes: Estão associados ao ciclo de vida do pod, não do container, o que permite maior resiliência. Além disso, o Kubernetes suporta diferentes tipos de volumes, incluindo integrações com provedores de nuvem, como AWS, Azure e GCP.
 - Docker Volumes: São associados diretamente ao container e não possuem suporte nativo a soluções avançadas de armazenamento persistente.

## Tipos de Volume

Aqui está uma lista dos tipos de volumes disponíveis no Kubernetes com um resumo de cada um e a tag YAML correspondente para sua criação:

##### emptyDir
Um volume efêmero criado vazio quando o pod inicia. É destruído assim que o pod é excluído.
 - Uso Comum: Armazenamento temporário de dados, como caches ou arquivos intermediários.
 - Tag YAML: emptyDir
```yaml
volumes:
- name: my-temp-volume
  emptyDir: {}
```

##### emptyDir (com tmpfs)
Um volume emptyDir armazenado na memória (RAM) para acesso rápido.
 - Uso Comum: Dados temporários que precisam de alta performance.
 - Tag YAML: emptyDir com medium: Memory

```yaml
volumes:
- name: memory-volume
  emptyDir:
    medium: Memory
```

##### hostPath
Monta um diretório existente do sistema de arquivos do nó onde o pod está sendo executado.
 - Uso Comum: Acesso direto a arquivos no nó, como logs ou configurações do sistema.
 - Tag YAML: hostPath

```yaml

volumes:
- name: my-host-volume
  hostPath:
    path: /var/data

```

##### persistentVolumeClaim
Conecta um pod a um volume persistente previamente provisionado, utilizando uma PersistentVolumeClaim.
 - Uso Comum: Armazenamento persistente que sobrevive ao ciclo de vida do pod.
 - Tag YAML: persistentVolumeClaim

```yaml
volumes:
- name: my-persistent-volume
  persistentVolumeClaim:
    claimName: my-claim
```

##### configMap
Monta dados armazenados em um ConfigMap como arquivos ou variáveis de ambiente.
 - Uso Comum: Injetar configurações no container.
 - Tag YAML: configMap

```yaml
volumes:
- name: config-volume
  configMap:
    name: my-config
```

##### secret
Monta segredos (secrets) como arquivos ou variáveis de ambiente no pod.
 - Uso Comum: Injetar credenciais ou tokens de acesso de forma segura.
 - Tag YAML: secret

```yaml
volumes:
- name: secret-volume
  secret:
    secretName: my-secret
```

##### nfs
Monta um diretório de um servidor NFS (Network File System).
 - Uso Comum: Compartilhar dados entre pods ou nós em um cluster.
 - Tag YAML: nfs

```yaml
volumes:
- name: nfs-volume
  nfs:
    server: 192.168.1.100
    path: /data
```

##### gcePersistentDisk
Conecta o pod a um disco persistente do Google Cloud (GCE Persistent Disk).
 - Uso Comum: Armazenamento persistente no Google Cloud.
 - Tag YAML: gcePersistentDisk

```yaml
volumes:
- name: gce-volume
  gcePersistentDisk:
    pdName: my-disk
    fsType: ext4
```

##### awsElasticBlockStore
Conecta o pod a um volume do Elastic Block Store (EBS) da AWS.
 - Uso Comum: Armazenamento persistente na AWS.
 - Tag YAML: awsElasticBlockStore

```yaml
volumes:
- name: ebs-volume
  awsElasticBlockStore:
    volumeID: vol-123456
    fsType: ext4
```

##### azureDisk
Conecta o pod a um disco gerenciado do Microsoft Azure.
 - Uso Comum: Armazenamento persistente no Azure.
 - Tag YAML: azureDisk

```yaml
volumes:
- name: azure-disk
  azureDisk:
    diskName: my-disk
    diskURI: /subscriptions/.../disks/my-disk
```

##### csi (Container Storage Interface)
Interface padrão para integrar volumes gerenciados por provedores externos.
 - Uso Comum: Armazenamento persistente fornecido por plugins de terceiros.
 - Tag YAML: csi

```yaml
volumes:
- name: csi-volume
  csi:
    driver: my.csi.driver
    volumeHandle: my-volume
```

