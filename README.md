# danielo .dotfiles

My dotfile configuration. Covers Neovim, TMUX, Git, ZSH and some other things, too.

## Installing the doftiles

1. Pull the project into your home directory

```bash
git clone https://github.com/danielo515/dotfiles.git ~/.dotfiles
git submodule update --init --recursive
```

2. Run the installation script

```bash
cd ~/.dotfiles && ./install.sh
```

3. Unless you're me, change the Git configuration to your own name and email address

## Make `CAPSLOCK` Useful

I hate `CAPSLOCK` and don't find it useful at all. However, is _does_ occupy a really useful place on the keyboard. I've found the best use for it to be mapping it such that tapping it sends `ESC` and holding it works as `CONTROL`. This way, you can hold it down using your pinky finger as a modifier, or give it a quick tap to pop out of `insert` mode in Vim.

## Chezmoi

Files in this repository are managed using chezmoi.
Here are the particular specific things about my chezmoi configuration

- I use a subfolder called chezmoi for the chezmoi files
- I have some scripts that run once to setup some environment things

## How chezmoi builds my zshrc

Every file in the zsh that ends up in `.zsh` is concatenated in the file name order to the zshrc everytime chezmoi apply is executed

## Aliases

There are some ways of defining aliases. The old/legacy one is just add them to the file named `aliases` somewhere in this repo.
However, over time this has demonstrated to become cumbersome, hard to maintain and read.
Now I have a folder under `chezmoi/dot_config/aliases`. All the files there are supposed to be named after a domain (for example, `node_aliases`, `git_aliases` etc)
and are sourced to create the global aliases.

### Local aliases

if a file named `.aliases` is found in the home folder, it is also sourced by ZSH and BASH. If you want to have some machine specific aliases, just put them there.
