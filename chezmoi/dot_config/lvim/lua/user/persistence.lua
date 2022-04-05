local M = {
	plugin = {
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup({
				dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
				options = { "buffers", "curdir", "tabpages", "winsize" },
			})
		end,
	},
	which_map = {
		["S"] = {
			name = "Session",
			c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
			l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
			Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
		},
	},
}

return M
