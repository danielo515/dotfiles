local concat_lists = require("user.util").concat_lists
-- Settings related to GUI clients like neovide
require "settings.gui"
-- generic LSP settings
lvim.lsp.automatic_servers_installation = true
-- Project
lvim.builtin.project.patterns = { ".git", "package.json" }
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

vim.wo.relativenumber = true
-- This is required for vim-surround, otherwise it is too fast
vim.o.timeoutlen = 500

local options = {
  foldmethod = "expr", -- folding, set to "expr" for treesitter based folding
  foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  laststatus = 3,
  foldnestmax = 3,
  foldlevel = 4,
  foldlevelstart = 2,
  foldenable = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.cpoptions:append "y"

require "user.keymaps"
require "user.which-key"
require "user.telescope"
require "user.statusline"
require "user.sniprun"
require "user.builtin.nvimtree"
require("user.lsp").config()
require("user.auto-resize-window").setup()
-- require("user.lualine").config()
require("luasnip.loaders.from_snipmate").lazy_load()
local treesitter = require "user.treesitter"
treesitter.config()
local plugins = require "user.plugins"
lvim.plugins = concat_lists(plugins, treesitter.plugins, require "user.telescope.settings")
require("user.autocommands").config()
