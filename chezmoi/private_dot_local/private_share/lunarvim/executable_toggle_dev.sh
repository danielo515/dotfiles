#!/bin/bash
# Toggle between using normal lunarvim installation
# and your local clone.
# This script is very basic and dumb.
# It relies in the existence of a folder (or a symlink to a folder)
# in the same directory that contains or points to your local clone
# Such folder/link must be named lvim_dev
cd ~/.local/share/lunarvim/ || exit
if test -d lvim_dev; then
  echo "Entering dev mode"
  mv lvim lvim_back
  mv lvim_dev lvim
else
  test ! -d lvim_back && echo "Error! no lvim_back" && exit 1
  mv lvim lvim_dev
  mv lvim_back lvim
fi
