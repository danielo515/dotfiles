# NeoVim config written in Haxe

This is a NeoVim configuration written almost entirely in [Haxe](https://haxe.org/) using [haxe-nvim](https://github.com/danielo515/haxe-nvim)

## Rationale

Have you ever desired that your favorite most hackable editor (NeoVim, obviously) was also type safe?
You think that Lua is a great improvememnt over VimScript but you keep making stupid mistakes that
a type checker would caught? Then you may be interested in this project.

This project is part of the "ecosystem" of haxe-nvim, which arised from the frustration of constantly
making stupid type mistakes in Lua. 
This repo is an example of a personal configuration written using the haxe-nvim toolchain. 
If you want an example of how to write NeoVim plugins using Haxe, then 
take a look at the [template plugin](https://github.com/danielo515/haxe-nvim-example-plugin)

## How to use

If you just want to use this configuration for your NeoVim 
and are not interested in developing it or anything else, then just clone this repository
and then symlink the `/output` directory to your `~/.config/nvim` folder:

```
git clone git@github.com:danielo515/kickstart.hx.git
ln -s ./kickstart.hx/output/ ~/.config/nvim/
```

If you want to also develop it to use it as base of your personal and type safe NeoVim configuration
, or you want to contribute, then the previous step applies but you will also need to:

1. (optional) fork this repository
1. clone your repository rather than this one
1. install [Haxe](https://haxe.org/) 4.2.5
1. cd into your local folder of your forked repositroy
1. run `haxelib install libs.hxml`
1. open the repository with your favorite editor and start using it


## Inspiration

This started as a port of [kickstart.lua](https://github.com/nvim-lua/kickstart.nvim) to Haxe using [haxe-nvim](https://github.com/danielo515/haxe-nvim)
but it has evolved and will continue evolving independenlty since then.
