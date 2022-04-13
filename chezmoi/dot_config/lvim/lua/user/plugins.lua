local plugins = {
	{ "Mofiqul/dracula.nvim" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	-- better surround options
	{ "tpope/vim-surround", keys = { "c", "d", "y" } },
	{ "tpope/vim-repeat" },
	-- jump faster
	{
		"phaazon/hop.nvim",
		branch = "v1", -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},
	-- fuzzy jummp on the file
	{ "rlane/pounce.nvim" },

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

	-- shows the function signatures when you are inside the parameter
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
	-- {
	-- 	"karb94/neoscroll.nvim",
	-- 	config = function()
	-- 		require("neoscroll").setup({
	-- 			hide_cursor = false, -- Hide cursor while scrolling
	-- 		})
	-- 	end,
	-- },
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
	-- Clipboard history
	{
		"AckslD/nvim-neoclip.lua",
		requires = { "tami5/sqlite.lua" },
		after = "which-key.nvim",
		config = function()
			require("user.neoclip").config()
		end,
	},
	-- powerful search and replace
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
		end,
	},
	-- sessions management
	-- persistence.plugin,
	require("user.autosession"),
	{ "kosayoda/nvim-lightbulb" },

	-- auto close and rename markup tags
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	-- show colors inline
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, {
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				mode = "background", -- Set the display mode.
			})
		end,
	},
	{
		"petertriho/nvim-scrollbar",
		event = "BufWinEnter",
		config = function()
			require("scrollbar").setup()
		end,
	},
	-- VSCode like omni bar
	{ "mrjones2014/legendary.nvim", branch = "test-which-key-changes" },
}
return plugins
