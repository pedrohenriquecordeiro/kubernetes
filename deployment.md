Para rodar um projeto no Kubernetes: 

- Vamos precisar de um Deployment, que é como submetemos os containers das aplicações aos Pods
- O comando é: ```kubectl create deployment <nome> --image=<image>```
- Esse faz com que o projeto passe a ser orquestrado pelo Kubernetes
