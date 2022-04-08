local M = {}

function M.configure()
	local codelens_viewer = "lua require('nvim-lightbulb').update_lightbulb()"
	lvim.autocommands.custom_groups = {
		-- On entering a lua file, set the tab spacing and shift width to 8gg
		{ "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
		-- Apply chezmoi whenever a dotfile is updated
		{
			"BufWritePost",
			"$HOME/.local/share/chezmoi/chezmoi/*",
			"execute '!chezmoi apply --source-path %' | LvimReload ",
		},
		{ "CursorHold", "*.rs,*.go,*.ts,*.tsx", codelens_viewer },

		-- dashboard
		{ "FileType", "alpha", "nnoremap <silent> <buffer> q :q<CR>" },

		-- rust
		{ "Filetype", "rust", "nnoremap <leader>lm <Cmd>RustExpandMacro<CR>" },
		{ "Filetype", "rust", "nnoremap <leader>lH <Cmd>RustToggleInlayHints<CR>" },
		{ "Filetype", "rust", "nnoremap <leader>le <Cmd>RustRunnables<CR>" },
		{ "Filetype", "rust", "nnoremap <leader>lh <Cmd>RustHoverActions<CR>" },
		{ "Filetype", "rust", "nnoremap <leader>lc <Cmd>RustOpenCargo<CR>" },
		{ "Filetype", "rust", "nnoremap gA <Cmd>RustHoverActions<CR>" },

		-- typescript
		{ "Filetype", "typescript,typescriptreact", "nnoremap gA <Cmd>TSLspImportAll<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gr <Cmd>TSLspRenameFile<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gS <Cmd>TSLspOrganize<CR>" },

		-- uncomment the following if you want to show diagnostics on hover
		-- { "CursorHold", "*", "lua vim.diagnostic.open_float()" },
	}
end

return M
