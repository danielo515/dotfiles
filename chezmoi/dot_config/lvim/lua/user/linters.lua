local M = {}

function M.config()
	local formatters = require("lvim.lsp.null-ls.formatters")
	formatters.setup({
		{
			command = "eslint",
			filetypes = { "typescript", "typescriptreact" },
		},
		{ exe = "stylua", filetypes = { "lua" } },
	})

	local linters = require("lvim.lsp.null-ls.linters")
	linters.setup({
		{ command = "eslint", filetypes = { "typescript", "typescriptreact" } },
	})
end

return M
