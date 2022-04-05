--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.nvimtree.setup.view.auto_resize = true
lvim.builtin.nvimtree.setup.view.side = "left"

lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings
lvim.lsp.automatic_servers_installation = true

lvim.autocommands.custom_groups = {
	-- On entering a lua file, set the tab spacing and shift width to 8gg
	{ "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
	-- Apply chezmoi whenever a dotfile is updated
	{
		"BufWritePost",
		"$HOME/.local/share/chezmoi/chezmoi/*",
		"execute '!chezmoi apply --source-path %' | LvimReload ",
	},
}
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- hot reload
for module, _ in pairs(package.loaded) do
	if module:match("user") then
		_G.require_clean(module)
	end
end

require("user.keymaps")
require("user.telescope")
require("user.plugins")
require("user.statusline")
