# CronJob no Kubernetes

O CronJob é um recurso no Kubernetes utilizado para criar Jobs em horários ou intervalos específicos, baseando-se em expressões cron. Ele é ideal para tarefas agendadas, como geração de relatórios, limpeza de logs ou backups. Este artigo explora como configurar e gerenciar CronJobs, utilizando um exemplo YAML para explicar os conceitos e abordando comandos comuns e suas saídas.

## YAML

Abaixo está um YAML para criar um CronJob básico:
```yaml
apiVersion: batch/v1                     # Define a versão da API utilizada para CronJobs.
kind: CronJob                            # Especifica que o recurso criado será um CronJob.
metadata:                                # Metadados do CronJob.
  name: my-cronjob                       # Nome do CronJob.
spec:                                    # Especificações do CronJob.
  schedule: "* * * * *"                  # Expressão cron para agendamento (neste caso, a cada minuto).
  failedJobsHistoryLimit: 10             # Número de Jobs com falha a serem mantidos no histórico.
  successfulJobsHistoryLimit: 10         # Número de Jobs bem-sucedidos a serem mantidos no histórico.
  suspend: true                          # Pausa a execução do CronJob se definido como true.
  jobTemplate:                           # Template para os Jobs gerados pelo CronJob.
    spec:                                # Especificações do Job.
      completions: 1                     # Número total de execuções para completar o Job. (pod lançados)
      completionMode: "NonIndexed"       # Execução sem índices exclusivos para os pods.
      parallelism: 1                     # Número de pods que podem ser executados simultaneamente.
      activeDeadlineSeconds: 10          # Tempo máximo de execução do Job (em segundos).
      backoffLimit: 2                    # Número máximo de tentativas de reexecução em caso de falha.
      template:                          # Template para o pod gerado pelo Job.
        spec:                            # Especificações do pod.
          containers:                    # Lista de containers dentro do pod.
          - name: job-container-busybox  # Nome do container.
            image: busybox               # Imagem Docker usada no container.
            command:                     # Comando a ser executado no container.
            - "/bin/sh"
            - "-c"
            - "date"                     # Exibe a data atual no log.
          restartPolicy: Never           # Política de reinício (nunca reiniciar o container).
```
##### Explicação
 - **schedule**: Define a frequência com que o Job será criado (usando notação cron).
 - **failedJobsHistoryLimit** e successfulJobsHistoryLimit: Mantêm histórico de Jobs com falha ou sucesso.
 - **suspend**: Pausa o CronJob quando definido como true.
 - **completions** e **parallelism**: Controlam o número de execuções e o paralelismo.
 - **activeDeadlineSeconds** e **backoffLimit**: Controlam o tempo máximo e o número de tentativas em caso de falha.
 - **restartPolicy**: Para Jobs, deve ser Never ou OnFailure.

## Comandos

#### Comando: kubectl get cj -w

Este comando exibe informações sobre CronJobs em tempo real.
```
NAME         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
my-cronjob   * * * * *   False     0        <none>          3s
my-cronjob   * * * * *   False     1        0s              36s
my-cronjob   * * * * *   False     0        4s              40s
```
 - SCHEDULE: Agendamento definido no CronJob.
 - SUSPEND: Indica se o CronJob está pausado.
 - ACTIVE: Número de Jobs atualmente em execução.
 - LAST SCHEDULE: Última vez que o Job foi criado.

#### Comando: kubectl get jobs -w

Este comando acompanha os Jobs criados pelo CronJob.
```
NAME                  COMPLETIONS   DURATION   AGE
my-cronjob-28937799   0/1                      0s
my-cronjob-28937799   1/1           4s         4s
```
 - COMPLETIONS: Número de execuções concluídas.
 - DURATION: Tempo de execução do Job.
 - AGE: Tempo desde a criação do Job.

#### Comando: kubectl get pods -w

Este comando monitora os pods criados pelos Jobs.
```
NAME                        READY   STATUS    RESTARTS   AGE
my-cronjob-28937799-9hzqq   0/1     Pending   0          0s
my-cronjob-28937799-9hzqq   0/1     Completed 0          1s
```
 - STATUS: Mostra os estados do pod, como Pending, Running, ou Completed.

#### Comando: kubectl describe cronjob my-cronjob

Fornece detalhes sobre o CronJob, incluindo eventos importantes.
```
Events:
  Type    Reason            Age   From                Message
  ----    ------            ----  ----                -------
  Normal  SuccessfulCreate  3m6s  cronjob-controller  Created job my-cronjob-28937799
  Normal  SawCompletedJob   3m2s  cronjob-controller  Saw completed job: my-cronjob-28937799, status: Complete
```
 - SuccessfulCreate: Indica a criação bem-sucedida de um Job.
 - SawCompletedJob: Mostra quando um Job foi concluído com sucesso.

#### Comando: kubectl patch cronjob

Pausa um CronJob alterando o atributo suspend:

```kubectl patch cronjob my-cronjob -p '{"spec": {"suspend": true}}'```

Nomenclatura
1. my-cronjob: Nome do CronJob.
2. my-cronjob-28937799: Nome do Job criado pelo CronJob.
3. my-cronjob-28937799-9hzqq: Nome do pod criado pelo Job.

## Fuso Horário (Timezone)

O agendamento dos CronJobs é baseado no fuso horário do kube-controller-manager, que geralmente é UTC. Para ajustar para outros fusos horários, é necessário configurar o ambiente do cluster.

