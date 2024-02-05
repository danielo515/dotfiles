#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title restart sketchybar
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName danielo

# Documentation:
# @raycast.description Restarts sketchybar
# @raycast.author Daniel Rodríguez Rivero
# @raycast.authorURL https://github.com/danielo515

# check if sketchybar is installed and running.
if ! command -v sketchybar &> /dev/null
then
    echo "sketchybar could not be found. Maybe it is not installed?"
    exit
fi
# check if sketchybar is running
if ! pgrep -x "sketchybar" > /dev/null
then
    echo "sketchybar is not running"
    exit
fi
# if it is running, restart it
brew services restart sketchybar