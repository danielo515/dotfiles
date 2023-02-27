package kickstart;

import lua.Table.create as t;
import packer.Packer;

function main() {
  final plugins:Array< Plugin > = [
    {name: "wbthomason/packer.nvim"},
    {name: "kylechui/nvim-surround"},
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
}
