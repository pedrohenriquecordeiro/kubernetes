https://docs.altinity.com/altinitykubernetesoperator/kubernetesinstallguide/minikubeonlinux/


sudo apt update &&
sudo apt upgrade -y &&
sudo apt install ca-certificates curl gnupg wget apt-transport-https -y &&
sudo install -m 0755 -d /etc/apt/keyrings &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
sudo chmod a+r /etc/apt/keyrings/docker.gpg &&
echo \
 "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
sudo apt update &&
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&
sudo usermod -aG docker $USER &&
newgrp docker &&
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 &&
sudo install minikube-linux-amd64 /usr/local/bin/minikube 

minikube version


curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl &&
chmod +x kubectl &&
sudo mv kubectl /usr/local/bin/ &&
kubectl version -o yaml

minikube start --driver=docker

minikube status
