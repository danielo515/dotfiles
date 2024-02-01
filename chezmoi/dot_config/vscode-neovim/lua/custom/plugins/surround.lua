return {
	"wellle/targets.vim", -- Adds more targets to vim's built-in text object motions
	{
		"kylechui/nvim-surround", -- The best surround I tried so far
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
}
