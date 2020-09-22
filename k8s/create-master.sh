#!/bin/bash
echo "😺 creating k8s master"
sudo source /home/ubuntu/scripts/env.sh

sudo hostnamectl set-hostname k8s-master

JOIN=$(kubeadm init --pod-network-cidr=10.244.0.0/16)

sudo echo $JOIN > /etc/kubernetes/join.conf

sudo scp -i /home/ubuntu/certs/aws_k8s.pem /etc/kubernetes/join.conf $EC2_USER@$WORKER_NODE:/home/ubuntu/worker_node/join.conf

export KUBECONFIG=/etc/kubernetes/admin.conf

sudo kubectl apply -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml

sudo mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "🥳 k8s master created"
