local M = {}

-- Allows you to do smart selection based on the code
-- for example v then . will expand the selection, you can extend by tapping dot more times
-- You can also go back by tapping `,` and you will go to previous selection
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
