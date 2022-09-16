#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Danielo chrome
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName danielo.es

# Documentation:
# @raycast.description Opens chrome with my profile
# @raycast.author Danielo

open -n -a "Google Chrome" --args --profile-directory="Profile 1"
