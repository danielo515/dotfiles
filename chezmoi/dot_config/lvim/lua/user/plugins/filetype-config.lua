return {
  "nathom/filetype.nvim",
  config = function()
    require("filetype").setup {
      overrides = {
        extensions = {
          zsh = "bash", -- used for zsh configuration files
        },
      },
    }
  end,
}
