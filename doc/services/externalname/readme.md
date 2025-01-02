# Service ExternalName no Kubernetes

No Kubernetes, o Service ExternalName é uma forma de expor serviços externos ao cluster por meio de um nome DNS. Ele permite que aplicações dentro do cluster se conectem a serviços fora dele, como bancos de dados na nuvem ou APIs públicas, sem a necessidade de configuração direta de endereços IP.

Esse tipo de serviço é especialmente útil para abstrair a complexidade de conexões externas, oferecendo um ponto único de acesso dentro do cluster.

## O que é DNS?

O DNS (Domain Name System) é um sistema que traduz nomes de domínio legíveis por humanos, como db-cloudsql.google.com, para endereços IP que os computadores utilizam para comunicação, como 34.123.45.67. 

Dois tipos importantes de registros DNS usados pelo Kubernetes são:
- CNAME: Aponta um nome de domínio para outro nome de domínio.
- A Record: Aponta diretamente para um endereço IP.

O Kubernetes usa registros DNS no serviço ExternalName para mapear um nome interno para um domínio externo, simplificando o acesso.

## Exemplo

Aqui está um exemplo de configuração de um serviço ExternalName para um banco de dados no Cloud SQL (Google Cloud Platform):
```yaml
# Criação de um Namespace chamado "database-services"
apiVersion: v1                # Define a versão da API Kubernetes
kind: Namespace               # Tipo do recurso: Namespace
metadata:
  name: database-services     # Nome do namespace: "database-services"
---
# Criação de um Service do tipo ExternalName no namespace "database-services"
apiVersion: v1                # Versão da API Kubernetes para Services
kind: Service                 # Tipo do recurso: Service
metadata:
  name: cloudsql-database     # Nome do serviço: "cloudsql-database"
  namespace: database-services # Namespace onde o serviço será criado
spec:
  type: ExternalName          # Define o tipo do serviço como ExternalName
  externalName: db-cloudsql.google.com  # Nome de domínio externo do banco de dados no Cloud SQL
```

### Explicação
1.	Namespace:
O serviço é criado dentro do namespace database-services, que isola serviços relacionados a banco de dados. Isso ajuda na organização e evita conflitos com outros recursos.
2.	Tipo do Serviço:
O campo type: ExternalName indica que este serviço não gerencia Pods diretamente e serve apenas como uma referência a um serviço externo.
3.	externalName:
O campo externalName especifica o domínio externo (db-cloudsql.google.com) que o Kubernetes deve mapear. Esse domínio pode apontar para um serviço como um banco de dados gerenciado no Cloud SQL.

#### Conceito de Serviços Sem Seletores

Um serviço sem seletores no Kubernetes, como o ExternalName, não utiliza rótulos (labels) para localizar Pods no cluster. Em vez disso, ele atua como um alias que redireciona tráfego para um nome de domínio externo. Isso permite que recursos externos sejam integrados ao cluster sem a necessidade de Pods internos.

### Como o ExternalName Usa DNS?

O ExternalName realiza consultas DNS (DNS lookup) para resolver o nome do domínio configurado no campo externalName. O processo funciona assim:
1.	O cliente dentro do cluster solicita o serviço, por exemplo, cloudsql-database.database-services.svc.cluster.local.
2.	O Kubernetes traduz essa solicitação para o nome externo definido, como db-cloudsql.google.com.
3.	O sistema DNS resolve db-cloudsql.google.com para um endereço IP (via A Record).
4.	O cliente se conecta diretamente ao serviço no endereço IP retornado.

Essa abordagem abstrai a complexidade de configuração para os desenvolvedores, fornecendo um caminho simples para acessar serviços externos.

### Relação com Registros DNS
-	CNAME: O ExternalName age como um registro CNAME, redirecionando o tráfego para outro nome de domínio.
-	A Record: O DNS externo resolve o domínio final para um endereço IP que o cliente utiliza para estabelecer a conexão.

### Quando Usar o ExternalName?
-	Para conectar o Kubernetes a serviços externos, como bancos de dados na nuvem, APIs públicas ou outras aplicações fora do cluster.
-	Quando é necessário simplificar o acesso a serviços externos por meio de um nome interno no cluster.
-	Em cenários onde as aplicações no cluster não devem lidar diretamente com endereços IP ou mudanças no domínio externo.

