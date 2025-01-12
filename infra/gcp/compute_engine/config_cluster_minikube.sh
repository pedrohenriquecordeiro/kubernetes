# INSTALL DOCKER 
sudo apt update &&
sudo apt install apt-transport-https ca-certificates curl software-properties-common &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&
apt-cache policy docker-ce &&
sudo apt install docker-ce &&
# sudo systemctl status docker &&
sudo usermod -aG docker $USER && 
newgrp docker &&
sudo groupadd docker &&
sudo gpasswd -a $USER docker &&
sudo service docker restart &&
sudo docker context use default &&

# INSTALL KUBECTL
curl -LO https://dl.k8s.io/release/v1.24.2/bin/linux/amd64/kubectl &&
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&
kubectl version --client --output=yaml &&

# INSTALL MINIKUBE
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.26.0/minikube-linux-amd64 &&
chmod +x minikube &&
sudo install minikube /usr/local/bin/ &&
sudo usermod -aG docker $USER &&
# sudo reboot 
minikube delete &&
minikube start &&


# INSTALL HELM
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null &&
sudo apt-get install apt-transport-https --yes &&
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list &&
sudo apt-get update &&
sudo apt-get install helm
