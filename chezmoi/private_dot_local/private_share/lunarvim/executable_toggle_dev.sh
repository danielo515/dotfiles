#!/bin/bash
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
