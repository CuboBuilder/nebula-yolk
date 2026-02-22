#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
eval ${MODIFIED_STARTUP}
