local M = {}

function M.concat_lists(...)
	local result = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		vim.list_extend(result, v)
	end
	return result
end

return M
