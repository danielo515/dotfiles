#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title restart yabai
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName danielo

# Documentation:
# @raycast.description Restarts yabai
# @raycast.author Daniel Rodríguez Rivero
# @raycast.authorURL https://github.com/danielo515

# check if yabai is installed and running.
if ! command -v yabai &> /dev/null
then
    echo "yabai could not be found. Maybe it is not installed?"
    exit
fi
# check if yabai is running
if ! pgrep -x "yabai" > /dev/null
then
    echo "yabai is not running"
    yabai --start-service
    exit
fi
# if it is running, restart it
yabai --restart-service

