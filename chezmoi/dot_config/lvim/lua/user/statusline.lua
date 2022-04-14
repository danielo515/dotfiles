local components = require("lvim.core.lualine.components")
local ts = require("nvim-treesitter")

lvim.builtin.lualine.sections.lualine_a = {
	function()
		return vim.fn.expandcmd("%")
	end,
}
lvim.builtin.lualine.sections.lualine_b = { components.branch }
lvim.builtin.lualine.sections.lualine_c = {
	components.diff,
	components.lsp,
	components.diagnostics,
	components.treesitter,
}
lvim.builtin.lualine.sections.lualine_x = {
	components.filetype,
	ts.statusline,
}
lvim.builtin.lualine.sections.lualine_y = { "location", "tabs", "windows" }
