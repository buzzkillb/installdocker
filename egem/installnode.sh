#!/bin/sh

echo "Updating Linux Packages"
sudo apt-get update -y

echo "Intalling fail2ban"
sudo apt install fail2ban -y

echo "Installing Docker Packages"
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

echo " Add Docker's official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Setup stable repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "Update the apt package index"
sudo apt-get update -y

echo "Installing latest version of Docker"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

echo "Verifying Docker Installed Correctly"
sudo docker run hello-world

echo "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "Apply executable permissions to the binary"
sudo chmod +x /usr/local/bin/docker-compose

echo "make compose directory"
mkdir DD

echo "get docker-compose.yml"
wget https://raw.githubusercontent.com/buzzkillb/installdocker/master/egem/docker-compose.yml

echo "run docker compose go-egem"
docker-compose up -d

echo "Run Watchtower for autoupdates to go-egem repo"
docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
