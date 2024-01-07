# How to Install Minikube on Ubuntu 22.04 Step-by-Step
In this blog post, we will explain how to install minikube on Ubuntu 22.04 step-by-step.

Minikube is an open-source tool that facilitates the local deployment of Kubernetes clusters. It is designed to simplify the process of learning and developing applications for Kubernetes by providing a lightweight, single-node Kubernetes cluster that runs on a user’s local machine.

Minikube is an excellent tool for those who want to experiment with Kubernetes features, test applications, and develop and debug containerized applications without the need for a full-scale, production-level Kubernetes cluster.

#### Prerequisites

*   Pre-Install Ubuntu 22.04 system
*   2 GB RAM or more
*   2 CPU or more
*   20 GB free disk space
*   Sudo used with admin access
*   Reliable Internet Connectivity
*   Docker or VirtualBox or KVM

Without any further delay, let’s jump into minikube installation steps.

1) Update Your System
---------------------

Before starting the minikube installation, it is recommended to install all available updates on your system. Run following command.

```
$ sudo apt update
$ sudo apt upgrade -y
```


![Install-Updates-Ubuntu-22-04-Apt-Command](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Install-Updates-Ubuntu-22-04-Apt-Command.png "Install Updates Ubuntu 22 04 Apt Command")

Once all the updates are installed then reboot your system.

```
$ sudo reboot
```


2) Install Docker
-----------------

Minikube requires either docker or VirtualBox, in this post, we will be installing docker on Ubuntu 22.04 system. Run the following set of command one after the another to docker apt repository.

```
$ sudo apt install ca-certificates curl gnupg wget apt-transport-https -y
$ sudo install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ sudo chmod a+r /etc/apt/keyrings/docker.gpg
$ echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt update
```


![Add-Docker-APT-Repository-Ubuntu-22-04](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Add-Docker-APT-Repository-Ubuntu-22-04.png "Add Docker APT Repository Ubuntu 22 04")

Next, install docker by running the following command.

```
$ sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```


![Install-Docker-Ubuntu-Minikube](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Install-Docker-Ubuntu-Minikube.png "Install Docker Ubuntu Minikube")

Add your local user to docker group so that your local user run docker commands without sudo.

```
$ sudo usermod -aG docker $USER
$ newgrp docker
```


Note: To make above changes into the affect logout and login.

![Add-Local-User-Docker-Group](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Add-Local-User-Docker-Group.png "Add Local User Docker Group")

3) Download and Install Minikube Binary
---------------------------------------

To download and install minikube binary, run following commands,

```
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
$ sudo install minikube-linux-amd64 /usr/local/bin/minikube
```


To verify the minikube version, run

```
$ minikube version
```


![Install-Minikube-Ubuntu-22-04](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Install-Minikube-Ubuntu-22-04.png "Install Minikube Ubuntu 22 04")

4) Install Kubectl tool
-----------------------

Kubectl is a command line tool, used to interact with your Kubernetes cluster. So, to install kubectl run beneath curl command.

```
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
```


Next, set the executable permission on it and move to /usr/local/bin

```
$ chmod +x kubectl
$ sudo mv kubectl /usr/local/bin/
```


Verify the kubectl version, run

```
$  kubectl version -o yaml
```


![Install-Kubectl-for-minikube-Ubuntu](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Install-Kubectl-for-minikube-Ubuntu.png "Install Kubectl for minikube Ubuntu")

5) Start Minikube Cluster
-------------------------

Now that Minikube is installed, start a Kubernetes cluster using the following command:

```
$ minikube start --driver=docker
```


![Start-Minikube-Cluster-Ubuntu-22-04](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Start-Minikube-Cluster-Ubuntu-22-04.png "Start Minikube Cluster Ubuntu 22 04")

This command initializes a single-node Kubernetes cluster, and it might take a few minutes to download the necessary components.

Once the minikube has started, verify the status of your cluster, run

```
$ minikube status
```


![Minikube-Status-Command-Output-Ubuntu-22-04](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Minikube-Status-Command-Output-Ubuntu-22-04.png "Minikube Status Command Output Ubuntu 22 04")

6) Interact with Your Minikube Cluster
--------------------------------------

Use kubectl to interact with your Minikube Kubernetes cluster. For example, you can check the nodes in your cluster:

```
$ kubectl get nodes
$ kubectl cluster-info
```


![Kubectl-Cluster-Node-Info-Ubuntu-Minikube](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Kubectl-Cluster-Node-Info-Ubuntu-Minikube.png "Kubectl Cluster Node Info Ubuntu Minikube")

Try to deploy a sample nginx deployment, run following set of commands.

```
$ kubectl create deployment nginx-web --image=nginx
$ kubectl expose deployment nginx-web --type NodePort --port=80
$ kubectl get deployment,pod,svc
```


![Kubectl-Deploy-Nginx-SVC-Minikube-Ubuntu-22-04](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Kubectl-Deploy-Nginx-SVC-Minikube-Ubuntu-22-04.png "Kubectl Deploy Nginx SVC Minikube Ubuntu 22 04")

7) Managing Minikube Addons
---------------------------

If you want to add some additional functionality toy Kubernetes cluster like Kubernetes dashboard, ingress controller and more. You can enable these with addons. To view all the available addons, run

```
$ minikube addons list
```


![List-Minikube-addons-Ubuntu](https://www.linuxbuzz.com/wp-content/uploads/2023/11/List-Minikube-addons-Ubuntu.png "List Minikube addons Ubuntu")

In order to enable addons, run

```
$ minikube addons enable dashboard
$ minikube addons enable ingress
```


![Enable-Minikube-Addons-Ubuntu-22-04](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Enable-Minikube-Addons-Ubuntu-22-04.png "Enable Minikube Addons Ubuntu 22 04")

To start the Kubernetes dashboard run below command, it will automatically launch the dashboard in the web browser as shown below:

```
$ minikube dashboard
```


![Starting-Kubernetes-Dashboard-Minikube](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Starting-Kubernetes-Dashboard-Minikube.png "Starting Kubernetes Dashboard Minikube")

![Kubernetes-Dashboard-GUI-Minikube-Ubuntu](https://www.linuxbuzz.com/wp-content/uploads/2023/11/Kubernetes-Dashboard-GUI-Minikube-Ubuntu.png "Kubernetes Dashboard GUI Minikube Ubuntu")

8) Managing Minikube Cluster
----------------------------

To stop and start the minikube cluster, run beneath commands.

```
$ minikube stop
$ minikube start
```


In order to delete the minikube cluster, run

```
$ minikube delete
```


That’s all from this post, we believe you have found it informative and useful. Feel free to post your queries and feedback in below comments section.
