local builtin_ok, builtin = pcall(require, "telescope.builtin")
local themes_ok, themes = pcall(require, "telescope.themes")
local log = require("lvim.core.log")
local notify = require("notify")

if not themes_ok then
	log:warn("Could not load telescope themes")
end

if not builtin_ok then
	log:warn("Could not load telescope builtin")
end

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
		search_dirs = { cwd },
	})
	opts = vim.tbl_deep_extend("force", theme_opts, opts)
	vim.ui.input({}, function(text)
		builtin.grep_string(vim.tbl_extend("force", opts, { search = text }))
	end)
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
	require("telescope.builtin").buffers(require("telescope.themes").vscode({
		layout_config = {
			height = 50,
		},
	}))
end

return M
