local concat_lists = require("user.util").concat_lists
-- generic LSP settings
lvim.lsp.automatic_servers_installation = true
-- general
lvim.log.level = "debug"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"
lvim.builtin.nvimtree.setup.open_on_setup = false
lvim.builtin.nvimtree.setup.view.auto_resize = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1
lvim.builtin.which_key.setup.plugins.presets = {
	operators = false, -- adds help for operators like d, y, ...
	motions = false, -- adds help for motions
	text_objects = false, -- help for text objects triggered after entering an operator
	windows = true, -- default bindings on <c-w>
	nav = true, -- misc bindings to work with windows
	z = true, -- bindings for folds, spelling and others prefixed with z
	g = true, -- bindings for prefixed with g
}
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.lsp.float.max_height = 20

-- Dashboard
-- =========================================
lvim.builtin.alpha.mode = "custom"
local alpha_opts = require("user.dashboard").config()
lvim.builtin.alpha["custom"] = { config = alpha_opts }

lvim.builtin.nvimtree.setup.renderer = {
	indent_markers = {
		enable = true,
		icons = {
			corner = "└ ",
			edge = "│ ",
			none = "  ",
		},
	},
}

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
vim.wo.relativenumber = true
vim.o.guifont = "Inconsolata Nerd Font"
-- This is required for vim-surround, otherwise it is too fast
vim.o.timeoutlen = 500

local options = {
	foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
	foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
	foldnestmax = 3,
	foldlevel = 1,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

require("user.keymaps")
require("user.which-key")
require("user.telescope")
require("user.autocommands").config()
require("user.statusline")
require("user.linters").config()
-- require("user.lualine").config()
require("luasnip.loaders.from_snipmate").lazy_load()
local treesitter = require("user.treesitter")
treesitter.config()
local plugins = require("user.plugins")
lvim.plugins = concat_lists(plugins, treesitter.plugins, require("user.telescope.settings"))
