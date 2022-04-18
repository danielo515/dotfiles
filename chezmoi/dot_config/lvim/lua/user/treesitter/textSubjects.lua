local M = {}

M.config = {
	textsubjects = {
		enable = true,
		prev_selection = ",", -- (Optional) keymap to select the previous selection
		keymaps = {
			["."] = "textsubjects-smart",
			[";"] = "textsubjects-container-outer",
			["i;"] = "textsubjects-container-inner",
		},
	},
}

M.plugin = {
	"RRethy/nvim-treesitter-textsubjects",
}
return M
