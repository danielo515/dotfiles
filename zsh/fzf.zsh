if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    export FZF_TMUX=1
    export FZF_DEFAULT_OPTS="--color 16,info:6,hl:13,hl+:13"
    export FZF_DEFAULT_COMMAND="rg --files-with-matches --no-messages -F ''"
    export FZF_CTRL_T_COMMAND="rg --files-with-matches --no-messages --hidden -F '' | grep -v .git/"
    # fzf-tab opens in a nice popup
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi
