local M = {}

function M.bind(fn, ...)
  local args = { ... }
  return function()
    return fn(unpack(args))
  end
end

function M.copy_messages_to_clipboard(number)
  local cmd = [[ let @* = execute('%smessages') ]]
  number = number or ""
  vim.cmd(string.format(cmd, number))
  vim.notify(":messages copied to the clipboard", "info")
end

return M
