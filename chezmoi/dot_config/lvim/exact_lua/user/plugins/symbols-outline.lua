return {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = function()
      vim.g.symbols_outline = {}
      lvim.autocommands.custom_groups:append {
        { "BufWinEnter", "*.ts,*.lua", "SymbolsOutline" },
      }
    end,
  }
