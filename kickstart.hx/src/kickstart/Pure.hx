package kickstart;

import vim.plugin.types.VimPlugin;
import plugins.WhichKey;
import lua.Table.create as t;
import packer.Packer;
import vim.Vim;
import vim.VimTypes;

function main() {
  final plugins:Array< Plugin > = [
    {name: "wbthomason/packer.nvim"},
    {name: "kylechui/nvim-surround"},
    {name: "folke/which-key.nvim"},
    { // LSP Configuration & Plugins
      name: "neovim/nvim-lspconfig",
      requires: t([
        // Automatically install LSPs to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        // Useful status updates for LSP
        "j-hui/fidget.nvim",

        // Additional lua configuration, makes nvim stuff amazing
        "folke/neodev.nvim",
      ]),
    },
    { // Autocompletion
      name: "hrsh7th/nvim-cmp",
      requires: t(["hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"]),
    },
    { // Highlight, edit, and navigate code
      name: "nvim-treesitter/nvim-treesitter",
      run: 'pcall(require("nvim-treesitter.install").update({ with_sync = true }))'
    },

    {name: "b0o/schemastore.nvim"},
    // Git related plugins
    {name: "tpope/vim-fugitive"},
    {name: "tpope/vim-rhubarb"},
    {name: "lewis6991/gitsigns.nvim"},

    {name: "navarasu/onedark.nvim"}, // Theme inspired by Atom
    {name: "nvim-lualine/lualine.nvim"}, // Fancier statusline
    {name: "lukas-reineke/indent-blankline.nvim"}, // Add indentation guides even on blank lines
    {name: "numToStr/Comment.nvim"}, // "gc" to comment visual regions/lines
    {name: "tpope/vim-sleuth"}, // Detect tabstop and shiftwidth automatically
  ];
  final is_bootstrap = Packer.init(plugins);
  if (is_bootstrap) {
    vim.Vim.print("==================================");
    vim.Vim.print("    Plugins are being installed");
    vim.Vim.print("    Wait until Packer completes,");
    vim.Vim.print("       then restart nvim");
    vim.Vim.print("==================================");
    return;
  }

  // vim.Filetype.add({
  //   extension = {
  //     hx = "haxe"
  //   }
  // })
  keymaps();
  setupPlugins();
  vimOptions();
}

inline function vimOptions() {
  Vim.cmd("colorscheme onedark");
  // -- Vim options
  Vim.o.hlsearch = false;
  Vim.o.mouse = 'a';
  Vim.o.breakindent = true;
  Vim.o.undofile = true;
  Vim.wo.Number = true;
  // show the effects of a search / replace in a live preview window
  Vim.o.inccommand = "split";
}

function setupPlugins() {
  final lualine = plugins.Lualine.require();
  if (lualine != null) {
    lualine.setup({
      options: {
        icons_enabled: true,
        theme: 'onedark',
        component_separators: '|',
        section_separators: '',
      },
    });
  }
  final wk:VimPlugin< WhichKey > = "which-key";
  wk.call(wk -> {
    Vim.o.timeout = true;
    Vim.o.timeoutlen = 300;
    wk.setup({
      plugins: {
        marks: true,
        registers: true,
        spelling: {
          enabled: true,
          suggestions: 20,
        },
        presets: {
          operators: true,
          motions: true,
          text_objects: true,
          windows: true,
          nav: true,
          z: true,
          g: true,
        },
      },
    });
  });
}

function keymaps() {
  Vim.g.mapleader = " ";
  Vim.g.maplocalleader = ",";
  Keymap.set(
    t([Normal]),
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    {desc: 'up when word-wrap', silent: true, expr: true}
  );
  Keymap.set(
    t([Normal]),
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    {desc: 'down when word-wrap', silent: true, expr: true}
  );
  Keymap.set(
    t([Normal]),
    '<leader>w',
    "<Cmd>wa<CR>",
    {desc: 'Write all files', silent: true}
  );
}
