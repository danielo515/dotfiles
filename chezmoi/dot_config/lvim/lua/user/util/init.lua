local M = {}

function M.concat_lists(...)
	local result = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		vim.list_extend(result, v)
	end
	return result
end

local resize_ignore = { "lazygit", "neo-tree", "NvimTree", "help", "terminal", "command", "toggleterm" }
-- @TODO: take only visible portion into account
-- Resizes the current window to the maximum required width
function M.resize_window_width()
	local bufType = vim.opt.filetype:get()
	if vim.tbl_contains(resize_ignore, bufType) then
		print("resize ignore")
		return
	end

	local terminalWidth = vim.opt.columns:get()
	local getOpt = vim.api.nvim_win_get_option
	local lines_count = vim.api.nvim_buf_line_count(0)
	local lines = vim.api.nvim_buf_get_lines(0, 0, lines_count, false)
	local numbers_active = getOpt(0, "rnu") or getOpt(0, "number")
	local numwidth = numbers_active and getOpt(0, "nuw") or 0
	local signwidth = getOpt(0, "signcolumn") == "yes" and 2 or 0
	local padding = numwidth + 1 + getOpt(0, "foldcolumn") + signwidth

	local longerLine = 0
	for _, line in ipairs(lines) do
		local new_len = string.len(line) or 0
		if new_len > longerLine then
			longerLine = new_len
		end
	end
	local current_width = vim.api.nvim_win_get_width(0)
	local new_width = longerLine + padding
	if current_width >= new_width then -- skip if window is width enough already
		return
	end
	if new_width > (terminalWidth * 0.8) then -- skip if new width will be bigger than 80% of screen
		return
	end
	local cmd = new_width .. "wincmd |"
	vim.api.nvim_command(cmd)
end

vim.cmd('command! ResizeWindow :lua require("user.util").resize_window_width()')

function M.copy_messages_to_clipboard()
	local cmd = [[
redir @*
messages
redir END
]]
	vim.cmd(cmd)
	vim.notify(":messages copied to the clipboard", "info")
end

pcall(function()
	require("legendary").bind_command({
		":CopyMessages",
		M.copy_messages_to_clipboard,
		description = "Copy the output of :messages to OS clipboard",
	})
end)

function M.bind(fn, ...)
	local args = table.pack(...)
	return function()
		fn(unpack(args))
	end
end

return M
