#!/bin/bash

# Export evm key
story validator export --export-evm-key

# Create validator
story validator create --stake 1000000000000000000 --private-key $(cat $HOME/.story/story/config/private_key.txt | grep "PRIVATE_KEY" | awk -F'=' '{print $2}')