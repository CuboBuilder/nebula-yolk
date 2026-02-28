#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo -e "\033[1;35mStarting Nebula Yolk by CuboBuilder...\033[0m"
echo -e "\033[1;32mRepository: github.com/CuboBuilder/nebula-yolk\033[0m"
echo -e "\033[1;32mFeel free to add needed packages by using pull requests.\033[0m"
echo -e "\033[1;36mRunning: ${MODIFIED_STARTUP}\033[0m"

set -m
eval ${MODIFIED_STARTUP} &
PID=$!
PGID=$(ps -o pgid= -p $PID | grep -o '[0-9]*')

SHUTTING_DOWN=0

shutdown() {
    if [ $SHUTTING_DOWN -eq 1 ]; then return; fi
    SHUTTING_DOWN=1
    
    echo -e "\n\033[1;33mShutdown requested. Stopping process group $PGID...\033[0m"
    
    kill -15 -$PGID 2>/dev/null
    
    for i in {1..30}; do
        if ! ps -o pgid= -p $PGID >/dev/null 2>&1; then
            exit 0
        fi
        sleep 1
    done

    kill -9 -$PGID 2>/dev/null
    exit 0
}

trap 'shutdown' SIGTERM SIGINT

while true; do
    if read -t 5 input; then
        if [ "$input" = "stop" ]; then shutdown; fi
    fi
    if ! ps -o pgid= -p $PGID >/dev/null 2>&1; then break; fi
done

exit 0
