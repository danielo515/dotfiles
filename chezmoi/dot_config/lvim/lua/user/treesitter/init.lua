local textObjects = require("user.treesitter.textObjects")
local M = {}
--treesiter related plugins
M.plugins = {
	textObjects.plugin,
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
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},
	-- Highlight parens and that stuff using treesitter
	{ "p00f/nvim-ts-rainbow" },
}

local rainbow_config = {
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = 1500,
		colors = {
			"#f30f3f",
			"#ffa500",
			"#ffff00",
			"#018000",
			"#0af34f",
			"#cf4eea",
			"#ee82ee",
		},
	},
}
local playground_config = {
	playground = {
		enable = true,
		updatetime = 20,
	},
}

local settings = {
	highlight = { enable = true },
	indent = { enable = true },
	autotag = { enable = true },
	rainbow = { enable = true },
	ignore_install = { "haskell" },

	ensure_installed = {
		"bash",
		"c",
		"javascript",
		"json",
		"lua",
		"python",
		"typescript",
		"tsx",
		"css",
		"rust",
		"java",
		"yaml",
	},
}
-- Setup the required configs for treesitter plugins
function M.config()
	-- if you don't want all the parsers change this to a table of the ones you want
	lvim.builtin.treesitter = vim.tbl_deep_extend(
		"force",
		lvim.builtin.treesitter,
		settings,
		playground_config,
		rainbow_config,
		textObjects.config
	)
end

return M
