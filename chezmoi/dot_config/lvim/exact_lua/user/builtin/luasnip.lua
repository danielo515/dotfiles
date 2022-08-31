local luasnip = require "luasnip"
local types = require "luasnip.util.types"

local imap = require("user.util.keymap").imap

imap("<c-w>", function()
  luasnip.change_choice(1)
end, "Jump to next choice in luasnip")

imap("<c-e>", function()
  if luasnip.expand_or_jumpable() then
    return luasnip.expand_or_jump()
  end
end, "Jump to next in luasnip")

luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged", -- or maybe "InsertLeave"
  enable_autosnippets = true,
  --  region_check_events = "CursorMoved", -- or maybe "InsertEnter"
  ext_opts = {
    [types.insertNode] = {
      active = {
        virt_text = { { "<-- snip", "BufferInactiveIndex" } },
      },
    },
    [types.choiceNode] = {
      active = {
        virt_text = { { "<-- choice", "BufferInactiveIndex" } },
      },
    },
  },
}
