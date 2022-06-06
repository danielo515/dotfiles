local M = {}

local resize_ignore = { "lazygit", "neo-tree", "NvimTree", "help", "terminal", "command", "toggleterm" }
-- Resizes the current window to the maximum required width
function M.resize_window_width()
  local bufType = vim.opt.filetype:get()
  if vim.tbl_contains(resize_ignore, bufType) then
    print "resize ignore"
    return
  end

  local terminalWidth = vim.opt.columns:get()
  local getOpt = vim.api.nvim_win_get_option
  -- Only account for visible lines
  local win_start = vim.fn.line('w0')
  local win_end = vim.fn.line('w$')
  local lines = vim.api.nvim_buf_get_lines(0, win_start, win_end, false)
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

function M.setup()
  local group = vim.api.nvim_create_augroup("Danielo", { clear = false })
  -- vim.cmd 'command! ResizeWindow :lua require("user.util").resize_window_width()'
  local desc = "Automatically resize current window to make it fit it's visible content"
  vim.api.nvim_create_user_command('ResizeWindow', M.resize_window_width, { force = true, desc = desc })
  -- Automatically adjust the window width when you enter it
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = M.resize_window_width,
    group = group,
    desc = desc,
  })
end

return M
