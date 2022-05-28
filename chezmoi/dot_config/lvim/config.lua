local concat_lists = require("user.util").concat_lists
require("settings.gui")
-- generic LSP settings
lvim.lsp.automatic_servers_installation = true
-- general
lvim.log.level = "debug"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
-- Always show line blame like VSCode
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.lsp.float.max_height = 20
lvim.builtin.cmp.confirm_opts.behavior = require("cmp").ConfirmBehavior.Insert
-- Dashboard
-- =========================================
lvim.builtin.alpha.mode = "custom"
local alpha_opts = require("user.dashboard").config()
lvim.builtin.alpha["custom"] = { config = alpha_opts }

-- Nvimtree
-- =========================================
lvim.builtin.nvimtree.setup.open_on_setup = false
lvim.builtin.nvimtree.setup.view.auto_resize = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1
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
local function telescope_find_files(_)
	require("lvim.core.nvimtree").start_telescope("find_files")
end

local function telescope_live_grep(_)
	require("lvim.core.nvimtree").start_telescope("live_grep")
end

lvim.builtin.nvimtree.setup.view.mappings.list = {
	{ key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
	{ key = "h", action = "close_node" },
	{ key = "v", action = "vsplit" },
	{ key = "C", action = "cd" },
	{ key = "f", action = "telescope_find_files", action_cb = telescope_find_files },
	{ key = "gr", action = "telescope_live_grep", action_cb = telescope_live_grep },
}

-- Nvimtree end
-- =========================================

vim.wo.relativenumber = true
-- This is required for vim-surround, otherwise it is too fast
vim.o.timeoutlen = 500

local options = {
	foldmethod = "expr", -- folding, set to "expr" for treesitter based folding
	foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
	laststatus = 3,
	foldnestmax = 3,
	foldlevel = 5,
	foldlevelstart = 99,
	foldenable = false,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.cpoptions:append("y")

require("user.keymaps")
require("user.which-key")
require("user.telescope")
require("user.autocommands").config()
require("user.statusline")
require("user.sniprun")
require("user.linters").config()
-- require("user.lualine").config()
require("luasnip.loaders.from_snipmate").lazy_load()
local treesitter = require("user.treesitter")
treesitter.config()
local plugins = require("user.plugins")
lvim.plugins = concat_lists(plugins, treesitter.plugins, require("user.telescope.settings"))
