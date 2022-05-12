local components = require("lvim.core.lualine.components")
local gps_ok, gps = pcall(require, "nvim-gps")

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local nvim_gps = function()
	if not gps_ok then
		return "no gps"
	end
	local gps_location = gps.get_location()
	if gps_location == "error" then
		return "gps error"
	else
		return gps.get_location()
	end
end

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
	{ nvim_gps, cond = hide_in_width },
}
lvim.builtin.lualine.sections.lualine_x = {
	components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = { "location", "tabs", "windows" }
