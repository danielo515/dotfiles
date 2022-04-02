local whichConfig = {
	s = {
		d = { "<cmd>lua require('user.telescope').dotfiles()<cr>", "Search dotfiles" },
	},
}

vim.tbl_deep_extend("force", lvim.builtin.which_key, whichConfig)
