local M = {}

local create_sibling_file = require("user.util.create").create_sibling_file

function M.concat_lists(...)
  local result = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    vim.list_extend(result, v)
  end
  return result
end

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

local Ok, err = pcall(function()
  local bind_command = require("legendary").bind_command
  bind_command {
    ":CopyMessages",
    function()
      M.copy_messages_to_clipboard()
    end,
    description = "Copy the output of :messages to OS clipboard",
  }
  bind_command {
    ":CopyLast10Messages",
    M.bind(M.copy_messages_to_clipboard, 10),
    description = "Copy the last 10 lines of :messages to OS clipboard",
  }
  bind_command {
    ":CreateSibling",
    create_sibling_file,
    description = "Create a new file that is a sibling of the current one",
  }
end)

if not Ok then
  vim.notify("Error creating utility commands with legendary: " .. err, vim.log.levels.ERROR, { title = "Danielo" })
end

return M
