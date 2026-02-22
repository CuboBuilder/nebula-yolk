#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\033[1;33mStarting Nebula Yolk...\033[0m"
echo -e "\033[1;32mRunning: ${MODIFIED_STARTUP}\033[0m"

eval ${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo -e "\033[1;31mStartup command failed.\033[0m"
    exit 1
fi
