#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ping
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }
# @raycast.packageName network

# Documentation:
# @raycast.description Does a dam ping
# @raycast.author Daniel Rodríguez Rivero
# @raycast.authorURL https://github.com/danielo515

ping -i 0.25 -t 3 "$1"

