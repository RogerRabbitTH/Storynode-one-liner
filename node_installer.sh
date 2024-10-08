#!/bin/bash
cd $HOME

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLDCYAN="\e[1;${CYAN}"
BOLDYELLOW="\e[1;${YELLOW}"
BOLDGREEN="\e[1;${GREEN}"
ENDCOLOR="\e[0m"
UNDERLINEYELLOW="\e[4;${YELLOW}"

# Get moniker name
read -p "Enter your moniker name: " moniker_name
echo -e "${BOLDGREEN}Your moniker name is: ${YELLOW}${moniker_name}${ENDCOLOR}"
sleep 2

# Update packages
echo -e "${BOLDYELLOW}Updating packages${ENDCOLOR}"
sudo apt update -y
sudo apt-get update -y

# Install packages
echo -e "${BOLDYELLOW}Installing packages${ENDCOLOR}"
sudo apt install curl git make jq build-essential gcc unzip wget lz4 aria2 -y

# Install golang
cd $HOME && \
ver="1.22.0" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version


sudo apt upgrade -y
sudo apt-get update -y

# Check if packages are installed
packages=(
  curl
  git
  make
  jq
  build-essential
  gcc
  unzip
  wget
  lz4
  aria2
)

echo -e "${BOLDYELLOW}Checking if packages are installed${ENDCOLOR}"
for package in "${packages[@]}"; do
  if dpkg -l | grep -q "^ii  $package"; then
    echo -e "${GREEN}$package is installed.${ENDCOLOR}"
  else
    echo -e "${RED}Please install the package: $package${ENDCOLOR}"
    exit 1
  fi
done

# Download Story-Geth binary
echo -e "${BOLDCYAN}Download Story-Geth binary${ENDCOLOR}"
sleep 1

wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.3-b224fdf.tar.gz
tar -xzvf geth-linux-amd64-0.9.3-b224fdf.tar.gz
[ ! -d "$HOME/go/bin" ] && mkdir -p $HOME/go/bin
if ! grep -q "$HOME/go/bin" $HOME/.bash_profile; then
  echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
fi
sudo cp geth-linux-amd64-0.9.3-b224fdf/geth $HOME/go/bin/story-geth
source $HOME/.bash_profile
echo -e "${BOLDYELLOW}Story-Geth version${ENDCOLOR}"
story-geth version

sleep 2

echo -e "${BOLDYELLOW}Download Story binary${ENDCOLOR}"
sleep 1

# Download Story binary
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.10.1-57567e5.tar.gz
tar -xzvf story-linux-amd64-0.10.1-57567e5.tar.gz
[ ! -d "$HOME/go/bin" ] && mkdir -p $HOME/go/bin
if ! grep -q "$HOME/go/bin" $HOME/.bash_profile; then
  echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
fi
cp $HOME/story-linux-amd64-0.10.1-57567e5/story $HOME/go/bin
source $HOME/.bash_profile
echo -e "${BOLDYELLOW}Story version${ENDCOLOR}"
story version

# Initialize Story node
story init --network iliad --moniker "${moniker_name}"

sleep 2

# Create story-geth service
echo -e "${BOLDCYAN}Creating story-geth service${ENDCOLOR}"
sleep 1

sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story-geth --iliad --syncmode full
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Create story service
echo -e "${BOLDCYAN}Creating story service${ENDCOLOR}"
sleep 1
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Consensus Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story run
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Update persistent_peers
echo -e "${BOLDYELLOW}Updating persistent_peers${ENDCOLOR}"
sleep 1

PEERS=$(curl -s -X POST https://rpc-story.josephtran.xyz -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_info","params":[],"id":1}' | jq -r '.result.peers[] | select(.connection_status.SendMonitor.Active == true) | "\(.node_info.id)@\(if .node_info.listen_addr | contains("0.0.0.0") then .remote_ip + ":" + (.node_info.listen_addr | sub("tcp://0.0.0.0:"; "")) else .node_info.listen_addr | sub("tcp://"; "") end)"' | tr '\n' ',' | sed 's/,$//' | awk '{print "\"" $0 "\""}')
sed -i "s/^persistent_peers *=.*/persistent_peers = $PEERS/" "$HOME/.story/story/config/config.toml"
    if [ $? -eq 0 ]; then
echo -e "Configuration file updated successfully with new peers"
    else
echo "Failed to update configuration file."
fi

# Clear unnecessary files
echo -e "${BOLDYELLOW}Clearing unnecessary files${ENDCOLOR}"
sleep 2

rm geth-linux-amd64-0.9.3-b224fdf.tar.gz
rm story-linux-amd64-0.10.1-57567e5.tar.gz
rm node_installer.sh

# Start services
echo -e "${BOLDGREEN}Starting services${ENDCOLOR}"
sleep 2

sudo systemctl daemon-reload && \
sudo systemctl start story-geth && \
sudo systemctl enable story-geth

sudo systemctl daemon-reload && \
sudo systemctl start story && \
sudo systemctl enable story

echo -e "${BOLDGREEN}SUCCESS !!!${ENDCOLOR}"
echo -e "${BOLDGREEN}Services started${ENDCOLOR}"
echo -e "${BOLDGREEN}Back to main menu${ENDCOLOR}"
sleep 2
