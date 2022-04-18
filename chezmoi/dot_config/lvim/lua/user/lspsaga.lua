local M = {}

M.plugin = {
	"tami5/lspsaga.nvim",
	config = M.config,
}

function M.config()
	--- In lsp attach function
	local map = vim.api.nvim_buf_set_keymap
	local opts = { silent = true, noremap = true }
	map(0, "n", "gr", "<cmd>Lspsaga rename<cr>", opts)
	map(0, "n", "gx", "<cmd>Lspsaga code_action<cr>", opts)
	map(0, "x", "gx", ":<c-u>Lspsaga range_code_action<cr>", opts)
	map(0, "n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
	map(0, "n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
	map(0, "n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
	map(0, "n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
	map(0, "n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
	map(0, "n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})
end
return M
