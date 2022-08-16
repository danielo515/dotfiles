return {
  "ethanholz/nvim-lastplace",
  event = "BufRead",
  commit = "ecced89",
  config = function()
    require("nvim-lastplace").setup {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = true,
    }
  end,
}
