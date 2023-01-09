return {
  "asiryk/auto-hlsearch.nvim",
  config = function()
    require("auto-hlsearch").setup {
      remap_keys = { "/", "?", "*", "#", "n", "N" },
    }
  end,
}
