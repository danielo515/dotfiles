### Introduction

This is my neovim config specific to be used inside vscode through the [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) extension.
For that reason it is very minimal and only contains the bare minimum to get a working neovim instance inside vscode.

### How to use

Configure the extension to use this config by adding the following to your vscode settings.json:

```json
"vscode-neovim.NVIM_APPNAME": "vscode-neovim"
```

The `Lazy` plugin manager will start automatically on the first run and install the configured plugins - as can be seen in the introduction video. After the installation is complete you can press `q` to close the `Lazy` UI and **you are ready to go**! Next time you run nvim `Lazy` will no longer show up.

If you would prefer to hide this step and run the plugin sync from the command line, you can use:

```sh
nvim --headless "+Lazy! sync" +qa
```

### Configuration And Extension

- For adding plugins, there are 3 primary options:
  - Add new configuration in `lua/custom/plugins/*` files, which will be auto sourced using `lazy.nvim` (uncomment the line importing the `custom/plugins` directory in the `init.lua` file to enable this)
  - Modify `init.lua` with additional plugins.
  - Include the `lua/kickstart/plugins/*` files in your configuration.

You can also merge updates/changes from the repo back into your fork, to keep up-to-date with any changes for the default configuration.

#### Example: Adding an autopairs plugin

In the file: `lua/custom/plugins/autopairs.lua`, add:

```lua
-- File: lua/custom/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require("nvim-autopairs").setup {}
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
```

This will automatically install [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) and enable it on startup. For more information, see documentation for [lazy.nvim](https://github.com/folke/lazy.nvim).

#### Example: Adding a file tree plugin

In the file: `lua/custom/plugins/filetree.lua`, add:

```lua
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require('neo-tree').setup {}
  end,
}
```

This will install the tree plugin and add the command `:Neotree` for you. You can explore the documentation at [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) for more information.

### FAQ

- Can I keep my existing configuration in parallel to kickstart?
  - Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME` to maintain multiple configurations. For example you can install the kickstart configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias vscode-neovim='NVIM_APPNAME="vscode-neovim" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative config directory and the matching local directory `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim distribution that you would like to try out.
- What if I want to "uninstall" this configuration:
  - See [lazy.nvim uninstall](https://github.com/folke/lazy.nvim#-uninstalling) information
- Are there any cool videos about this plugin?
  - Current iteration of kickstart (coming soon)
  - Here is one about the previous iteration of kickstart: [video introduction to Kickstart.nvim](https://youtu.be/stqUbv-5u2s). Note the install via init.lua no longer works as specified. Please follow the install instructions in this file instead as they're up to date.
- Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  - The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the exact
    same functionality is available here:
    - [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  - Discussions on this topic can be found here:
    - [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    - [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Windows Installation

Installation may require installing build tools, and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake, and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
