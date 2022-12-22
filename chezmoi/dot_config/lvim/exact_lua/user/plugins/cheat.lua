return {
  "RishabhRD/nvim-cheat.sh",
  requires = "RishabhRD/popfix",
  config = function()
    vim.g.cheat_default_window_layout = "float"
  end,
  -- cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
  -- keys = "<leader>?",
}
