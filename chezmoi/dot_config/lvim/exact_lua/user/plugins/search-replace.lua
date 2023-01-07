return {
  "roobert/search-replace.nvim",
  commit = "582981f2795fff2a79d3a60844552047a397bffa",
  config = function()
    require("search-replace").setup {
      -- optionally override defaults
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    }
  end,
}
