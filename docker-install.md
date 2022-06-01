# Docker installation on WSL
### Start by removing any old docker related installation using the following command 
`sudo apt remove docker docker-engine docker.io containerd runc`

# Start the Installation
## Install pre-required packages 
`sudo apt update`

`sudo apt install --no-install-recommends apt-transport-https ca-certificates curl gnupg2`

# Configure package repository using the following commands
`source /etc/os-release`

`curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -`

`echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list`

`sudo apt update`

## Install Docker 
`sudo apt install docker-ce docker-ce-cli containerd.io
`
### After installing docker, you need to add user to group 
`sudo usermod -aG docker $USER
`
## Configure dockerd which is the docker deamon
`DOCKER_DIR=/var/run`
`mkdir -pm o=,ug=rwx "$DOCKER_DIR"`
`sudo chgrp docker "$DOCKER_DIR"`
`sudo mkdir /etc/docker`
`sudo nano /etc/docker/daemon.json`

Inside the file you have to add this line and save it.

```Bash
{
   "hosts": ["unix:///var/run/docker.sock"]
} 
```
## Now that your docker deamon is configured, it is time to confige it so that it runs automatically.

### To always run it automatically
 
 * Add the following to `.bashrc` or `.profile` (make sure “DOCKER_DISTRO” matches your distro, you can check it by running “wsl -l -q” in Powershell).

 ```Bash
DOCKER_DISTRO="Ubuntu-20.04"
DOCKER_DIR=/var/run
DOCKER_SOCK="$DOCKER_DIR/docker.sock"
export DOCKER_HOST="unix://$DOCKER_SOCK"
if [ ! -S "$DOCKER_SOCK" ]; then
   mkdir -pm o=,ug=rwx "$DOCKER_DIR"
   sudo chgrp docker "$DOCKER_DIR"
   /mnt/c/Windows/System32/wsl.exe -d $DOCKER_DISTRO sh -c "nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1"
fi
 ```
 # Want to go passwordless with the launching od dockerd?
_All you need to do is_

`sudo visudo`

and add the following line below
`%docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd`

# Install Docker Compose 
`COMPOSE_VERSION=1.29.2`
`sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

In order to make the binary file ejecutable, you have to give it the ejecution command.

`sudo chmod +x /usr/local/bin/docker-compose`
