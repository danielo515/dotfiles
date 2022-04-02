local telescope = require("telescope.builtin")

local M = {}

M.dotfiles = function()
	telescope.find_files({ cwd = "~/.dotfiles/" })
end

return M
