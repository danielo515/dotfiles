#!/bin/bash
# After chezmoi setups the machine, run the brew bundle installation
brew bundle "$(chezmoi source-path)/Brewfile"
