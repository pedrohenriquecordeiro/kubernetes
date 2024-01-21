minikube start --driver=docker

minikube ssh docker pull pedrojjesus/flask-kubernetes-project:latest &&
kubectl create deployment page-test --image=pedrojjesus/flask-kubernetes-project &&
kubectl get deployments

kubectl expose deployment page-test --type=LoadBalancer --port=5000 &&
kubectl get services

minikube service page-test &&
minikube tunnel

kubectl logs -f <pod-id>

curl http://192.168.49.2:30257 # url do service
