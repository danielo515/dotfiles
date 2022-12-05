# This variables are managed by chezmoi and injected at the top
# export XDG_CONFIG_HOME="$HOME/.config"
# export DOTFILES="$HOME/.dotfiles"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- Do not update oh-my-zsh, chezmoi will take care --
DISABLE_AUTO_UPDATE="true"
# -- Import HELPER scripts -------------------------------------------------
source "$DOTFILES/scripts/helpers/functions.sh"
source "$DOTFILES/scripts/helpers/colors.sh"

# -- Local Configuration (Before Default) --------------------------------------
if [[ -f "$DOTFILES/zsh/zshrc.local.pre" ]]; then
    source $DOTFILES/zsh/zshrc.local.pre
fi

# -- Zsh -----------------------------------------------------------------------
ZSH="$HOME/.oh-my-zsh"
# -- For now, just use the default ones and do not configure it
# ZSH_CUSTOM="$DOTFILES/zsh/custom"
# fpath=("$DOTFILES/zsh/custom" $fpath)

# -- Theme ---------------------------------------------------------------------
export NVIM_TUI_ENABLE_TRUE_COLOR=1
ZSH_THEME="powerlevel10k/powerlevel10k"
# SPACESHIP_PROMPT_ADD_NEWLINE="true"
# SPACESHIP_CHAR_SUFFIX=(" ")
# SPACESHIP_CHAR_COLOR_SUCCESS="yellow"
# SPACESHIP_PROMPT_DEFAULT_PREFIX="$USER"
# SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true"
# SPACESHIP_USER_SHOW="true"

# -- ZSH Plugins ---------------------------------------------------------------
plugins=(
  # zsh-nvm
  git 
  npm 
  bower 
  vi-mode 
  pj 
  zsh-navigation-tools
  zsh-autosuggestions
)
if exists "virtualenvwrapper"; then plugins+=virtualenvwrapper; fi
if exists "autojump"; then plugins+=autojump; fi
plugins+=(
  zsh-syntax-highlighting # needs to be the last plugin
)

fpath=($DOTFILES/zsh/custom/completion $fpath)

# Add Homebrew completions to config if they can be found
local brew_completions="$(brew --prefix)/share/zsh/site-functions"
if [[ -d $brew_completions ]]; then
    fpath=($fpath $brew_completions)
fi

# -- Oh My Zsh -----------------------------------------------------------------
source $ZSH/oh-my-zsh.sh

# -- Named Directories ---------------------------------------------------------
unsetopt auto_name_dirs

# -- Completion Config ---------------------------------------------------------
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.class'

# -- Command History -----------------------------------------------------------
export HISTSIZE=900
export SAVEHIST=900

# -- Options -------------------------------------------------------------------
unsetopt correct_all
unsetopt correct

# -- Variables -----------------------------------------------------------------
export EDITOR="$(brew --prefix)/bin/nvim"
alias vim=nvim
alias vi=nvim

# -- Aliases -------------------------------------------------------------------
if [[ -f "$DOTFILES/aliases" ]]; then
    source $DOTFILES/aliases
fi

if [[ -f "$HOME/.aliases" ]]; then
    source $HOME/.aliases
fi

alias reload='source $DOTFILES/zsh/zshrc'

export PATH="$PATH:/opt/vagrant/bin"

# -- Functions -----------------------------------------------------------------

# Extract archive based on file type
# Taken from http://justinlilly.com/dotfiles/zsh.html
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)        tar xjf $1        ;;
            *.tar.gz)         tar xzf $1        ;;
            *.bz2)            bunzip2 $1        ;;
            *.rar)            unrar x $1        ;;
            *.gz)             gunzip $1         ;;
            *.tar)            tar xf $1         ;;
            *.tbz2)           tar xjf $1        ;;
            *.tgz)            tar xzf $1        ;;
            *.zip)            unzip $1          ;;
            *.Z)              uncompress $1     ;;
            *)                echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -- Git -----------------------------------------------------------------------
zstyle ':completion:*:*:hub:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}
_git-delete-tag() { compadd "$@" $(git tag) }

# -- Tmux ----------------------------------------------------------------------
export DISABLE_AUTO_TITLE="true"
alias tmux="tmux -2"

# -- TheFuck -------------------------------------------------------------------
#    https://github.com/nvbn/thefuck
alias fuck='$(thefuck $(fc -ln -1))'

# -- Add DOTFILES bin to PATH --------------------------------------------------
export PATH="$PATH:$DOTFILES/bin"

# -- Xiki ----------------------------------------------------------------------
if [[ -f "$HOME/.xsh" ]]; then
    source $HOME/.xsh
fi

# -- fzf -----------------------------------------------------------------------
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    export FZF_TMUX=1
    export FZF_DEFAULT_OPTS="--color 16,info:6,hl:13,hl+:13"
    export FZF_DEFAULT_COMMAND="rg --files-with-matches --no-messages -F ''"
    export FZF_CTRL_T_COMMAND="rg --files-with-matches --no-messages --hidden -F '' | grep -v .git/"
fi

# -- asdf ---------------------------------------------------------------------
if [[ -d "$HOME/.asdf" ]]; then
    source $HOME/.asdf/asdf.sh
    source $HOME/.asdf/completions/asdf.bash
fi

# -- Yarn ---------------------------------------------------------------------
# Make the shell aware of global packages installed by Yarn
local yarn_global_modules="$XDG_CONFIG_HOME/yarn/global/node_modules"
if [[ -d "$yarn_global_modules/.bin" ]]; then
    export PATH="$PATH:$yarn_global_modules/.bin"
fi

# -- Go ------------------------------------------------------------------------
# Add $GOTPATH/bin to the $PATH
export GOPATH=$HOME/Code/go
export GOBIN=$GOPATH/bin
export PATH="$PATH:$GOPATH/bin"

# -- Kubectl
if exists "kubectl"; then
    source <(kubectl completion zsh)
fi

# -- Env variables and that stuff ---------------------------------------
if [[ -f "$HOME/.env" ]]; then
    source $HOME/.env
fi
# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1
export TERM=xterm-256color

# -- Autocomplete ../ ---------------------------------------
zstyle ':completion:*' special-dirs true

# -- Local Configuration (After Default) ---------------------------------------
if [[ -f "$DOTFILES/zsh/zshrc.local" ]]; then
    source $DOTFILES/zsh/zshrc.local
fi
unalias grv

# -- Vim keybindings ---
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="/usr/local/opt/ruby/bin:$PATH"

# added by travis gem
[ ! -s /Users/danielo/.travis/travis.sh ] || source /Users/danielo/.travis/travis.sh
export PATH="/usr/local/opt/ruby/bin:$PATH"

# opam configuration
[[ ! -r /Users/danielo/.opam/opam-init/init.zsh ]] || source /Users/danielo/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

function p10k-on-pre-prompt() {
  p10k display '1/right/command_execution_time'=show
}

# - Powerlevel10k load
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
