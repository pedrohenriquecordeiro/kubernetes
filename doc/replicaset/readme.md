
# ReplicaSet

O ReplicaSet no Kubernetes é um objeto que garante que uma quantidade específica de réplicas de um pod esteja rodando no cluster o tempo todo. Ele é como um “guarda” que verifica se o número de pods desejados está ativo e, caso algum falhe, o ReplicaSet cria automaticamente um novo para substituir.

## Como funciona?
	•	Você define no manifesto YAML do ReplicaSet o número desejado de réplicas (por exemplo, 3).
	•	O Kubernetes cria esses 3 pods com base na especificação fornecida.
	•	Se um dos pods parar de funcionar ou for excluído, o ReplicaSet detecta isso e inicia outro pod para manter o número configurado.

## Exemplo prático:

Imagine que você tem uma aplicação web e quer garantir que ela esteja sempre disponível com 3 instâncias rodando. Se um servidor falhar ou um pod for removido, o ReplicaSet criará outro automaticamente para garantir que sua aplicação não tenha interrupções.

## Diferença entre ReplicaSet e Deployment:
	•	O Deployment é um nível mais alto de abstração que usa internamente o ReplicaSet, mas também oferece funcionalidades adicionais, como atualizações e reversões.
	•	Na maioria dos casos, você usará um Deployment, porque ele facilita gerenciar mudanças, enquanto o ReplicaSet puro é usado em casos mais específicos.

Em resumo, o ReplicaSet é como o “motor” que mantém seus pods sempre na quantidade certa dentro do cluster Kubernetes.
