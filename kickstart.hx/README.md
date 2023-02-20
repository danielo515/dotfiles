# Kickstart neovim in Haxe

This is a NeoVim configuration written almost entirely in [Haxe](haxe.org) using [haxe-nvim](https://github.com/danielo515/haxe-nvim)

## How to use

If you just want to use it without compiling or anything else, just clone this repository
and then symlink the `/output` directory to your `~/.config/nvim` folder:

```
git clone git@github.com:danielo515/kickstart.hx.git
ln -s ./kickstart.hx/output/ ~/.config/nvim/
```

If you want to also develop on it, then the previous step applies but you will also need to:
1. install [Haxe](haxe.org) 4.2.5
1. run `haxelib install libs.hxml`
1. open the repository with your favorite editor and start using it
