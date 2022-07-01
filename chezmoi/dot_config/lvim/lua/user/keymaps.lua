lvim.keys.normal_mode["<C-F>"] = "<cmd>lua require('user.telescope').grep_files()<cr>"
-- lvim.keys.normal_mode["<C-P>"] = "<C-W><C-P>"
lvim.keys.normal_mode["<C-x>"] = "<cmd>BufferKill<cr>"
lvim.keys.normal_mode["kj"] = false
lvim.keys.normal_mode["jk"] = false
-- Navigation
lvim.keys.normal_mode["s"] = ":Pounce<cr>"
lvim.keys.visual_mode["s"] = "<cmd>Pounce<cr>"
-- Lsp
lvim.keys.normal_mode["<F2>"] = "<cmd>lua vim.lsp.buf.rename()<cr>"
lvim.keys.normal_mode["<M-cr>"] = "<cmd>lua vim.lsp.buf.code_action()<cr>"
lvim.keys.visual_mode["<M-cr>"] = "<cmd>lua vim.lsp.buf.range_code_action()<cr>" -- Select and apply actions
-- File
lvim.keys.normal_mode["<M-F>"] = '<cmd>lua require("telescope").extensions.file_browser.file_browser { cwd = vim.fn.expand "%:p:h:", grouped = true, depth= false, hidden = true }<CR>'
lvim.keys.normal_mode["<Tab>"] = "<cmd>lua require('user.telescope').buffers()<cr>"
lvim.keys.normal_mode["<S-Tab>"] = ":Neotree float reveal<cr>"
-- Other
-- lvim.keys.normal_mode["<M-k>"] = ":Telescope builtin include_extensions=true<cr>"
lvim.keys.normal_mode["<A-k>"] = ":Telescope command_center<CR>"
-- lvim.keys.normal_mode["<C-N>"] = ":NvimTreeFindFileToggle<cr>"
lvim.keys.normal_mode["<C-N>"] = ":NvimTreeFindFile<cr>"
lvim.keys.normal_mode["<C-;>"] = ":Telescope command_history<cr>"
lvim.keys.normal_mode["ml"] = "dd<C-W><C-l>p<C-w><C-h>"
lvim.keys.normal_mode[",n"] = "<cmd>lua vim.diagnostic.goto_next()<cr>"
lvim.keys.normal_mode["+"] = "<cmd>3wincmd > <cr>"
lvim.keys.normal_mode["-"] = "<cmd>3wincmd < <cr>"
-- visual mode
lvim.keys.visual_mode["p"] = [["_dP]] -- avoid override when pasting over seleted text
-- Tab bindings
lvim.keys.normal_mode["tk"] = ":tabclose<cr>"
lvim.keys.normal_mode["tn"] = ":tabnew<cr>"
lvim.keys.normal_mode["tl"] = ":tabNext<cr>"
lvim.keys.normal_mode["th"] = ":tabprev<cr>"
-- I'm handling this myself in a separate plugin
lvim.keys.normal_mode["gp"] = nil
-- insert_mode key bindings
lvim.keys.insert_mode["<C-f>"] = lvim.keys.normal_mode["<C-F>"]
lvim.keys.insert_mode["<C-y>"] = "<cmd>lua require('telescope').extensions.neoclip.default(require('telescope.themes').get_cursor())<cr>"
lvim.keys.insert_mode["<C-s>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>"
lvim.keys.insert_mode["<A-s>"] = "<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<CR>"
-- control a navigates to home in command mode
vim.keymap.set("c", "<C-A>", "<Home>", { noremap = false })

-- omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
vim.keymap.set("o", "m", ':<C-U>lua require("tsht").nodes()<CR>', { silent = true, desc = "Higlight nodes to jump to" })
-- vnoremap <silent> m :lua require('tsht').nodes()<CR>
vim.keymap.set(
  "v",
  "m",
  ':<C-U>lua require("tsht").nodes()<CR>',
  { silent = true, noremap = false, desc = "Higlight nodes to jump to" }
)

local function nmap(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { silent = true, noremap = true, desc = desc })
end

local bind = require "user.util".bind
nmap('<C-C>', bind(vim.api.nvim_win_close, 0, false), 'Close current window')
nmap("<C-P>", ":Telescope command_center<cr>",'Open command center')
