local plugins = {
  -- themes
  "folke/tokyonight.nvim",
  { "Mofiqul/dracula.nvim" },
  { "catppuccin/nvim", as = "catppuccin" },
  "marko-cerovac/material.nvim",
  require "user.plugins.filetype-config", -- faster and lua way of setting custom filetypes
  -- sessions management
  require("user.persistence").plugin,
  require("user.harpoon").plugin,
  -- highlight nicely the search results
  require("user.hlslens").plugin,
  require("user.neo_tree").plugin, -- Is good not only for files, but also git
  require "user.goto_preview",
  -- require "user.tabout",
  require "user.plugins.twilight-config",
  require "user.plugins.zen_mode",
  require "user.plugins.cmp-config",
  require "user.plugins.focus",
  require "user.plugins.neogen-config",
  require "user.plugins.biscuits",
  -- require "user.plugins.lsp-lines",
  -- require "user.bookmarks",
  -- require "user.neozoom",
  require "user.plugins.incline",
  -- require "user.plugins.vgit",
  require "user.colorbuddy",
  require "user.plugins.primeagen-refactoring",
  require "user.plugins.vim-firestore",
  require "user.plugins.dial-config",
  -- require "user.treesitter-statusline",
  require "user.plugins.pomodoro-config",
  require "user.plugins.neogit-config",
  require "user.plugins.git-conflict-config",
  -- Awesome diff view
  require "user.diffview",
  require "user.plugins.cheat",
  require "user.plugins.fidget-config",
  { "mtdl9/vim-log-highlighting", ft = { "text", "log" } },
  { -- Navigation by jumping to LSP objects like hop.nvim
    "ziontee113/syntax-tree-surfer",
    config = function()
      require "user.syntax_tree_surfer"
    end,
  },
  require "user.plugins.trouble", -- some lsp diagnosis

  -- better surround options
  { "tpope/vim-surround" },
  "wellle/targets.vim",
  { "tpope/vim-repeat" },
  -- fuzzy jummp on the file
  { "rlane/pounce.nvim" },
  --#region better % navigation
  require "user.plugins.vim-matchup",
  -- explore LSP symbols
  require "user.plugins.symbols-outline",
  -- colors
  { "folke/lsp-colors.nvim", event = "BufRead" },
  { "ckipp01/stylua-nvim" },
  { "rafcamlet/nvim-luapad" },
  -- {
  --   "pwntester/octo.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("user.octo").setup()
  --   end,
  -- },
  -- Improve nvim interface for inputs and that stuff
  { "stevearc/dressing.nvim" },

  -- shows the function signatures when you are inside the parameter
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup {
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
          border = "rounded",
        },
      }
    end,
  },
  { "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" }, -- shows your position using treesitter
  -- Indent guides on every line
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    commit = "c15bbe9",
    config = require("user.indent-blankline").config,
  },
  -- Smooth scrolling
  { "psliwka/vim-smoothie" },
  --- Pick the file where you edited last time
  require "user.plugins.nvim-lastplace-config",
  -- better quickfix
  require "user.plugins.bqf",
  -- Clipboard history
  { "tami5/sqlite.lua" },
  {
    "AckslD/nvim-neoclip.lua",
    requires = { "tami5/sqlite.lua" },
    after = "which-key.nvim",
    config = function()
      require("user.neoclip").config()
    end,
  },
  -- powerful search and replace
  {
    "windwp/nvim-spectre",
    config = function()
      require("spectre").setup()
    end,
  },
  { "kosayoda/nvim-lightbulb" },

  -- auto close and rename markup tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- show colors inline
  require "user.plugins.colorizer-config",
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  },
  -- VSCode like omni bar
  require "user.plugins.legendary-config",
  {
    "gfeiyou/command-center.nvim",
    config = function()
      require("user.command-center").config()
      require("telescope").load_extension "command_center"
    end,
    after = "telescope.nvim",
    requires = "nvim-telescope/telescope.nvim",
  },
  -- tmux integration
  require "user.plugins.tmux-navigation",
  -- call any "make" program and populate location list with it
  {
    "neomake/neomake",
    setup = function()
      vim.g.neomake_open_list = 2 -- open the list automatically:
    end,
  },
  -- Extends the typescript LSP capabilities with things like file rename
  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("typescript").setup {
        disable_formatting = true, -- disable tsserver's formatting capabilities
      }
    end,
  },
  -- registers UI
  { "tversteeg/registers.nvim", commit = "949213e" },
  -- Adds hop-like visual hints for selecting using treesitter
  "mfussenegger/nvim-ts-hint-textobject",
  { "felipec/vim-sanegx" },
  --#region rescript
  {
    "reasonml-editor/vim-reason-plus",
    -- Not sure if this will work fine
    config = function()
      vim.g.LanguageClient_serverCommands = {
        reason = { "reason-language-server" },
      }
    end,
  },
  {
    "nkrkv/nvim-treesitter-rescript",
  },
  {
    "~/tella/nvim-treesitter-reason",
  },
  --#endregion Rescrtip
  require "user.plugins.async-tasks",
}
return plugins
