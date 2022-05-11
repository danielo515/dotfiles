local M = {}

M.config = {

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
				-- ["iq"] = "@string.inner",
				-- ["aq"] = "@string.outer",
			},
		},
		lsp_interop = {
			enable = true,
			border = "none",
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]p"] = "@parameter.inner",
				["]f"] = "@function.outer",
				-- ["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				-- ["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[p"] = "@parameter.inner",
				["[f"] = "@function.outer",
				-- ["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				-- ["[]"] = "@class.outer",
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
