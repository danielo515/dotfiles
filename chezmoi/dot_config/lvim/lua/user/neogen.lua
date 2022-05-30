return {
  "danymat/neogen",
  config = function()
    require("neogen").setup {}
  end,
  requires = "nvim-treesitter/nvim-treesitter",
  tag = "*",
}
