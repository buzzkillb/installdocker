#!/bin/sh

echo "Updating Linux Packages"
apt-get update -y

echo "Intalling fail2ban"
apt install fail2ban -y

echo "Installing Docker Packages"
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

echo " Add Docker's official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "Setup stable repository"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "Update the apt package index"
apt-get update -y

echo "Installing latest version of Docker"
apt-get install docker-ce docker-ce-cli containerd.io -y

echo "Verifying Docker Installed Correctly"
docker run hello-world

echo "Installing docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "Apply executable permissions to the binary"
chmod +x /usr/local/bin/docker-compose
