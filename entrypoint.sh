#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\033[1;35mStarting Nebula Yolk by CuboBuilder...\033[0m"
echo -e "\033[1;32mRepository: github.com/CuboBuilder/nebula-yolk\033[0m"
echo -e "\033[1;32mFeel free to add needed packages by using pull requests.\033[0m"
echo -e "\033[1;36mRunning: ${MODIFIED_STARTUP}\033[0m"

eval ${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo -e "\033[1;31mStartup command failure.\033[0m"
    exit 1
fi

wait
