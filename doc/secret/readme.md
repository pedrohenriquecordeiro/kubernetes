# Secrets no Kubernetes

O Secret no Kubernetes é um recurso essencial para armazenar dados sensíveis, como senhas, tokens de acesso e chaves SSH. Ele permite que essas informações sejam usadas em pods de maneira segura, separando-as do código da aplicação.

## O Que é um Secret?

Um Secret no Kubernetes armazena dados sensíveis de forma codificada em base64. Apesar disso, é importante notar que eles não são criptografados por padrão, mas podem ser protegidos usando configurações adicionais, como o Encryption at Rest.

Os Secrets podem ser usados como:
 1. Variáveis de Ambiente.
 2. Volumes Montados.
 3. Referências em Arquivos de Configuração.

## YAML

Aqui está um exemplo básico de Secret:
```yaml
apiVersion: v1                        # Define a versão da API para Secrets.
kind: Secret                          # Especifica que o recurso criado será um Secret.
metadata:                             # Metadados do Secret.
  name: my-secret                     # Nome do Secret.
type: Opaque                          # Define o tipo do Secret (dados genéricos, neste caso).
data:                                 # Dados armazenados em base64.
  user: YWRtaW4K                      # "admin" em base64.
  password: YWRtaW4tYWRtaW4K          # "admin-admin" em base64.
stringData:                           # Dados armazenados como texto simples.
  database-name: mariadb              # Nome do banco de dados.
immutable: false                      # Define se o Secret pode ser alterado após criado.
```
##### Explicação
 - type: Define o tipo do Secret. Aqui, Opaque indica dados genéricos.
 - data: Armazena informações codificadas em base64.
 - stringData: Permite armazenar dados como texto simples, convertendo-os automaticamente para base64.
 - immutable: Quando definido como true, impede alterações após a criação.

## Utilizando Secrets em Pods

### Usando Secrets como Variáveis de Ambiente
```yaml
apiVersion: v1                        # Define a versão da API.
kind: Pod                             # Especifica que o recurso criado será um Pod.
metadata:                             # Metadados do Pod.
  name: my-pod-secret                 # Nome do Pod.
spec:                                 # Especificações do Pod.
  containers:                         # Lista de containers no Pod.
  - name: my-container                # Nome do container.
    image: nginx                      # Imagem Docker usada no container.
    envFrom:                          # Injeta variáveis de ambiente no container.
    - secretRef:                      # Referência ao Secret.
        name: my-secret               # Nome do Secret.
        optional: false               # Torna o Secret obrigatório.
```
##### Explicação:
 - Cada chave no Secret se torna uma variável de ambiente no container.
 - user e password estarão disponíveis como variáveis no container.

### Montando Secrets como Volumes
```yaml
apiVersion: v1                        # Define a versão da API.
kind: Pod                             # Especifica que o recurso criado será um Pod.
metadata:                             # Metadados do Pod.
  name: my-pod-secret-vol             # Nome do Pod.
spec:                                 # Especificações do Pod.
  containers:                         # Lista de containers no Pod.
  - name: my-container                # Nome do container.
    image: nginx                      # Imagem Docker usada no container.
    envFrom:                          # Injeta variáveis de ambiente no container.
    - secretRef:                      # Referência ao Secret.
        name: my-secret               # Nome do Secret.
        optional: false               # Torna o Secret obrigatório.
    volumeMounts:                     # Monta volumes no container.
    - name: my-volume                 # Nome do volume.
      mountPath: "/etc/volume"        # Caminho no container onde o volume será montado.
      readOnly: true                  # Define o volume como somente leitura.
  volumes:                            # Lista de volumes para o Pod.
  - name: my-volume                   # Nome do volume.
    secret:                           # Define o volume como um Secret.
      secretName: my-secret           # Nome do Secret associado ao volume.
      optional: false                 # Torna o Secret obrigatório.
```
##### Vantagens:
 1. Valores Atualizados Dinamicamente: Arquivos montados refletem alterações no Secret.
 2. Organização: Arquivos em volumes são acessíveis diretamente pelo sistema de arquivos do container.

## Armazenamento de Secrets no etcd

Os Secrets são armazenados no etcd, o banco de dados chave-valor usado pelo Kubernetes. Por padrão, os dados são apenas codificados em base64, mas podem ser protegidos com Encryption at Rest para aumentar a segurança.

## Tipos de Secrets

### Opaque

O tipo mais genérico, usado para armazenar qualquer tipo de dado sensível.
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: opaque-secret
type: Opaque
data:
  api-key: YXBpLWtleQ== # "api-key"
```
### basic-auth

Armazena informações de autenticação básicas, como nome de usuário e senha.
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: basic-auth-secret
type: kubernetes.io/basic-auth
stringData:
  username: admin
  password: admin-password
```

### ssh-auth

Armazena chaves SSH para autenticação.
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ssh-auth-secret
type: kubernetes.io/ssh-auth
data:
  ssh-privatekey: LS0t...LS0tCg== # Chave privada codificada em base64.
```
### TLS (Transport Layer Security)

Usado para armazenar certificados TLS.
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: tls-secret
type: kubernetes.io/tls
data:
  tls.crt: LS0t...Cg== # Certificado TLS.
  tls.key: LS0t...Cg== # Chave privada TLS.
```

## Comandos Úteis

##### Criar um Secret genérico:
```
kubectl create secret generic my-secret --from-literal=user=admin --from-literal=password=admin123
```

##### Criar um Secret a partir de um arquivo:
```
kubectl create secret generic my-secret --from-file=credentials.txt
```

##### Visualizar Secrets (nome e tipo):
```
kubectl get secrets
```

##### Visualizar o conteúdo de um Secret (decodificado):
```
kubectl get secret my-secret -o yaml
```

##### Atualizar um Secret existente:
```
kubectl edit secret my-secret
```

##### Remover um Secret:
```
kubectl delete secret my-secret
```

##### Exibir valores do Secret decodificados:
```
kubectl get secret my-secret -o go-template='{{range $k, $v := .data}}{{$k}}: {{base64decode $v}}{{"\n"}}{{end}}'
```
