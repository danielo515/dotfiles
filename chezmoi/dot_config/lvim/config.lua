require "danielo.globals"
local concat_lists = require("danielo").concat_lists
-- Settings related to GUI clients like neovide
require "settings.gui"
-- generic LSP settings
lvim.lsp.installer.setup.automatic_servers_installation = true
-- Required for ocaml-lsp TODO: do not use hardcoded path
vim.opt.rtp:append "/Users/danielo/.opam/default/share/ocp-indent/vim"
-- Project
lvim.builtin.project.patterns = { ".git", "package.json", "config.lua" }
lvim.builtin.project.silent_chdir = false
-- Packer fix
local packer = require "packer"

packer.init {
  max_jobs = 10,
  git = {
    clone_timeout = 10, -- timeout in seconds
  },
}
-- general
lvim.log.level = "debug"
lvim.format_on_save = true
-- require("user.theme").tokyonight()
lvim.colorscheme = "tokyonight"
lvim.builtin.theme.options.style = "storm"
lvim.builtin.theme.options.dim_inactive = true
lvim.leader = "space"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
-- Always show line blame like VSCode
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.lsp.float.max_height = 20
lvim.builtin.cmp.confirm_opts.behavior = require("cmp").ConfirmBehavior.Insert
lvim.builtin.autopairs.active = false
lvim.builtin.bufferline.options.numbers = "buffer_id"
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
vim.go.showmode = true

D.pconf "user.builtin.luasnip"
D.pconf "user.keymaps"
D.pconf "user.builtin.which-key"
D.pconf "user.telescope"
D.pconf "user.statusline"
D.pconf "user.sniprun"
D.pconf "user.builtin.nvimtree"
D.pconf "semgrep"
D.pconf "user.lsp"
D.pconf "user.commands"
D.pconf "user.null-completions"
-- require("user.lualine").config()
require("luasnip.loaders.from_snipmate").lazy_load()
local treesitter = require "user.treesitter"
treesitter.config()
local plugins = require "user.plugins"
local inject_sha = require("user.util.plugins").inject_snapshot_commit
local snapshot_path = join_paths(get_config_dir(), "snapshots", "default.json")
lvim.plugins = inject_sha(concat_lists(plugins, treesitter.plugins, require "user.telescope.settings"), snapshot_path)
D.pconf "user.autocommands"
-- I call this after because it appends to the existing Danielo autocmd group
D.pconf "user.auto-resize-window"
