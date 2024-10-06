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

return_to_menu() {
    while true; do
        echo -e "${BOLDYELLOW}Do you want to return to the main menu? (y/n)${ENDCOLOR}"
        read -p "Enter your choice: " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            echo -e "${BOLDGREEN}Returning to main menu...${ENDCOLOR}"
            curl -O https://raw.githubusercontent.com/RogerRabbitTH/Storynode-one-liner/main/main.sh && chmod +x main.sh && ./main.sh
            exit 0
        elif [[ "$choice" == "n" || "$choice" == "N" ]]; then
            echo -e "${BOLDGREEN}Exiting...${ENDCOLOR}"
            exit 0
        else
            echo -e "${YELLOW}Please enter 'y' for yes or 'n' for no.${ENDCOLOR}"
        fi
    done
}

echo -e "${BOLDYELLOW}This script may take 30 minutes to 1 hour to complete. Do you want to continue? (y/n)${ENDCOLOR}"

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

echo -e "${BOLDYELLOW}INSTALLING TOOLS${ENDCOLOR}"
sleep 2

echo -e "${BOLDYELLOW}STOP NODE${ENDCOLOR}"
sleep 1
sudo systemctl stop story
sudo systemctl stop story-geth


echo -e "${BOLDGREEN}DOWNLOADING SNAPSHOT${ENDCOLOR}"
sleep 2

echo -e "${BOLDCYAN}DOWNLOADING STORY SNAPSHOT${ENDCOLOR}"
cd $HOME
rm -f Story_snapshot.lz4
wget --show-progress https://story.josephtran.co/Story_snapshot.lz4
sleep 2

echo -e "${BOLDCYAN}DOWNLOADING GETH SNAPSHOT${ENDCOLOR}"
cd $HOME
rm -f Geth_snapshot.lz4
wget --show-progress https://story.josephtran.co/Geth_snapshot.lz4

echo -e "${BOLDGREEN}Backup priv_validator_state.json${ENDCOLOR}"
sleep 2

cp ~/.story/story/data/priv_validator_state.json ~/.story/priv_validator_state.json.backup

echo -e "${RED}Remove old data${ENDCOLOR}"

echo -e "${BOLDYELLOW}Decompress snapshot${ENDCOLOR}"
sleep 2

echo -e "${BOLDCYAN}Decompress story snapshot${ENDCOLOR}"
sudo mkdir -p /root/.story/story/data
lz4 -d -c Story_snapshot.lz4 | pv | sudo tar xv -C ~/.story/story/ > /dev/null
sleep 2

echo -e "${BOLDCYAN}Decompress geth snapshot${ENDCOLOR}"
sudo mkdir -p /root/.story/geth/iliad/geth/chaindata
lz4 -d -c Geth_snapshot.lz4 | pv | sudo tar xv -C ~/.story/geth/iliad/geth/ > /dev/null
sleep 2

echo -e "${BOLDYELLOW}Move priv_validator_state.json back${ENDCOLOR}"
sleep 2

cp ~/.story/priv_validator_state.json.backup ~/.story/story/data/priv_validator_state.json

echo -e "${BOLDYELLOW}Restart node${ENDCOLOR}"

sudo systemctl start story
sudo systemctl start story-geth
sleep 2

echo -e "${BOLDGREEN}SUCCESS !!!${ENDCOLOR}"

return_to_menu