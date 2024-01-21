# inicia servidor minikube
minikube start --driver=docker

# cria o deployment
minikube ssh docker pull pedrojjesus/flask-kubernetes-project:latest &&
kubectl create deployment page-test --image=pedrojjesus/flask-kubernetes-project &&
kubectl get deployments

# cria o service e link com o deployment criado
kubectl expose deployment page-test --type=LoadBalancer --port=5000 &&
kubectl get services

## expoe o service no servido minikube
minikube service page-test &&
minikube tunnel

## check do service executando
curl http://192.168.49.2:30257 # url do service

## logs
kubectl logs -f <pod-id>

