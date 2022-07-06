local plugins = {
  -- themes
  "folke/tokyonight.nvim",
  { "Mofiqul/dracula.nvim" },
  { "catppuccin/nvim", as = "catppuccin" },
  "marko-cerovac/material.nvim",
  -- sessions management
  require("user.persistence").plugin,
  require("user.harpoon").plugin,
  -- highlight nicely the search results
  require("user.hlslens").plugin,
  require("user.neo_tree").plugin,
  require "user.goto_preview",
  require "user.tabout",
  require "user.cmp",
  require "user.plugins.neogen-config",
  require "user.plugins.biscuits",
  -- require "user.bookmarks",
  require "user.neozoom",
  require "user.incline",
  require "user.vgit",
  require "user.colorbuddy",
  require "user.plugins.vim-firestore",
  -- require "user.treesitter-statusline",
  require("user.plugins.pomodoro"),
  -- Awesome diff view
  require "user.diffview",
  { -- Navigation by jumping to LSP objects like hop.nvim
    "ziontee113/syntax-tree-surfer",
    config = function()
      require "user.syntax_tree_surfer"
    end,
  },
  -- require("user.lspsaga").plugin,
  -- some lsp diagnosis
  { "folke/trouble.nvim", cmd = "TroubleToggle" },
  -- better surround options
  { "tpope/vim-surround", keys = { "c", "d", "y" } },
  "wellle/targets.vim",
  { "tpope/vim-repeat" },
  -- fuzzy jummp on the file
  { "rlane/pounce.nvim" },
  --#region better % navigation
  require"user.plugins.vim-matchup",
  -- explore LSP symbols
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = function()
      vim.g.symbols_outline = {}
      lvim.autocommands.custom_groups:append {
        { "BufWinEnter", "*.ts,*.lua", "SymbolsOutline" },
      }
    end,
  },
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
  -- shows where you are using tree-siter
  -- Lua
  { "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" },
  -- Indent guides on every line
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = require("user.indent-blankline").config,
  },
  -- Smooth scrolling
  { "psliwka/vim-smoothie" },
  --- Pick the file where you edited last time
  require"user.plugins.nvim-lastplace-config",
  -- better quickfix
  require"user.plugins.bqf",
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
  require"user.plugins.colorizer-config" ,
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  },
  -- VSCode like omni bar
  {
    "mrjones2014/legendary.nvim",
    after = "which-key.nvim",
    config = function()
      require("legendary").setup {
        which_key = {
          mappings = lvim.builtin.which_key.mappings,
          opts = lvim.builtin.which_key.opts,
          -- false if which-key.nvim handles binding them,
          -- set to true if you want legendary.nvim to handle binding
          -- the mappings; if not passed, true by default
          do_binding = false,
        },
      }
    end,
  },
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
  require"user.plugins.tmux-navigation",
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
  "tversteeg/registers.nvim",
  -- Adds hop-like visual hints for selecting using treesitter
  "mfussenegger/nvim-ts-hint-textobject",
  { "felipec/vim-sanegx", event = "BufRead" },
}
return plugins
