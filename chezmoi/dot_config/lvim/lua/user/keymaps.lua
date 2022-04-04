local M = {}

local _, builtin = pcall(require, "telescope.builtin")
local _, themes = pcall(require, "telescope.themes")
local lv_which = lvim.builtin.which_key.mappings
local whichConfig = {
	-- search
	s = {
		d = { "<cmd>lua require('user.telescope').dotfiles()<cr>", "Search dotfiles" },
		q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	},
}
lvim.builtin.which_key.mappings = vim.tbl_deep_extend("force", lv_which, whichConfig)

-- lvim.keys.normal_mode["<C-R>"] = "<cmd>LvimReload<cr>"
lvim.keys.normal_mode["<C-f>"] = "<cmd>lua require('user.keymaps').grep_files()<cr>"
lvim.keys.insert_mode["<C-f>"] = lvim.keys.normal_mode["<C-f>"]
lvim.keys.normal_mode["<C-x>"] = "<cmd>BufferKill<cr>"
lvim.keys.normal_mode["kj"] = false
lvim.keys.normal_mode["jk"] = false
lvim.keys.normal_mode["s"] = ":HopChar1<cr>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

function M.grep_files(opts)
	opts = opts or {}
	local theme_opts = themes.get_ivy({
		sorting_strategy = "ascending",
		layout_strategy = "bottom_pane",
		prompt_prefix = ">> ",
		prompt_title = "~ Grep files ~",
		search_dirs = { vim.fn.getcwd(0) },
	})
	opts = vim.tbl_deep_extend("force", theme_opts, opts)
	builtin.live_grep(opts)
end

return M
