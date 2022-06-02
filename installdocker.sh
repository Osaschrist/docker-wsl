# Install pre-required packages
sudo apt update

sudo apt install --no-install-recommends apt-transport-https ca-certificates curl gnupg2

#Configure package repository
source /etc/os-release

curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update

#Install Docker
sudo apt install docker-ce docker-ce-cli containerd.io

#Add user to group
sudo usermod -aG docker $USER

#Configure dockerd
DOCKER_DIR=/var/run
mkdir -pm o=,ug=rwx "$DOCKER_DIR"
sudo chgrp docker "$DOCKER_DIR"
sudo mkdir /etc/docker
sudo echo "{
   "hosts": ["unix:///var/run/docker.sock"]
}" >>/etc/docker/daemon.json

#Always run dockerd automatically
sudo echo ' DOCKER_DISTRO="Ubuntu-20.04"
DOCKER_DIR=/var/run
DOCKER_SOCK="$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://$DOCKER_SOCK"
if [ ! -S "$DOCKER_SOCK" ]; then
   mkdir -pm o=,ug=rwx "$DOCKER_DIR"
   sudo chgrp docker "$DOCKER_DIR"
   /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
fi ' >>/home/usuario/.profile

# Go passwordless with the launching of dockerd
sudo echo ' %docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd ' >>/etc/sudoers.tmp

#Install docker compose
COMPOSE_VERSION=1.29.2
sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
