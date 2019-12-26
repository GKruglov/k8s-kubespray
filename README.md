# About project

This project is intended to simplify the deployment of Kubernetes clusters on local machines for R&D, development, testing and learning purposes. The Kubernetes cluster is deployed using Kubespray on VirtualBox-powered Vagrant environment.

## Getting Started

These instructions will help you deploy a default cluster of three kubernetes nodes, a master node and two worker nodes. The master node also plays the Ansible control machine role.

### Prerequisites

VirtualBox and Vagrant with guest additions must be installed.

## Deploy Kubernetes cluster

### 1. Create and provision Vagrant machines

```
vagrant up
```

### 2. SSH into Master node

```
vagrant ssh master
```

### 3. Deploy cluster

```
cd ~/kubespray/

ansible-playbook -i /vagrant/inventory.ini cluster.yml -b -v --private-key=~/.ssh/id_rsa

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes
```

## Author

Gennadiy Kruglov (https://www.linkedin.com/in/gennadiy-kruglov/)