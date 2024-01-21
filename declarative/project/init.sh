
# inicia servidor minikube
minikube start --driver=docker

# cria o deployment
kubectl apply -f project/file-deployment.yaml &&
kubectl get deployments

# cria o service e link com o deployment criado
kubectl apply -f project/file-service.yaml &&
kubectl get services

### ou

### cria o deployment e o service em um comando
# kubectl apply -f project/file-deployment-service.yaml &&
# kubectl get deployments &&
# kubectl get services

## expoe o service no servido minikube
minikube service page-test &&
minikube tunnel

## check do service executando
curl http://192.168.49.2:30257 # url do service

## logs
kubectl logs -f <pod-id>
