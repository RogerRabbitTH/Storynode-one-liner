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

echo -e "Please make sure that:\n1. You have at least 1 IP on your node wallet.\n2. Your node is fully synced; 'catching_up' is 'false'."
sleep 2

echo -e "${BOLDYELLOW}Do you want to create validator? (y/n)${ENDCOLOR}"

# Confirm create validator
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

# Export evm key
story validator export --export-evm-key

# Create validator
story validator create --stake 1000000000000000000 --private-key $(cat $HOME/.story/story/config/private_key.txt | grep "PRIVATE_KEY" | awk -F'=' '{print $2}')