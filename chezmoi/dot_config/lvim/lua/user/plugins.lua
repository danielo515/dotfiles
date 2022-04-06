local persistence = require("user.persistence")

lvim.plugins = {
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
				{ "BufWinEnter", "*.ts,*.lua", "SymbolsOutline" },
			})
		end,
	},
	-- colors
	{ "folke/lsp-colors.nvim", event = "BufRead" },
	{ "ckipp01/stylua-nvim" },
	-- lua tools
	{ "rafcamlet/nvim-luapad" },
	{
		"pwntester/octo.nvim",
		event = "BufRead",
		config = function()
			require("user.octo").setup()
		end,
	},
	-- Improve nvim interface for inputs and that stuff
	{ "stevearc/dressing.nvim" },
	-- Highlight parens and that stuff using treesitter
	{
		"p00f/nvim-ts-rainbow",
		config = function()
			require("nvim-treesitter.configs").setup({
				rainbow = {
					enable = true,
					extended_mode = false,
					max_file_lines = nil,
					colors = {
						"#ff0000",
						"#ffa500",
						"#ffff00",
						"#008000",
						"#0000ff",
						"#4b0082",
						"#ee82ee",
					},
				},
			})
		end,
	},
	-- Show current function at the top of the screen when function does not fit in screen
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
					},
				},
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function()
			require("lsp_signature").setup()
		end,
	},
	-- Indent guides on every line
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		setup = function()
			vim.g.indentLine_enabled = 1
			vim.g.indent_blankline_char = "▏"
			vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard" }
			vim.g.indent_blankline_buftype_exclude = { "terminal" }
			vim.g.indent_blankline_show_trailing_blankline_indent = false
			vim.g.indent_blankline_show_first_indent_level = false
		end,
	},
	-- Smooth scrolling
	{ "psliwka/vim-smoothie" },
	--- Pick the file where you edited last time
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	-- better quickfix
	{
		"kevinhwang91/nvim-bqf",
		event = "BufReadPost",
		config = function()
			require("user.bqf").config()
		end,
	},
	-- Awesome diff view
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	{
		"AckslD/nvim-neoclip.lua",
		requires = { "tami5/sqlite.lua" },
		config = function()
			require("user.neoclip").config()
		end,
	},
	--treesiter
	require("user.textObjects").plugin,
	-- sessions management
	-- persistence.plugin,
	require("user.autosession"),
}

vim.list_extend(lvim.plugins, require("user.telescope").plugins)

require("user.keymaps").add_which_map(persistence.which_map)

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ exe = "stylua", filetypes = { "lua" } },
})
