#!/bin/bash

set -e  # Exit immediately on error

# Get Debian codename (e.g., bookworm, bullseye)
DEBIAN_CODENAME=$(lsb_release -cs)

# Wait for apt lock to be released
while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do
  echo "Waiting for another apt process to finish..."
  sleep 2
done

echo "INSTALL DOCKER"
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $DEBIAN_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"
sudo service docker restart
docker context use default || true

echo "INSTALL KUBECTL"
curl -LO https://dl.k8s.io/release/v1.24.2/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client --output=yaml

echo "INSTALL MINIKUBE"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
minikube version
minikube delete || true

echo "INSTALL HELM"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install -y helm

