return {
  "akinsho/git-conflict.nvim",
  tag = "v1.0.0",
  config = function()
    require("git-conflict").setup {
      default_mappings = true, -- buffer local mapping created by this plugin
      disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffText",
        current = "DiffAdd",
      },
    }
  end,
}
