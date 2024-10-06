#!/bin/bash
cd $HOME

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLDCYAN="\e[1;${CYAN}"
BOLDYELLOW="\e[1;${YELLOW}"
BOLDGREEN="\e[1;${GREEN}"
BOLDRED="\e[1;${RED}"
ENDCOLOR="\e[0m"
UNDERLINEYELLOW="\e[4;${YELLOW}"

confirm_continue() {
    while true; do
        read -p "Enter your choice: " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            return 0 
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "${RED}Operation cancelled by user.${ENDCOLOR}"
            exit 1
        else
            echo -e "${YELLOW}Please enter 'y' for yes or 'n' for no.${ENDCOLOR}"
        fi
    done
}

echo -e "${BOLDCYAN}
  __                            _                  _                    
 (_   _ ._ o ._ _|_   |_       |_)  _   _   _  ._ |_)  _. |_  |_  o _|_ 
 __) (_ |  | |_) |_   |_) \/   | \ (_) (_| (/_ |  | \ (_| |_) |_) |  |_ 
             |            /             _|                              
"
echo -e "${UNDERLINEYELLOW}Special thanks to josephtran for his documentation.${ENDCOLOR}"
sleep 2

echo -e "${BOLDRED}WARNING: Do not upgrade before block height 1,325,860.${ENDCOLOR}"
sleep 2

echo -e "${BOLDYELLOW}Do you want to update the node? (y/n)${ENDCOLOR}"
confirm_continue

####### update node #######

echo -e "${BOLDYELLOW}Stopping node${ENDCOLOR}"
sudo systemctl stop story
sleep 2

echo -e "${BOLDCYAN}Downloading new binary${ENDCOLOR}"

cd $HOME
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.11.0-aac4bfe.tar.gz
tar -xzvf story-linux-amd64-0.11.0-aac4bfe.tar.gz
sleep 2

echo -e "${BOLDCYAN}Replace new binary version${ENDCOLOR}"
cp $HOME/story-linux-amd64-0.11.0-aac4bfe/story $(which story)
source $HOME/.bash_profile
story version

echo -e "${BOLDYELLOW}Restart node${ENDCOLOR}"
sudo systemctl daemon-reload && \
sudo systemctl start story &&\
sudo systemctl status story

echo -e "${BOLDGREEN}Node updated successfully${ENDCOLOR}"
