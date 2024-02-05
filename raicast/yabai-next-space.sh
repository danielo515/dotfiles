#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title yabai next space
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ➡️
# @raycast.packageName danielo

# Documentation:
# @raycast.description move to next space
# @raycast.author Daniel Rodríguez Rivero
# @raycast.authorURL https://github.com/danielo515

# Moves the current to the next space
yabai -m window --space next && yabai -m space --focus next