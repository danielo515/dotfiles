lvim.keys.normal_mode["<C-F>"] = "<cmd>lua require('user.telescope').grep_files()<cr>"
lvim.keys.normal_mode["<C-x>"] = "<cmd>BufferKill<cr>"
lvim.keys.normal_mode["<M-cr>"] = "<cmd>lua require('lvim.core.telescope').code_actions()<cr>"
lvim.keys.normal_mode["kj"] = false
lvim.keys.normal_mode["jk"] = false
lvim.keys.normal_mode["s"] = ":Pounce<cr>"
lvim.keys.normal_mode["<F2>"] = "<cmd>lua vim.lsp.buf.rename()<cr>"
lvim.keys.normal_mode["F"] = ":Telescope frecency<cr>"
lvim.keys.normal_mode["<Tab>"] = "<cmd>lua require('user.telescope').buffers()<cr>"
lvim.keys.normal_mode["<M-k>"] = ":Telescope builtin include_extensions=true<cr>"
lvim.keys.normal_mode["<C-N>"] = ":NvimTreeFindFile<cr>"
lvim.keys.normal_mode["ml"] = "dd<C-W><C-l>p<C-w><C-h>"
-- visual mode
lvim.keys.visual_mode["p"] = [["_dP]] -- avoid override when pasting over seleted text
lvim.keys.visual_mode["s"] = ":Pounce<cr>"
-- Tab bindings
lvim.keys.normal_mode["tk"] = ":tabclose<cr>"
lvim.keys.normal_mode["tn"] = ":tabnew<cr>"
lvim.keys.normal_mode["tl"] = ":tabNext<cr>"
-- insert_mode key bindings
lvim.keys.insert_mode["<C-f>"] = lvim.keys.normal_mode["<C-F>"]
lvim.keys.insert_mode["<C-y>"] =
	"<cmd>lua require('telescope').extensions.neoclip.default(require('telescope.themes').get_cursor())<cr>"
lvim.keys.insert_mode["<C-s>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>"
lvim.keys.insert_mode["<A-s>"] =
	"<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<CR>"
