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
    }
  ];
  Packer.init(plugins);
}
