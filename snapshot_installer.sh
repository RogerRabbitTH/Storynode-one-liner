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