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
  -- Update more often, :h events for more info.
  history = true,
  updateevents = "TextChanged,TextChangedI",
  -- Snippets aren't automatically removed if their text is deleted.
  -- `delete_check_events` determines on which events (:h events) a check for
  -- deleted snippets is performed.
  -- This can be especially useful when `history` is enabled.
  delete_check_events = "InsertLeave", -- or maybe "InsertLeave"
  -- When to check if the snippet should be finished because out of its region.
  -- Disabled by default, so I set it up
  region_check_events = "CursorMoved",
  enable_autosnippets = true,
  -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
  -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
  store_selection_keys = "<Tab>",
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
