require "danielo.globals"
-- generic LSP settings
lvim.lsp.installer.setup.automatic_servers_installation = true
-- Required for ocaml-lsp TODO: do not use hardcoded path
vim.opt.rtp:append "/Users/danielo/.opam/default/share/ocp-indent/vim"
-- Project
lvim.builtin.project.patterns = { ".git", "package.json" }
lvim.builtin.project.silent_chdir = false
lvim.builtin.project.manual_mode = true
-- Packer fix
local packer = require "packer"

packer.init {
  max_jobs = 10,
  git = {
    clone_timeout = 10, -- timeout in seconds
  },
}
-- general
-- lvim.log.level = "debug"
lvim.format_on_save = true
-- TODO: update on new lvim versions
lvim.colorscheme = "tokyonight"
if lvim.builtin.theme.tokyonight ~= nil then
  lvim.builtin.theme.tokyonight.options.style = "night"
  lvim.builtin.theme.tokyonight.options.dim_inactive = true
  lvim.builtin.theme.tokyonight.options.lualine_bold = true
else
  lvim.builtin.theme.options.style = "night"
  lvim.builtin.theme.options.dim_inactive = true
  lvim.builtin.theme.options.lualine_bold = true
end

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
D.pconf "user.dashboard"
--#region Temporal test
lvim.builtin.nvimtree.setup.update_cwd = false
lvim.builtin.nvimtree.setup.hijack_directories = { enable = false }
lvim.builtin.nvimtree.setup.update_focused_file.update_cwd = false
lvim.builtin.nvimtree.setup.update_focused_file.enable = false
--#endregion

vim.wo.relativenumber = true
-- This is required for vim-surround, otherwise it is too fast
vim.o.timeoutlen = 500
vim.o.wrap = true

local options = {
  -- foldmethod = "expr", -- folding, set to "expr" for treesitter based folding
  -- foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  foldnestmax = 3,
  -- foldlevel = 4,
  -- foldlevelstart = 2,
  -- foldenable = false,
  laststatus = 3,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.cpoptions:append "y"
vim.go.showmode = true

-- Settings related to GUI clients like neovide
D.pconf "settings.gui"
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
D.pconf "user.indent-blankline"
D.pconf "user.filetype"
-- require("user.lualine").config()
require("luasnip.loaders.from_snipmate").lazy_load()
local plugins = require "user.plugins"
lvim.plugins = plugins
D.pconf "user.autocommands"
-- I call this after because it appends to the existing Danielo autocmd group
D.pconf "user.auto-resize-window"
