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

shutdown() {
    echo -e "\n\033[1;33mShutdown requested. Gracefully stopping all processes...\033[0m"
    
    kill -15 -0 2>/dev/null
    
    for i in {1..30}; do
        if ! kill -0 $PID 2>/dev/null; then
            echo -e "\033[1;32mAll processes stopped.\033[0m"
            exit 0
        fi
        sleep 1
    done

    echo -e "\033[1;31mProcesses did not finish in 30s. Force killing...\033[0m"
    kill -9 -0 2>/dev/null
    exit 0
}

trap 'shutdown' SIGTERM SIGINT

while kill -0 $PID 2>/dev/null; do
    read -t 1 input
    if [ "$input" = "stop" ]; then
        shutdown
    fi
done

wait $PID
echo -e "\033[1;32mProcess finished naturally.\033[0m"
exit 0
