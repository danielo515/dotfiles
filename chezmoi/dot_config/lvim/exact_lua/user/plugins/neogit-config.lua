return {
  "TimUntersberger/neogit",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    local neogit = require "neogit"
    neogit.setup {}
  end,
}
