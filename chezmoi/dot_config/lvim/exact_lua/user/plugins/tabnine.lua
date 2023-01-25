return {
  "codota/tabnine-nvim",
  requires = { "tzachar/cmp-tabnine", run = "./install.sh", requires = "hrsh7th/nvim-cmp" },
  run = "./dl_binaries.sh",
  config = function()
    require("tabnine").setup {
      disable_auto_comment = true,
      accept_keymap = "<S-tab>",
      dismiss_keymap = "<C-e>",
      debounce_ms = 300,
      suggestion_color = { gui = "#bb9af7", cterm = 244 },
      execlude_filetypes = { "TelescopePrompt" },
    }
  end,
}
