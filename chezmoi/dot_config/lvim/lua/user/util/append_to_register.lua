local M = {}

function M.as_array()
	local word = vim.fn.expand("<cword>")
	vim.fn.setreg("*", "'" .. word .. "', ", "a")
end

local function add_to_reg(reg, text)
	vim.fn.setreg(reg, text, "a")
end

local ts = require("nvim-treesitter.ts_utils")
local isKey = true
-- Appends the current string under cursor to a registry with object notation
function M.as_object(reg)
	reg = reg or "*"
	local node = ts.get_node_at_cursor()
	local node_type = node:type()
	if not node_type:find("string") then
		vim.notify("This function only works with cursor at strings", "warn")
		return
	end
	local text = ts.get_node_text(node)[1]
	print(node_type, text)
	local wrap = isKey and (not text:find('"')) and '"' or ""
	local separator = isKey and ": " or ", "
	isKey = not isKey
	add_to_reg(reg, wrap .. text .. wrap .. separator)
end

return M
