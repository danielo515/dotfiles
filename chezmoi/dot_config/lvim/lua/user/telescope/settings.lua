local plugins = {
	{
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "tami5/sqlite.lua" },
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
	},
	{ "kdheepak/lazygit.nvim" },
	{ "nvim-telescope/telescope-packer.nvim" },
}

lvim.builtin.telescope.path_display = "truncate"

lvim.builtin.telescope.on_config_done = function(tele)
	tele.load_extension("frecency")
	tele.load_extension("command_palette")
	tele.load_extension("notify")
	tele.load_extension("file_browser")
	tele.load_extension("lazygit")
	tele.load_extension("packer")
	tele.load_extension("luasnip")
	local opts = {
		pickers = {
			lsp_workspace_symbols = {
				mappings = {
					i = {
						["<cr>"] = function(prompt_bufnr)
							local selection = require("telescope.actions.state").get_selected_entry()
							print(vim.inspect(selection))
						end,
					},
				},
			},
		},
	}

	tele.setup(opts)
end

-- Change Telescope navigation
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
	-- for input mode
	i = {
		["<C-j>"] = actions.move_selection_next,
		["<C-n>"] = actions.cycle_history_next,
		["<C-r>"] = actions.cycle_history_prev,
	},
	-- for normal mode
	n = {
		["j"] = actions.move_selection_next,
		["k"] = actions.move_selection_previous,
		["<C-r>"] = actions.cycle_history_prev,
		["q"] = actions.smart_send_to_qflist + actions.open_qflist,
		["Q"] = actions.smart_add_to_qflist + actions.open_qflist,
		["x"] = actions.delete_buffer,
	},
}
return plugins
