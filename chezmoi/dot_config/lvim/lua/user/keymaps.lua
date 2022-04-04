
local M = {}

local _, builtin = pcall(require, "telescope.builtin")
local _, themes = pcall(require, "telescope.themes")
local lv_which = lvim.builtin.which_key.mappings
local whichConfig = {
  -- search
	s = {
		d = { "<cmd>lua require('user.telescope').dotfiles()<cr>", "Search dotfiles" },
	},
}
lvim.builtin.which_key.mappings = vim.tbl_deep_extend("force", lv_which, whichConfig)


lvim.keys.normal_mode["<C-R>"] = "<cmd>LvimReload<cr>"
lvim.keys.normal_mode["<C-f>"] = "<cmd>lua require('user.keymaps').grep_files()<cr>"

 function  M.grep_files(opts)
  opts = opts or {}
  local theme_opts = themes.get_ivy {
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ Grep files ~",
    search_dirs = { vim.fn.getcwd(0) },
  }
  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  builtin.live_grep(opts)
end


return M
