# This gets executed every time a new prompt is issued in the shell
# So it makes sourcing aliases and functions a lot easier
preexec(){
    source $DOTFILES/aliases
}
