-- Nvimtree
-- =========================================
lvim.builtin.nvimtree.setup.open_on_setup = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer = {
  indent_markers = {
    enable = true,
    icons = {
      corner = "└ ",
      edge = "│ ",
      none = "  ",
    },
  },
}
local function telescope_find_files(_)
  require("lvim.core.nvimtree").start_telescope "find_files"
end

local function telescope_live_grep(_)
  require("lvim.core.nvimtree").start_telescope "live_grep"
end

-- local function handle_single_click(node)
--   local open = require("nvim-tree.actions.open-file").fn
--   vim.cmd [[
--   execute "normal! \<LeftMouse>"
--   ]]
-- end

lvim.builtin.nvimtree.setup.view.mappings.list = {
  { key = { "l", "<CR>" }, action = "edit", mode = "n" },
  { key = "h", action = "close_node" },
  { key = "v", action = "vsplit" },
  { key = "s", action = "split" },
  { key = "C", action = "cd" },
  { key = "i", action = "toggle_git_ignored" },
  { key = "o", action = "edit_no_picker" },
  { key = "<C-F>", action = "live_filter" },
  { key = "f", action = "telescope_find_files", action_cb = telescope_find_files },
  { key = "gr", action = "telescope_live_grep", action_cb = telescope_live_grep },
  -- { key = "<2-LeftMouse>", action = "" },
  -- { key = "<LeftMouse>", action = "open node", action_cb = handle_single_click },
}

lvim.builtin.nvimtree.setup.view.width = 40
lvim.builtin.nvimtree.setup.diagnostics.show_on_dirs = true
lvim.builtin.nvimtree.setup.filters.custom = { "\\.cache" }
-- Nvimtree end
-- =========================================
