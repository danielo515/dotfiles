function yank_file_name()
	local path = vim.fn.expand("%")
	vim.fn.setreg("*", path)
	vim.notify(path .. " yanked to keyboard")
end
-- This config will be merged with the one that lvim has by default
local whichConfig = {
	-- extend search
	s = {
		d = { "<cmd>lua require('user.telescope').dotfiles()<cr>", "Search dotfiles" },
		q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		C = { "<cmd>Telescope command_history<cr>", "Commands history" },
		s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
		n = { "<cmd>Telescope notify<cr>", "Notifications" },
		j = { "<cmd>Telescope jumplist<cr>", "Jump list" },
		P = { "<cmd>Telescope packer<cr>", "Packer search" },
		["."] = { "<cmd>Telescope resume<cr>", "Repeat search" },
	},
	S = {
		"<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
		"Spectre search",
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
		g = { "<cmd>lua require 'lazygit'.lazygit()<cr>", "Open git diff" },
	},
	-- file section
	f = {
		f = { "<cmd>Telescope frecency default_workspace=CWD<cr>", "Browse recent files" },
		r = { "<cmd>Telescope frecency<cr>", "Browse recent files globally" },
		b = { "<cmd>Telescope file_browser<cr>", "Browse file tree cool" },
		y = { "<cmd>lua yank_file_name()<CR>", "Yank current file path" },
	},
}
-- merge our custom config with the one from lvim
-- lvim.builtin.which_key.mappings = vim.tbl_deep_extend("force", lv_which, whichConfig)

lvim.builtin.which_key.on_config_done = function(which)
	require("legendary").setup()
	which.register(whichConfig, { prefix = "<leader>" })
	vim.notify("Reloaded wich keys")
end

local ok, which = pcall(require, "wich-key")
if not ok then
	return
end
lvim.builtin.which_key.on_config_done(which)
