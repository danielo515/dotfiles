#!/bin/bash
# OSX.sh

# -- Avoid network temp files ------------------------------------------------------------------
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
# -- Screenshots ------------------------------------------------------------------
screenshotsFolder="$HOME/Documents/screenshots"
if get_boolean_response "Create a folder for the screenshots at $screenshotsFolder?"; then
    mkdir "$screenshotsFolder"
    defaults write com.apple.screencapture location  "$screenshotsFolder"
else
    echo_item "Skip changing default screenshots folder" "red"
fi

# -- Homebrew ------------------------------------------------------------------

if exists "brew"; then
    echo_item "Homebrew is already installed" green
else
    if get_boolean_response "Do you want to install Homebrew?"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $DOTFILES/bash/bash_profile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo_item "Skipping Homebrew install" "red"
    fi
fi

echo ""

if exists "brew"; then
    # -- Fonts ------------------------------------------------------------------
    if get_boolean_response "Do you want to initialize cask fonts ?"; then
        brew tap homebrew/cask-fonts                  # you only have to do this once!
    else
        echo_item "Skip font installation" "red"
    fi
    
    do_if_yes "Install python3 ?" "brew install python3"
    do_if_yes "Install iterm ?" "brew install iterm2"
    
    echo ""
    if get_boolean_response "Do you want to install some fonts?"; then
        brew install --cask font-inconsolata-nerd-font
        brew install --cask font-inconsolata
        brew install --cask font-fira-code
    else
        echo_item "Skipping fonts install" red
    fi
    # -- Software (desktop apps) ---------------------------------------------------------------------
    if exists "code"; then
        echo_item "Visual studio Code is already installed" green
    else
        if get_boolean_response "Do you want to install Visual Studio code?"; then
            brew install visual-studio-code
        else
            echo_item "Skipping visual studio code install" red
        fi
    fi
    if exists "chrome"; then
        echo_item "Chrome is already installed" green
    else
        if get_boolean_response "Do you want to install Chrome?"; then
            brew install google-chrome
        else
            echo_item "Skipping google-chrome install" red
        fi
    fi
    if get_boolean_response "Install silver_searcher? (required by fzf.vim)"; then
        brew install the_silver_searcher
    fi
    if get_boolean_response "Install rigrep? (used by fzf.vim"; then
        brew install ripgrep
    fi
    if get_boolean_response "Install tmux?"; then
        brew install tmux reattach-to-user-namespace
    fi
else
    echo_item "Brew is not installed, skipping installations that requires it" red
fi

echo ""

# -- Node/NPM/Yarn -----------------------------------------------------------------------

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

if exists "yarn"; then
    echo_item "yarn is already installed" green
else
    if get_boolean_response "Do you want to install yarn?"; then
        brew install yarn --without-node
    else
        echo_item "Skipping yarn install" red
    fi
fi

echo ""
# -- rlwrap -----------------------------------------------------------------------

if exists "rlwrap"; then
    echo_item "rlwrap is already installed" green
else
    if get_boolean_response "Do you want to install rlwrap?"; then
        brew install rlwrap
    else
        echo_item "Skipping rlwrap install" red
    fi
fi

echo ""
# -- telnet -----------------------------------------------------------------------

if exists "telnet"; then
    echo_item "telnet is already installed" green
else
    if get_boolean_response "Do you want to install telnet?"; then
        brew install telnet
    else
        echo_item "Skipping telnet install" red
    fi
fi

echo ""



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

# -- ssh --------------------------------------------------------------------
if test -f ~/.ssh/id_rsa; then
    if get_boolean_response "Seems there is an existing id_rsa key, do you want to import it ?"; then
        eval "$(ssh-agent -s)"
        ssh-add -K ~/.ssh/id_rsa
    else
        echo_item "Skipping ssh keys import" red
    fi
fi

if get_boolean_response "Do you want to install itermocil?"; then
    brew install TomAnthony/brews/itermocil
    ln -s $DOTFILES/itermocil ~/.itermocil
else
    echo_item "Skipping itermocil install" red
fi
