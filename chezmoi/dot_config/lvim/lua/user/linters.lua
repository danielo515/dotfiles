local M = {}

function M.config()
	local formatters = require("lvim.lsp.null-ls.formatters")
	formatters.setup({
		{
			name = "eslint_d",
		},
		{ name = "stylua" },
	})

	local linters = require("lvim.lsp.null-ls.linters")
	linters.setup({
		{ command = "eslint", filetypes = { "typescript", "typescriptreact" } },
	})
	local graphql_lsp_opts = {
		filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript" },
	}

	require("lvim.lsp.manager").setup("graphql", graphql_lsp_opts)
end

return M
