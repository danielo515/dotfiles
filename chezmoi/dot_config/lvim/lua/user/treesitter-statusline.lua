return {
  "alexzanderr/nvim-treesitter-statusline",
  requires = {
    "nvim-treesitter/nvim-treesitter",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("nvim-treesitter-statusline")
  end
}
