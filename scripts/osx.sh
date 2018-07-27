#!/bin/bash
# OSX.sh

# -- Homebrew ------------------------------------------------------------------

if exists "brew"; then
  echo_item "Homebrew is already installed" green
else
  if get_boolean_response "Do you want to install Homebrew?"; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo_item "Skipping Homebrew install" "red"
  fi
fi

echo ""

# -- rbenv ---------------------------------------------------------------------

if exists "rbenv"; then
  echo_item "rbenv is already installed" green
else
  if get_boolean_response "Do you want to install rbenv?"; then
    brew install rbenv ruby-install
    rbenv rehash
  else
    echo_item "Skipping rbenv install" red
  fi
fi

echo ""

# -- npm -----------------------------------------------------------------------

if exists "npm"; then
  echo_item "npm is already installed" green
else
  if get_boolean_response "Do you want to install node+npm?"; then
    brew install node
    source ./node.sh
  else
    echo_item "Skipping npm install" red
  fi
fi

echo ""

# -- Fonts -----------------------------------------------------------------------


if get_boolean_response "Do you want to install brew fonts?"; then
  brew tap caskroom/fonts
  brew cask install font-inconsolata-nerd-font
else
  echo_item "Skipping fonts install" red
fi


echo ""

# -- zsh -----------------------------------------------------------------------

if exists "zsh"; then
  echo_item "zsh is already installed" green
else
  if get_boolean_response "Do you want to install zsh?"; then
    brew install zsh
  else
    echo_item "Skipping zsh install" red
  fi
fi

echo ""

# -- Neovim --------------------------------------------------------------------

if exists "nvim"; then
  echo_item "Neovim is already installed" green
else
  if get_boolean_response "Do you want to install Neovim?"; then
    brew install --HEAD neovim
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    echo_item "Skipping Neovim install" red
  fi
fi
