Para rodar um projeto no Kubernetes: 

- Vamos precisar de um Deployment, que é como submetemos os containers das aplicações aos Pods
- O comando é: ```kubectl create deployment <nome> --image=<image>```
- Esse faz com que o projeto passe a ser orquestrado pelo Kubernetes

Para checar se o Deployment foi criado corretamente:
- ```kubectl get deployments``` (Verifica o Deployment)
- ```kubectl describe deployments``` (Obtem mais detalhes dos Deployments)

Para verificar os Pods (onde os containers realmente são executados) utilizamos: 
- ``` kubectl get pods```
- E para saber mais detalhes : ```kubectl describe pod <nome-do-pod>```
- Para deletar um pod : ```kubectl delete pod <nome-do-pod>```
- Para obter logs de um pod : ```kubectl logs <nome-do-pod>```
