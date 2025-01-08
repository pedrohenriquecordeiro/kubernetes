# ConfigMap no Kubernetes

O ConfigMap é um recurso do Kubernetes projetado para armazenar informações de configuração como pares chave-valor. Ele separa a configuração dos aplicativos do código, facilitando a manutenção, o reuso e a atualização sem a necessidade de reconstruir imagens de container. 

## O Que é um ConfigMap?

O ConfigMap é uma maneira de injetar dados de configuração em pods, seja por variáveis de ambiente, arquivos montados como volumes ou argumentos de linha de comando. Ele é usado para armazenar informações não sensíveis, como configurações de aplicativos, URLs de banco de dados e temas de interface.

## YAML

Aqui está um exemplo simples de ConfigMap em YAML:
```yaml
apiVersion: v1                        # Define a versão da API.
kind: ConfigMap                       # Especifica que o recurso é um ConfigMap.
metadata:                             # Metadados do ConfigMap.
  name: my-config-map                 # Nome do ConfigMap.
data:                                 # Dados armazenados no ConfigMap.
  config-db: |                        # Configurações do banco de dados.
    database_name: mysql
    database_uri: mysql://localhost:3306
  config-interface: |                 # Configurações de interface do usuário.
    font.title: Arial Bold
    background-color: black
immutable: true                       # Define o ConfigMap como imutável (não pode ser alterado após criado).
```
##### Explicação:
 - O campo data armazena os pares chave-valor.
 - O atributo immutable impede alterações no ConfigMap após sua criação, garantindo segurança e estabilidade.

## Usando ConfigMap com Variáveis de Ambiente

O ConfigMap pode ser referenciado em um pod para definir variáveis de ambiente:

```yaml
apiVersion: v1                        # Define a versão da API.
kind: Pod                             # Especifica que o recurso criado será um Pod.
metadata:                             # Metadados do Pod.
  name: my-pod                        # Nome do Pod.
spec:                                 # Especificações do Pod.
  containers:                         # Lista de containers no Pod.
  - name: my-container                # Nome do container.
    image: nginx                      # Imagem do container.
    envFrom:                          # Injeta variáveis de ambiente no container.
    - configMapRef:                   # Referência ao ConfigMap.
        name: my-config-map           # Nome do ConfigMap a ser referenciado.
```
##### Explicação:
 - Cada chave no ConfigMap se torna uma variável de ambiente no container.
 - O atributo envFrom permite associar o ConfigMap inteiro como variáveis de ambiente.

## Usando ConfigMap como Volume

Outra maneira de usar o ConfigMap é montá-lo como um volume no Pod. Nesse caso, as chaves do ConfigMap se tornam arquivos dentro do volume.

```yaml
apiVersion: v1                        # Define a versão da API.
kind: Pod                             # Especifica que o recurso criado será um Pod.
metadata:                             # Metadados do Pod.
  name: my-pod                        # Nome do Pod.
spec:                                 # Especificações do Pod.
  containers:                         # Lista de containers no Pod.
  - name: my-container                # Nome do container.
    image: nginx                      # Imagem do container.
    envFrom:                          # Injeta variáveis de ambiente no container.
    - configMapRef:
        name: my-config-map           # Nome do ConfigMap a ser referenciado.
    volumeMounts:                     # Monta volumes no container.
    - name: my-volume                 # Nome do volume.
      mountPath: "/etc/volume"        # Caminho no container onde o volume será montado.
      readOnly: true                  # Define o volume como somente leitura.
  volumes:                            # Lista de volumes para o Pod.
  - name: my-volume                   # Nome do volume.
    configMap:                        # Define o volume como um ConfigMap.
      name: my-config-map             # Nome do ConfigMap associado ao volume.
```
##### Vantagens:
1.Valores Atualizados Dinamicamente: Os valores montados no volume refletem alterações no ConfigMap, mas variáveis de ambiente não são atualizadas automaticamente.
2.Organização: Arquivos montados são organizados em um diretório, tornando mais fácil lidar com configurações extensas.



## Comandos Úteis para ConfigMap

#### Criar ConfigMap a Partir de um Arquivo e Literal
```
kubectl create cm my-configmap --from-file=file.txt --from-literal=key=value
```
 - --from-file=file.txt: Adiciona o conteúdo de um arquivo ao ConfigMap.
 - --from-literal=key=value: Adiciona um par chave-valor diretamente.

#### Verificar ConfigMap
```
kubectl get configmap my-config-map -o yaml
```
Exibe o conteúdo completo do ConfigMap em formato YAML.

#### Remover um ConfigMap
```
kubectl delete configmap my-config-map
```
Remove o ConfigMap especificado.
