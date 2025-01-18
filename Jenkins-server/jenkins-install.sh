#!/bin/bash

sudo dnf update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf upgrade -y
sudo dnf install -y fontconfig java-17-openjdk
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk" | sudo tee -a /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" | sudo tee -a /etc/profile
source /etc/profile
java -version

sudo dnf install -y jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins.service
sudo systemctl start jenkins.service
sudo systemctl status jenkins.service

sudo yum install git* -y
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

sudo curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mkdir -p $HOME/bin
sudo cp ./kubectl $HOME/bin/kubectl
echo 'export PATH=$PATH:$HOME/bin' | sudo tee -a $HOME/.bashrc
source $HOME/.bashrc
kubectl version --client
