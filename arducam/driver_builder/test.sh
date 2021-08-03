#!/bin/bash

echo -e "\033[33m A directory named 'Arducam' will be created in your home directory. If you want to change the download path, cancel the process and change the ROOT_PATH variable in the script. \033[0m"
read -p "Press any key to continue..."

ROOT_PATH="${HOME}/Arducam"
[ "$(ls -A ${ROOT_PATH})" ] && echo -e "\033[31m'${ROOT_PATH}' already exists and is not empty. Please change 'ROOT_PATH' in the script to select another directory.\033[0m"

[ -d ${ROOT_PATH} ] && echo "Directory ${ROOT_PATH} exists and is empty. Continuing..." || mkdir ${ROOT_PATH}

