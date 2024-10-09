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

echo -e "${RED}Backup your data, private key, validator key before remove node.${ENDCOLOR}"
sleep 2

echo -e "${BOLDYELLOW}Do you want to delete the node? (y/n)${ENDCOLOR}"

# Confirm delete node
while true; do
    read -p "Enter your choice: " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        break
    elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
        echo -e "${RED}Operation cancelled by user.${ENDCOLOR}"
        exit 1
    else
        echo -e "${YELLOW}Please enter 'y' for yes or 'n' for no.${ENDCOLOR}"
    fi
done

# Delete node
sudo systemctl stop story-geth
sudo systemctl stop story
sudo systemctl disable story-geth
sudo systemctl disable story
sudo rm /etc/systemd/system/story-geth.service
sudo rm /etc/systemd/system/story.service
sudo systemctl daemon-reload
sudo rm -rf $HOME/.story
sudo rm $HOME/go/bin/story-geth
sudo rm $HOME/go/bin/story

echo -e "${BOLDYELLOW}Node deleted successfully${ENDCOLOR}"