# Job no Kubernetes

O Job no Kubernetes é um recurso utilizado para executar tarefas específicas que terminam após a conclusão de um trabalho, diferentemente de objetos como Deployments ou DaemonSets, que gerenciam workloads contínuos. Ele é ideal para cenários como processamento de dados, cálculos matemáticos, geração de relatórios ou qualquer tarefa que precise ser concluída apenas uma vez ou um número fixo de vezes.

## YAML 

Abaixo está um YAML que descreve um Job no Kubernetes:
```yaml
apiVersion: batch/v1               # Define a versão da API utilizada para Jobs.
kind: Job                          # Especifica que o recurso criado será um Job.
metadata:                          # Metadados associados ao Job.
  name: my-job                     # Nome do Job.
spec:                              # Especificações do Job.
  completions: 5                   # Número de execuções do Job. (Número de Pod lançados pelo job)
  completionMode: "Indexed"        # Define um índice único para cada execução do Job.
  parallelism: 5                   # Número de execuções que podem ocorrer simultaneamente.
  activeDeadlineSeconds: 10        # Tempo máximo (em segundos) para o Job ser concluído.
  backoffLimit: 2                  # Número máximo de tentativas de reexecutar um Job em falha.
  template:                        # Template para o pod criado pelo Job.
    metadata:                      # Metadados do pod.
      name: my-job-pod             # Nome do pod gerado (não obrigatório).
    spec:                          # Especificações do pod.
      containers:                  # Lista de containers no pod.
      - name: job-container-busybox # Nome do container.
        image: busybox             # Imagem Docker usada no container.
        command:                   # Comando executado no container.
        - "/bin/sh"
        - "-c"
        - "for i in 1 2; do echo [random number][$(( 1 + RANDOM + 100))]; done"
      restartPolicy: Never         # Política de reinício do container (Nunca reiniciar).
```

#### Detalhando os Atributos do Job
##### completions
 - Especifica o número total de execuções do Job que devem ser concluídas com sucesso.
 - Exemplo: completions: 5 significa que o Job será executado 5 vezes com sucesso antes de ser considerado completo.
##### completionMode
 - Define como as execuções são rastreadas:
 - "NonIndexed" (padrão): Não atribui índices às execuções.
 - "Indexed": Cada execução recebe um índice exclusivo, útil para tarefas paralelas.
##### parallelism
 - Número de execuções que podem ocorrer simultaneamente.
 - Exemplo: parallelism: 5 permite até 5 pods sendo executados em paralelo.
##### activeDeadlineSeconds
 - Tempo máximo (em segundos) para a execução do Job.
 - Após esse período, o Job é considerado expirado e qualquer execução restante será interrompida.
 - Se o pod não concluir a tarefa dentro do tempo configurado, o pod é deletado.
##### backoffLimit
 - Define o número máximo de tentativas de reexecutar um Job em caso de falha.
 - Exemplo: backoffLimit: 2 significa que o Kubernetes tentará reiniciar um Job no máximo duas vezes após uma falha.

## Comandos

##### kubectl get job <pod_name>
```
NAME     COMPLETIONS   DURATION   AGE
my-job   1/5           8m3s       8m3s
```
Comando que exibe os jobs no kubernetes.
 - COMPLETIONS: Número de execuções concluídas com sucesso (neste caso, 1 de 5).
 - DURATION: Tempo total de execução do Job até o momento.
 - AGE: Tempo desde a criação do Job.

##### kubectl describe jobs

Este comando exibe detalhes do Job, incluindo:
 - Name: Nome do Job.
 - Namespace: Namespace onde o Job está sendo executado.
 - Parallelism: Número de execuções simultâneas permitidas.
 - Completions: Número total de execuções necessárias.
 - Pods: Lista de pods associados ao Job, com seus estados (Running, Succeeded, Failed).
 - Conditions: Status das condições do Job (e.g., Complete ou Failed).

##### kubectl get job <pod_name> –output yaml

Este comando retorna o Job em formato YAML, incluindo:
 - Configuração original do Job.
 - Detalhes como status (informações sobre o progresso e estado do Job).
 - Logs de eventos relevantes.

##### kubectl logs <pod_name>

Este comando retorna os logs de um pod específico criado pelo Job. É útil para depurar ou verificar o progresso do trabalho.

## Códigos de Saída dos Containers (Exit Codes)

Os códigos de saída indicam o status da execução do container. Eles são importantes para entender se o Job foi concluído com sucesso ou se encontrou problemas.

#### CódigoDescrição
###### Tabela: Códigos de Saída dos Containers (Exit Codes)

| **Código** | **Descrição**                          |
|------------|----------------------------------------|
| **0**      | Execução concluída com sucesso.        |
| **1**      | Erro de aplicação.                    |
| **126**    | Erro ao invocar o comando.            |
| **127**    | Arquivo ou diretório não encontrado.   |
| **134**    | Encerramento anormal.                 |
| **137**    | Encerramento imediato.                |
| **139**    | Falha de segmentação.                 |
| **255**    | Código de saída fora do intervalo.    |

## Job Container Restart Policy

#### Definindo a Política de Reinício

A política de reinício é configurada no campo restartPolicy no template do pod. Os valores permitidos são:
 - Never: O container nunca será reiniciado após falhas.
 - OnFailure: O container será reiniciado apenas em caso de falhas.

Nota:
 - Apenas Never e OnFailure são permitidos para pods criados por um Job.
 - O valor padrão para outros objetos como Deployment, ReplicaSet e DaemonSet é Always.

