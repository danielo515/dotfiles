#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title LunarVimF
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗂
# @raycast.packageName danielo.es

# Documentation:
# @raycast.description FVim for lunarvim
# @raycast.author Danielo


export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"/Users/danielo/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"/Users/danielo/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"/Users/danielo/.cache/nvim"}"

exec /Applications/FVim.app/Contents/MacOS/FVim --nvim lvim "$@"
