return {
    "andymass/vim-matchup",
    event = "CursorMoved",
    after = "nvim-treesitter",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      local treeOk = pcall(function()
        require("nvim-treesitter.configs").setup {
          matchup = {
            enable = true, -- mandatory, false will disable the whole extension
            disable = { "c", "ruby" }, -- optional, list of language that will be disabled
          },
        }
      end)
      if not treeOk then
        vim.notify "Can not attach matchup to treesitter"
      end
    end,
  }
