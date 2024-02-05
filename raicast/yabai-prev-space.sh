#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yabai previous space
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ⬅️ 
# @raycast.packageName danielo

# Documentation:
# @raycast.description move to previous space
# @raycast.author Daniel Rodríguez Rivero
# @raycast.authorURL https://github.com/danielo515

# Moves the current to the previous space
yabai -m window --space prev && yabai -m space --focus prev