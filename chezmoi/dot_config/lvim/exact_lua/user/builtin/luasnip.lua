local luasnip = require "luasnip"
local types = require "luasnip.util.types"

luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged", -- or maybe "InsertLeave"
  --  region_check_events = "CursorMoved", -- or maybe "InsertEnter"
  ext_opts = {
    [types.insertNode] = {
      active = {
        virt_text = { { "<-- snip", "BufferInactiveIndex" } },
      },
    },
  },
}
