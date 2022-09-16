#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Lvide
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName LunarVim

# Documentation:
# @raycast.description neovide for lunarvim
# @raycast.author Danielo

export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"/Users/danielo/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"/Users/danielo/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"/Users/danielo/.cache/nvim"}"

exec neovide -- -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"

