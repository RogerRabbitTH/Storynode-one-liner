#!/bin/bash

cd $HOME
mkdir -p StoryNode
cd StoryNode

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLDCYAN="\e[1;${CYAN}"
BOLDYELLOW="\e[1;${YELLOW}"
BOLDGREEN="\e[1;${GREEN}"
ENDCOLOR="\e[0m"

show_main_menu() {
    echo -e "${BOLDCYAN}Main Menu - Please select an option:${ENDCOLOR}"
    echo "1. Node Install"
    echo "2. Snapshot Install"
    echo "3. Update Node"
    echo "4. CheckNode Status"
    echo "5. Exit"
}

handle_main_choice() {
    case $1 in
        1)
            echo -e "${BOLDGREEN}Node Install...${ENDCOLOR}"
            curl -O https://raw.githubusercontent.com/RogerRabbitTH/Storynode-one-liner/main/node_installer.sh && chmod +x node_installer.sh && ./node_installer.sh
            ;;
        2)
            echo -e "${BOLDGREEN}Snapshot Install...${ENDCOLOR}"
            curl -O https://raw.githubusercontent.com/RogerRabbitTH/Storynode-one-liner/main/snapshot_installer.sh && chmod +x snapshot_installer.sh && ./snapshot_installer.sh
            ;;
        3)
            echo -e "${BOLDGREEN}Update Node...${ENDCOLOR}"
            curl -O https://raw.githubusercontent.com/RogerRabbitTH/Storynode-one-liner/main/update_node.sh && chmod +x update_node.sh && ./update_node.sh
            ;;
        4)
            echo -e "${BOLDGREEN}Node Status...${ENDCOLOR}"
            curl -O https://raw.githubusercontent.com/RogerRabbitTH/Storynode-one-liner/main/nodeStatus.sh && chmod +x nodeStatus.sh && ./nodeStatus.sh
            ;;
        5)
            echo -e "${BOLDYELLOW}Exiting...${ENDCOLOR}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${ENDCOLOR}"
            ;;
    esac
}

while true; do
    echo "
    ███████╗████████╗ ██████╗ ██████╗ ██╗   ██╗    ███╗   ██╗ ██████╗ ██████╗ ███████╗
    ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝    ████╗  ██║██╔═══██╗██╔══██╗██╔════╝
    ███████╗   ██║   ██║   ██║██████╔╝ ╚████╔╝     ██╔██╗ ██║██║   ██║██║  ██║█████╗  
    ╚════██║   ██║   ██║   ██║██╔══██╗  ╚██╔╝      ██║╚██╗██║██║   ██║██║  ██║██╔══╝  
    ███████║   ██║   ╚██████╔╝██║  ██║   ██║       ██║ ╚████║╚██████╔╝██████╔╝███████╗
    ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝                                                                                                        
    "
    echo -e "${UNDERLINEYELLOW}Special thanks to josephtran for his documentation.${ENDCOLOR}"
    show_main_menu
    read -p "Enter your choice: " choice
    handle_main_choice $choice
done
