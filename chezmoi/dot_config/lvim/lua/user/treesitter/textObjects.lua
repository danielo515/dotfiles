local M = {}

M.config = {
	indent = { enable = true },
	autotag = { enable = true },
	rainbow = { enable = false },

	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},

	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",

				["ia"] = "@parameter.inner", -- "ap" is already used

				["aa"] = "@parameter.outer", -- "ip" is already used
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["."] = "textsubjects-smart",
				[";"] = "textsubjects-big",
			},
		},
	},
}

-- treesitter
M.plugin = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	event = "BufRead",
}

return M
