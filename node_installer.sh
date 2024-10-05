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

echo -e "${BOLDCYAN}
  __                            _                  _                    
 (_   _ ._ o ._ _|_   |_       |_)  _   _   _  ._ |_)  _. |_  |_  o _|_ 
 __) (_ |  | |_) |_   |_) \/   | \ (_) (_| (/_ |  | \ (_| |_) |_) |  |_ 
             |            /             _|                              
"
echo -e "${UNDERLINEYELLOW}Special thanks to josephtran for his documentation.${ENDCOLOR}"
sleep 2

read -p "Enter your moniker name: " moniker_name
echo -e "${BOLDGREEN}Your moniker name is: ${YELLOW}${moniker_name}${ENDCOLOR}"
sleep 2

echo -e "${BOLDYELLOW}Updating packages${ENDCOLOR}"
sudo apt update
sudo apt-get update

echo -e "${BOLDYELLOW}Installing packages${ENDCOLOR}"
sudo apt install curl git make jq build-essential gcc unzip wget lz4 aria2 -y

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

story init --network iliad --moniker "${moniker_name}"

sleep 2

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

echo -e "${BOLDYELLOW}Updating persistent_peers${ENDCOLOR}"
sleep 1

PEERS="a320f8a15892bddd7b5502527e0d11c5b5b9d0e3@69.67.150.107:29931,2f372238bf86835e8ad68c0db12351833c40e8ad@story-testnet-rpc.itrocket.net:26656,d4c5dcfbec11d80399bcf18d83a157259ca3efc7@138.201.200.100:26656,15c7e2b630c04ee11b2c3cfbfb1ede0379df9407@52.74.117.64:26656,359e4420e63db005d8e39c490ad1c1c329a68df3@3.222.216.118:26656,eeb7d2096a887f8ff8fdde2695c394fcf5a19273@194.238.30.192:36656,0b512c9a4421c0259813aaa05c865f82365fa7c0@3.1.137.11:26656,f4d96bf0dc67a05a48287ca2c821bc8e1d2b2023@63.35.134.129:26656,5e4f9ce2d20f2d3ef7f5c92796b1b954384cbfe1@34.234.176.168:26656,371ee318d105b0239b3997c287068ccbbcd46a91@3.248.113.42:26656,df40eee673df8eb3eddd10b359539f0e86ecaee3@207.244.230.111:36656,c82d2b5fe79e3159768a77f25eee4f22e3841f56@3.209.222.59:26656,960278d079a111b44c207dca7c2ffac640b477d1@44.223.234.211:26656,1708afbf73e2fbbb5a943aa2d97c976bf8e0d25c@52.9.183.131:26656,1cceccb08bae25a0f91fe85b0ca562fa791f47aa@184.169.154.204:26656,8876a2351818d73c73d97dcf53333e6b7a58c114@3.225.157.207:26656,0a2bc2ce69b7292deaf0b6a33af76bf9b2e25ec6@88.198.46.55:41656,6bb4ed28b08a186fc1373cfc2e96b83165c1e882@162.55.245.254:33656,a2fe3dfd6396212e8b4210708e878de99307843c@54.209.160.71:26656,aac5871efa351872789eef15c2da7a55a68abdad@88.218.226.79:26656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.story/story/config/config.toml

echo -e "${BOLDYELLOW}Clearing unnecessary files${ENDCOLOR}"
sleep 2

rm geth-linux-amd64-0.9.3-b224fdf.tar.gz
rm story-linux-amd64-0.10.1-57567e5.tar.gz
rm node_installer.sh

echo -e "${BOLDGREEN}Starting services${ENDCOLOR}"
sleep 2

sudo systemctl daemon-reload && \
sudo systemctl start story-geth && \
sudo systemctl enable story-geth

sudo systemctl daemon-reload && \
sudo systemctl start story && \
sudo systemctl enable story && \