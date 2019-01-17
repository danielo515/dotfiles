#!/bin/bash
# Install .dotfiles

# -- Import from other scripts -------------------------------------------------

source 'scripts/helpers/colors.sh'
source 'scripts/helpers/functions.sh'

# -- OSX- or Linux-Specific Setup ----------------------------------------------

if system_is_OSX; then
    
    source 'scripts/osx.sh'
    
    elif system_is_linux; then
    
    source 'scripts/ubuntu.sh'
    
fi

# -- GIT -----------------------------------------------------------------------

if get_boolean_response "Do you want to install the Git configuration files?"
then
    ln -sf $HOME/.dotfiles/git/gitignore_global $HOME/.gitignore_global
    echo_item "Linked global .gitignore" "green"
    
    ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
    echo_item "Linked gitconfig" "green"
else
    echo_item "Ignoring Git configuration" red
fi

echo ""
# -- Python -----------------------------------------------------------------------
if exists "python"; then
    if get_boolean_response "Do you want to install python package manager pip ?"; then
        curl https://bootstrap.pypa.io/get-pip.py -o ~/get-pip.py
        python ~/get-pip.py --user
        rm ~/get-pip.py
    else
        echo_item "Skip pip install" red
    fi
else
    echo_item "Python is not installed, skip related stuff" red
fi

# -- ZSH Setup -----------------------------------------------------------------

if exists "zsh"; then
    if get_boolean_response "Do you want to install ZSH configuration files?"; then
        
        # -- ZSHRC
        ln -sf $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
        echo_item "Linked zshrc" "green"
        
        # -- OH MY ZSH
        if [ -d $HOME/.oh-my-zsh/ ]; then
            echo_item "Oh my ZSH is already installed" "green"
        else
            if exists "curl"; then
                curl -L http://install.ohmyz.sh | sh
                elif exists "wget"; then
                wget --no-check-certificate http://install.ohmyz.sh -O - | sh
            else
                echo_item "You need either curl or wget installed to download Oh My ZSH"
            fi
        fi
        
    else
        echo_item "Ignoring ZSH configuration" "red"
    fi
else
    echo_item "ZSH is not installed"
fi

echo ""

# -- BASH Setup ----------------------------------------------------------------

if get_boolean_response "Do you want to install Bash configuration files?"; then
    # -- BASH PROFILE
    ln -sf $HOME/.dotfiles/bash/bash_profile $HOME/.bash_profile
    echo_item "Linked bash_profile" "green"
else
    echo_item "Ignoring Bash configuration" "red"
fi

echo ""

# -- TMUX ----------------------------------------------------------------------
if get_boolean_response "Do you want to install the Tmux configuration file?"
then
    ln -sf $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf
    echo_item "Linked tmux configutation" "green"
else
    echo_item "Ignoring Tmux configuration" "red"
fi

echo ""

# -- Node ----------------------------------------------------------------------

if exists "nvm"; then
    echo_item "Node tools are already installed" green
else
    if get_boolean_response "Do you want to install Node.js tools (nvm) ?"; then
        git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
        . $HOME/.nvm/nvm.sh
        nvm alias default system
    else
        echo_item "Skipping Node.js tools install" red
    fi
fi

echo ""

# -- VSCode ----------------------------------------------------------------------
if exists "code"; then
    if get_boolean_response "You have VSCode installed, want to add some recommended extension ?"; then
        code --install-extension editorconfig.editorconfig
        code --install-extension dbaeumer.vscode-eslint
        code --install-extension danielo515.danielo-node-snippets
        code --install-extension robertohuertasm.vscode-icons
    else
        echo_item "Skip VSCode extensions installation" red
    fi
else
    echo_item "VSCode not installed, skipping extensions installation" red
fi



# -- NEOVIM --------------------------------------------------------------------
# Link the dotfiles

# TODO: Ask if the user wants to copy the current configuration to a .local file
if get_boolean_response "Do you want to install the NeoVim configuration file?"
then
    ln -sf $HOME/.dotfiles/nvim/init.vim $HOME/.config/nvim/init.vim
    echo_item "Linked Neovim configuration" "green"
    ln -sf $HOME/.dotfiles/nvim/colors $HOME/.config/colors/nvim/colors
    echo_item "Linked Neovim colors" "green"
else
    echo_item "Ignoring Neovim configuration" red
fi

echo ""
