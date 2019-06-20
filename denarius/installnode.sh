#!/bin/sh

echo "Updating Linux Packages"
sudo apt-get update -y

echo "Installing PWGEN"
sudo apt-get install -y pwgen

echo "Populate denarius.conf"
cd ~
mkdir ~/.denarius
    # Get VPS IP Address
    VPSIP=$(curl ipinfo.io/ip)
    # create rpc user and password
    rpcuser=$(openssl rand -base64 24)
    # create rpc password
    rpcpassword=$(openssl rand -base64 48)
    echo -n "What is your fortunastakeprivkey? (Hint:genkey output)"
    read FORTUNASTAKEPRIVKEY
    echo -e "rpcuser=$rpcuser\nrpcpassword=$rpcpassword\nserver=1\nlisten=1\ndaemon=0\nport=9999\naddnode=denarius.host\naddnode=denarius.win\naddnode=denarius.pro\naddnode=triforce.black\nrpcallowip=127.0.0.1\nexternalip=$VPSIP:9999\nfortunastake=1\nfortunastakeprivkey=$FORTUNASTAKEPRIVKEY" > ~/.denarius/denarius.conf

echo "Get Chaindata"
sudo apt-get -y install wget unzip
cd ~/.denarius
rm -rf database txleveldb smsgDB
wget https://github.com/carsenk/denarius/releases/download/v3.3.9.1/chaindata2022527.zip
unzip chaindata2022527.zip
cd ~

echo "Installing 2G Swapfile"
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Intalling fail2ban"
sudo apt install fail2ban -y

echo "Installing Firewall"
sudo apt install ufw -y
ufw default allow outgoing
ufw default deny incoming
ufw allow ssh/tcp
ufw limit ssh/tcp
ufw allow 33369/tcp
ufw allow 9999/tcp
ufw logging on
ufw --force enable

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

echo "make docker-compose directory"
mkdir ~/d
cd ~/d

echo "get docker-compose.yml"
wget https://raw.githubusercontent.com/buzzkillb/installdocker/master/denarius/docker-compose.yml

echo "run docker compose denariusd"
docker-compose up -d

echo "Run Watchtower for autoupdates to carsenk/denarius repo"
docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
