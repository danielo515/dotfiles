#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title start borders
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName danielo515/borders

# Documentation:
# @raycast.description Starts the borders service
# @raycast.author danielo
# @raycast.authorURL https://raycast.com/danielo.es

if ! command -v borders &> /dev/null; then
  echo "borders command is required "
  exit 1
fi
if ps -ef | grep borders | grep -v grep &> /dev/null; then
  echo "borders is already running"
  killall borders
fi
nohup borders &

