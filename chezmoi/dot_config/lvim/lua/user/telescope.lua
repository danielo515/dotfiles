local telescope = require("telescope.builtin")

local M = {}

M.dotfiles = function()
	telescope.find_files({ cwd = "~/.dotfiles/" })
end

M.find_siblings = function()
	telescope.find_files({ cwd = vim.fn.expandcmd("%:h") })
end
M.find_on_parent = function()
	telescope.find_files({ cwd = vim.fn.expandcmd("%:h:h") })
end
-- Change Telescope navigation
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-k>"] = actions.move_selection_previous,
		["<C-j>"] = actions.move_selection_next,
		["<C-n>"] = actions.cycle_history_next,
		["<C-r>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["j"] = actions.move_selection_next,
		["k"] = actions.move_selection_previous,
		["<C-r>"] = actions.cycle_history_prev,
	},
}

return M
