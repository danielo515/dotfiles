local concat_lists = require("user.util").concat_lists
-- generic LSP settings
lvim.lsp.automatic_servers_installation = true
-- general
lvim.log.level = "debug"
lvim.format_on_save = true
lvim.colorscheme = "dracula"
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
lvim.builtin.which_key.setup.plugins.presets.motions = true

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

require("user.keymaps")
require("user.which-key")
require("user.telescope")
require("user.autocommands").config()
-- require("user.statusline")
require("user.linters").config()
-- require("user.lualine").config()
require("luasnip.loaders.from_snipmate").lazy_load()
local treesitter = require("user.treesitter")
treesitter.config()
local plugins = require("user.plugins")
lvim.plugins = concat_lists(plugins, treesitter.plugins, require("user.telescope.settings"))
