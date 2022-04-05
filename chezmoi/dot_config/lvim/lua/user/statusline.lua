local components = require("lvim.core.lualine.components")

lvim.builtin.lualine.sections.lualine_a = { components.filename }
lvim.builtin.lualine.sections.lualine_b = { components.branch }
lvim.builtin.lualine.sections.lualine_c = {
	components.diff,
	components.lsp,
	components.diagnostics,
	components.treesitter,
}
lvim.builtin.lualine.sections.lualine_x = {
	components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = { "location", "tabs", "windows" }
