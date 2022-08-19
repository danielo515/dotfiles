local M = {}

function M.config()
	local kopts = { noremap = true, silent = true }

	vim.api.nvim_set_keymap(
		"n",
		"n",
		[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
		kopts
	)
	vim.api.nvim_set_keymap(
		"n",
		"N",
		[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
		kopts
	)
	vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
	vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
	vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
	vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
end

M.plugin = { "kevinhwang91/nvim-hlslens", config = M.config }

return M
