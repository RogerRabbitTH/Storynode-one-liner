#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLDCYAN="\e[1;${CYAN}"
BOLDYELLOW="\e[1;${YELLOW}"
BOLDGREEN="\e[1;${GREEN}"
ENDCOLOR="\e[0m"

show_menu() {
    echo -e "${BOLDCYAN}Please select an option:${ENDCOLOR}"
    echo "1. Checking logs story-geth"
    echo "2. Checking logs story"
    echo "3. Checking sync status"
    echo "4. Check block sync left"
    echo "5. Restart node"
    echo "6. Return to Main Menu"
}

handle_choice() {
    case $1 in
        1)
            echo -e "${BOLDGREEN}Checking logs story-geth${ENDCOLOR}"
            echo -e "${BOLDYELLOW}Press Ctrl+C to stop${ENDCOLOR}"
            trap 'echo -e "\nReturning to menu..."; return_to_menu' SIGINT
            sudo journalctl -u story-geth -f -o cat
            ;;
        2)
            echo -e "${BOLDGREEN}Checking logs story${ENDCOLOR}"
            echo -e "${BOLDYELLOW}Press Ctrl+C to stop${ENDCOLOR}"
            trap 'echo -e "\nReturning to menu..."; return_to_menu' SIGINT
            sudo journalctl -u story -f -o cat
            ;;
        3)
            echo -e "${BOLDGREEN}Checking sync status${ENDCOLOR}"
            echo -e "${BOLDYELLOW}Press Ctrl+C to stop${ENDCOLOR}"
            trap 'echo -e "\nReturning to menu..."; return_to_menu' SIGINT
            curl localhost:26657/status | jq
            ;;
        4)
            echo -e "${BOLDGREEN}Check block sync left${ENDCOLOR}"
            echo -e "${BOLDYELLOW}Press Ctrl+C to stop${ENDCOLOR}"
            trap 'echo -e "\nReturning to menu..."; return_to_menu' SIGINT
            while true; do
                local_height=$(curl -s localhost:26657/status | jq -r '.result.sync_info.latest_block_height');
                network_height=$(curl -s https://rpc-story.josephtran.xyz/status | jq -r '.result.sync_info.latest_block_height');
                blocks_left=$((network_height - local_height));
                echo -e "\033[1;38mYour node height:\033[0m \033[1;34m$local_height\033[0m | \033[1;35mNetwork height:\033[0m \033[1;36m$network_height\033[0m | \033[1;29mBlocks left:\033[0m \033[1;31m$blocks_left\033[0m";
                sleep 5;
            done
            ;;
        5)
            echo -e "${BOLDYELLOW}Restart node${ENDCOLOR}"
            sudo systemctl daemon-reload && \
            sudo systemctl start story-geth && \
            sudo systemctl enable story-geth

            sudo systemctl daemon-reload && \
            sudo systemctl start story && \
            sudo systemctl enable story
            sleep 2
            echo -e "${BOLDGREEN}Node Successfully Restarted${ENDCOLOR}"
            # Automatically return to the menu after restarting
            return_to_menu
            ;;
        6)
            echo -e "${BOLDGREEN}Returning to main menu...${ENDCOLOR}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${ENDCOLOR}"
            ;;
    esac
}

return_to_menu() {
    while true; do
        show_menu
        read -p "Enter your choice: " choice
        handle_choice $choice
    done
}

# Start the menu loop
return_to_menu