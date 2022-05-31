return {
  "danymat/neogen",
  config = function()
    require("neogen").setup {
      snippet_engine = "luasnip",
    }
  end,
  requires = "nvim-treesitter/nvim-treesitter",
  tag = "*",
}
