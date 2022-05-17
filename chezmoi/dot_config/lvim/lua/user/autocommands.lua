local M = {}

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])

local function reloadSnippets()
	require("luasnip").cleanup() -- opts can be ommited
	require("luasnip.loaders.from_snipmate").load() -- opts can be ommited
	require("luasnip.loaders.from_vscode").load() -- opts can be ommited
end

-- local danieloSnip = vim.api.nvim_create_namespace("danielo-snip")
local danieloSnip = vim.api.nvim_create_augroup("danielo-snip", {
	clear = true,
})

vim.api.nvim_create_autocmd({
	"BufWritePost",
}, {
	pattern = { "*.snippets" },
	callback = reloadSnippets,
	group = danieloSnip,
})

function M.config()
	local codelens_viewer = "lua require('nvim-lightbulb').update_lightbulb()"
	lvim.autocommands.custom_groups = {
		-- On entering a lua file, set the tab spacing and shift width to 8gg
		{ "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
		-- Automatically adjust the window width when you enter it
		{ "WinEnter", "*", "ResizeWindow" },
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
		{ "Filetype", "typescript,typescriptreact", "nnoremap gA <Cmd>TypescriptAddMissingImports<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gr <Cmd>TypescriptRenameFile<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gS <Cmd>TypescriptOrganizeImports<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gR <Cmd>TypescriptRemoveUnused<CR>" },
		{ "Filetype", "typescript,typescriptreact", "nnoremap gx <Cmd>TypescriptFixAll<CR>" },

		-- uncomment the following if you want to show diagnostics on hover
		-- { "CursorHold", "*", "lua vim.diagnostic.open_float()" },
	}
end

return M
