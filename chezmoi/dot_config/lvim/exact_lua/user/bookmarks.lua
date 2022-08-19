return {
  'crusj/bookmarks.nvim',
  config = function()
    require("bookmarks").setup({
      keymap = {
        toggle = "<leader>m", -- toggle bookmarks
        add = "mz", -- add bookmarks
        jump = "<CR>", -- jump from bookmarks
        delete = "dd", -- delete bookmarks
        order = "<space><space>", -- order bookmarks by frequency or updated_time
      },
      hl_cursorline = "guibg=Gray guifg=White" -- hl bookmarsk window cursorline
    })

  end
}
