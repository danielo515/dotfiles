local components = require("lvim.core.lualine.components")

lvim.builtin.lualine.sections.lualine_a = { "filename" }
lvim.builtin.lualine.sections.lualine_b = { components.branch }
lvim.builtin.lualine.sections.lualine_c = {
	components.diff,
	{
		"lsp_progress",
		colors = { use = true },
	},
	components.diagnostics,
}
lvim.builtin.lualine.sections.lualine_x = { require("auto-session-library").current_session_name }
lvim.builtin.lualine.sections.lualine_y = { "location" }
