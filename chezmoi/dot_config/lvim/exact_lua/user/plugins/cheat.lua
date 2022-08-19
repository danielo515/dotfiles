return {
	"RishabhRD/nvim-cheat.sh",
	requires = "RishabhRD/popfix",
	config = function()
		vim.g.cheat_default_window_layout = "vertical_split"
	end,
	-- cmd = { "Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments" },
	-- keys = "<leader>?",
}
