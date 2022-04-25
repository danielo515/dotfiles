local components = require("lvim.core.lualine.components")
local ts = require("nvim-treesitter")

lvim.builtin.lualine.sections.lualine_a = {
	{
		"filename",
		file_status = true, -- Displays file status (readonly status, modified status)
		path = 1, -- 0: Just the filename
		-- 1: Relative path
		-- 2: Absolute path

		shorting_target = 40, -- Shortens path to leave 40 spaces in the window
		symbols = {
			modified = "[+]", -- Text to show when the file is modified.
			readonly = "[!]", -- Text to show when the file is non-modifiable or readonly.
			unnamed = "[No Name]", -- Text to show for unnamed buffers.
		},
	},
}
lvim.builtin.lualine.sections.lualine_b = { components.branch }
lvim.builtin.lualine.sections.lualine_c = {
	components.diff,
	components.lsp,
	components.diagnostics,
	components.treesitter,
	ts.statusline,
}
lvim.builtin.lualine.sections.lualine_x = {
	components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = { "location", "tabs", "windows" }
