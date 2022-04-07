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

		-- toggleterm
		{ "TermOpen", "term://*", "lua require('user.keybindings').set_terminal_keymaps()" },

		-- dashboard
		{ "FileType", "alpha", "nnoremap <silent> <buffer> q :q<CR>" },

		-- c, cpp
		{ "Filetype", "c,cpp", "nnoremap <leader>H <Cmd>ClangdSwitchSourceHeader<CR>" },

		-- go
		{
			"Filetype",
			"go",
			"nnoremap <leader>H <cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='go vet .;read',count=2,direction='float'})<CR>",
		},

		-- java
		{
			"Filetype",
			"java",
			"nnoremap <leader>r <cmd>lua require('toggleterm.terminal').Terminal:new {cmd='mvn package;read', hidden =false}:toggle()<CR>",
		},
		{
			"Filetype",
			"java",
			"nnoremap <leader>m <cmd>lua require('toggleterm.terminal').Terminal:new {cmd='mvn compile;read', hidden =false}:toggle()<CR>",
		},
		{
			"Filetype",
			"scala,sbt,java",
			"lua require('user.metals').config()",
		},

		-- rust
		{
			"Filetype",
			"rust",
			"nnoremap <leader>H <cmd>lua require('lvim.core.terminal')._exec_toggle({cmd='cargo clippy;read',count=2,direction='float'})<CR>",
		},
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
		-- { "CursorHold", "*", "lua vim.diagnostic.open_float(0,{scope='line'})" },
	}
end

return M
