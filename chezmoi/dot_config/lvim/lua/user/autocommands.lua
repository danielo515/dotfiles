local M = {}

function M.config()
	local codelens_viewer = "lua require('nvim-lightbulb').update_lightbulb()"
	lvim.autocommands.custom_groups = {
		-- On entering a lua file, set the tab spacing and shift width to 8gg
		{ "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
		-- Apply chezmoi whenever a dotfile is updated
		{
			"BufWritePost",
			"$HOME/.local/share/chezmoi/chezmoi/*",
			"execute '!chezmoi apply -v --source-path %' | LvimReload ",
		},
		{ "CursorHold", "*.rs,*.go,*.ts,*.tsx,*.lua", codelens_viewer },

		-- dashboard
		{ "FileType", "alpha", "nnoremap <silent> <buffer> q :q<CR>" },

		-- typescript
		{ "Filetype", "typescript,typescriptreact", "nnoremap gA <Cmd>TSLspImportAll<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gr <Cmd>TSLspRenameFile<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gS <Cmd>TSLspOrganize<CR>" },

		-- uncomment the following if you want to show diagnostics on hover
		-- { "CursorHold", "*", "lua vim.diagnostic.open_float()" },
	}
end

return M
