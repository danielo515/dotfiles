local log = require("lvim.core.log")
local M = {}

local lv_which = lvim.builtin.which_key.mappings
-- This config will be merged with the one that lvim has by default
local whichConfig = {
	-- extend search
	s = {
		d = { "<cmd>lua require('user.telescope').dotfiles()<cr>", "Search dotfiles" },
		q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		C = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols" },
		n = { "<cmd>Telescope notify<cr>", "Notifications" },
		["."] = { "<cmd>Telescope resume<cr>", "Repeat search" },
	},
	["."] = {
		"<cmd>lua require('user.telescope').find_siblings()<cr>",
		"Search sibling files",
	},

	[","] = {
		"<cmd>lua require('user.telescope').find_on_parent()<cr>",
		"Search files on parent folder",
	},
	["P"] = { "<cmd>Telescope projects<CR>", "Projects" },
	["t"] = {
		name = "+Trouble",
		r = { "<cmd>Trouble lsp_references<cr>", "References" },
		f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
		d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
		q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
		l = { "<cmd>Trouble loclist<cr>", "LocationList" },
		w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace diagnostics" },
	},
	-- extend git
	["g"] = {
		S = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		s = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage file" },
		B = { "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>", "Togle blame" },
		d = { "<cmd>DiffviewOpen<cr>", "Open git diff" },
	},
}
-- merge our custom config with the one from lvim
lvim.builtin.which_key.mappings = vim.tbl_deep_extend("force", lv_which, whichConfig)

function M.add_which_map(definition)
	if vim.tbl_isempty(definition) then
		log:error("Can't use an empty list to extend which key")
		return nil
	end
	lvim.builtin.which_key.mappings = vim.tbl_deep_extend("error", lvim.builtin.which_key.mappings, definition)
end

lvim.keys.normal_mode["<C-f>"] = "<cmd>lua require('user.telescope').grep_files()<cr>"
lvim.keys.normal_mode["<C-x>"] = "<cmd>BufferKill<cr>"
lvim.keys.normal_mode["<M-cr>"] = "<cmd>lua vim.lsp.codelens.run()<cr>"
lvim.keys.normal_mode["kj"] = false
lvim.keys.normal_mode["jk"] = false
lvim.keys.normal_mode["s"] = ":HopChar1<cr>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<F2>"] = "<cmd>lua vim.lsp.buf.rename()<cr>"
lvim.keys.normal_mode["F"] = ":Telescope frecency<cr>"
lvim.keys.normal_mode["<Tab>"] = "<cmd>lua require('user.telescope').buffers()<cr>"

lvim.keys.visual_mode["p"] = '"0p'
-- Tab bindings
lvim.keys.normal_mode["tk"] = ":tabclose<cr>"
lvim.keys.normal_mode["tn"] = ":tabnew<cr>"
lvim.keys.normal_mode["tl"] = ":tabNext<cr>"
-- insert_mode key bindings
lvim.keys.insert_mode["<C-f>"] = lvim.keys.normal_mode["<C-f>"]
lvim.keys.insert_mode["<C-y>"] =
	"<cmd>lua require('telescope').extensions.neoclip.default(require('telescope.themes').get_cursor())<cr>"

return M
