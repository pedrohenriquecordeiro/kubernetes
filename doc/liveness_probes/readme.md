# Liveness Probes no Kubernetes

No Kubernetes, um liveness probe é uma ferramenta essencial para monitorar e manter a saúde dos containers em execução. Ele permite ao kubelet verificar se um container está em bom estado. Quando um liveness probe falha, o Kubernetes assume que o container não está mais funcionando corretamente e o reinicia automaticamente. Isso é particularmente útil para resolver situações como deadlocks, onde um processo continua em execução, mas está inoperante.

## Conceito de Liveness Probe

O liveness probe realiza verificações periódicas para determinar se o container está funcionando corretamente. Se a sonda falhar repetidamente, o container será reiniciado pelo kubelet, garantindo que ele volte ao estado saudável.

## Exemplo Prático de Liveness Probe

Vamos analisar o seguinte YAML que demonstra como configurar uma liveness probe para um container:
```yaml
# Criação de um Namespace chamado "liveness-probe"
apiVersion: v1                # Define a versão da API Kubernetes
kind: Namespace               # Tipo do recurso: Namespace
metadata:
  name: liveness-probe        # Nome do namespace: "liveness-probe"
---
# Criação de um Pod com liveness probe no namespace "liveness-probe"
apiVersion: v1                # Versão da API Kubernetes para Pods
kind: Pod                     # Tipo do recurso: Pod
metadata: 
  name: liveness-probe-pod    # Nome do Pod: "liveness-probe-pod"
  namespace: liveness-probe   # Namespace onde o Pod será criado
spec: 
  containers:                 # Define os containers do Pod
  - name: liveness-container  # Nome do container: "liveness-container"
    image: busybox            # Imagem do container: busybox
    args:                     # Comandos executados no container
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 20; rm -f /tmp/healthy; sleep 60; touch /tmp/healthy; sleep 60; rm -f /tmp/healthy; sleep 600
      # Primeiro cria /tmp/healthy; espera 20s; apaga /tmp/healthy; espera 60s; recria /tmp/healthy; repete

    livenessProbe:            # Configuração da liveness probe
      exec:                   # Tipo da sonda: executa um comando
        command:
        - cat
        - /tmp/healthy        # Verifica se o arquivo /tmp/healthy existe
      initialDelaySeconds: 5  # Aguarda 5 segundos antes de iniciar a liveness probe
      periodSeconds: 5        # Executa a sonda a cada 5 segundo
      failureThreshold: 3     # Permite 3 falhas consecutivas antes de reiniciar o container
````

O comando executado no container foi projetado para simular um cenário onde o estado de saúde do container alterna entre saudável e não saudável, permitindo observar o comportamento do liveness probe. 
A imagem busybox foi utilizada porque é uma imagem que fornece as ferramentas básicas necessárias para executar comandos simples de shell, tornando-a ideal para testes e demonstrações como a configuração do liveness probe.

Para testar esse caso use o comando : 
```shell
kubectl apply -f liveness_probe.yaml && kubectl get events --namespace=liveness-probe --field-selector=involvedObject.name=liveness-probe-pod -w

```

## Funcionamento do Caso de Exemplo
1. Inicialmente Saudável:
O container cria o arquivo ```/tmp/healthy``` assim que inicia. A liveness probe verifica a existência do arquivo usando o comando ```cat /tmp/healthy```. Enquanto o arquivo existir, a sonda será bem-sucedida.

2. Falha Após 20 Segundos:
Após 20 segundos, o arquivo ```/tmp/healthy``` é removido pelo próprio container. A partir desse momento, a liveness probe falha, resultando em mensagens de erro como:
```
Warning   Unhealthy   pod/liveness-probe-pod   Liveness probe failed: cat: can't open '/tmp/healthy': No such file or directory
Warning   Unhealthy   pod/liveness-probe-pod   Liveness probe failed: cat: can't open '/tmp/healthy': No such file or directory
Warning   Unhealthy   pod/liveness-probe-pod   Liveness probe failed: cat: can't open '/tmp/healthy': No such file or directory
```

3. Reinício do Container:
Após 3 falhas consecutivas (definido pelo *failureThreshold*), o *kubelet reinicia o container, conforme evidenciado pelo log:
```
Normal    Killing     pod/liveness-probe-pod   Container liveness-container failed liveness probe, will be restarted
Normal    Pulling     pod/liveness-probe-pod   Pulling image "busybox"
Normal    Pulled      pod/liveness-probe-pod   Successfully pulled image "busybox" in 358.88835ms
Normal    Created     pod/liveness-probe-pod   Created container liveness-container
Normal    Started     pod/liveness-probe-pod   Started container liveness-container
```

4. Ciclo Repetido:
Esse ciclo continua, simulando cenários onde o container alterna entre estados saudáveis e não saudáveis.

### Relação com o Kubelet

O kubelet é responsável por monitorar as sondas de liveness e atuar com base nos resultados:
 - Sondas de Sanidade: A liveness probe é uma “sonda de sanidade” que verifica se o container está funcional.
 - Tratar Deadlocks: Deadlocks são situações em que o processo do container fica preso, mas não falha completamente. O kubelet reinicia containers que entram em deadlock.
 - Reinício Automático: Se a sonda falhar, o kubelet reinicia o container para tentar restaurar sua funcionalidade.

### Por que o Liveness Probe é Importante?
 - Manutenção da Disponibilidade: Reinicia containers inativos automaticamente, reduzindo o tempo de inatividade.
 - Detecção de Problemas: Identifica e responde a falhas que não resultam no encerramento do processo, como deadlocks.
 - Resiliência: Garante que o sistema continue operando mesmo em cenários de falha.
