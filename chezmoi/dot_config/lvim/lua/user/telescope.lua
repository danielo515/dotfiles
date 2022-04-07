local builtin = require("telescope.builtin")
local _, themes = pcall(require, "telescope.themes")

local M = {}
M.dotfiles = function()
	builtin.find_files({ cwd = "~/.dotfiles/" })
end

M.find_siblings = function()
	local opts = themes.get_dropdown({ cwd = vim.fn.expandcmd("%:h") })
	builtin.find_files(opts)
end
M.find_on_parent = function()
	builtin.find_files(themes.vscode({ cwd = vim.fn.expandcmd("%:h:h") }))
end

-- utility function for the <C-f> find key
function M.grep_files(opts)
	opts = opts or {}
	local cwd = vim.fn.getcwd()
	local theme_opts = themes.get_ivy({
		sorting_strategy = "ascending",
		layout_strategy = "bottom_pane",
		prompt_prefix = ">> ",
		prompt_title = "~ Grep " .. cwd .. " ~",
		search_dirs = { vim.fn.getcwd(0) },
	})
	opts = vim.tbl_deep_extend("force", theme_opts, opts)
	builtin.live_grep(opts)
end
-- show code actions in a fancy floating window
function M.code_actions()
	local opts = {
		layout_config = {
			prompt_position = "top",
			width = 80,
			height = 12,
		},
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		previewer = false,
		shorten_path = false,
	}
	builtin.lsp_code_actions(themes.get_dropdown(opts))
end

function M.buffers()
	require("telescope.builtin").buffers(require("telescope.themes").vscode())
end

M.plugins = {
	{
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua" },
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
	},
}

lvim.builtin.telescope.path_display = "truncate"

lvim.builtin.telescope.on_config_done = function(tele)
	tele.load_extension("frecency")
	tele.load_extension("command_palette")
	tele.load_extension("notify")
	tele.load_extension("file_browser")
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
