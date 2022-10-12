return {
  "beauwilliams/focus.nvim",
  config = function()
    require("focus").setup {
      autoresize = false,
      hybridnumber = true,
      -- Displays a cursorline in the focused window only
      -- Not displayed in unfocussed windows
      -- Default: true
      cursorline = true,
      -- Displays a sign column in the focssed window only
      -- Gets the vim variable setcolumn when focus.setup() is run
      -- See :h signcolumn for more options e.g :set signcolum=yes
      -- Default: true, signcolumn=auto
      signcolumn = true,
      cursorcolumn = true,
      colorcolumn = { enable = true, width = 100 },
      absolutenumber_unfocussed = true,
      winhighlight = false,
    }
    vim.cmd "hi link UnfocusedWindow CursorLineSign"
    vim.cmd "hi link FocusedWindow Normal"
  end,
}
