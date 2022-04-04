lvim.plugins = {
	--treesiter
	require("user.textObjects").plugin,
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	-- better surround options
	{ "tpope/vim-surround", keys = { "c", "d", "y" } },
	-- jump faster
	{
		"phaazon/hop.nvim",
		branch = "v1", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},

	--#region better % navigation
	{
		"andymass/vim-matchup",
		event = "CursorMoved",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	-- explore LSP symbols
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		config = function()
			vim.g.symbols_outline = {}
			lvim.autocommands.custom_groups:append({
				{ "BufWinEnter", "*.ts", "SymbolsOutline" },
			})
		end,
	},
	-- colors
	{ "folke/lsp-colors.nvim", event = "BufRead" },
	{ "ckipp01/stylua-nvim" },
	-- sessions
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				auto_session_enable_last_session = true,
			})
		end,
	},
	-- lua tools
	{ "rafcamlet/nvim-luapad" },
	{
		"pwntester/octo.nvim",
		event = "BufRead",
	},
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ exe = "stylua", filetypes = { "lua" } },
})
