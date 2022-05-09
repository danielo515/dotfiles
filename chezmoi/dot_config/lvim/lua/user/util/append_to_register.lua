local M = {}

function M.as_array()
	local word = vim.fn.expand("<cword>")
	vim.fn.setreg("*", "'" .. word .. "', ", "a")
end

return M
