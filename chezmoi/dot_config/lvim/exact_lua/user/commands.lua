local bind = require("danielo").bind
local create_sibling_file = require("user.util.create").create_sibling_file
local copy_messages_to_clipboard = require("user.util").copy_messages_to_clipboard

local Ok, err = pcall(function()
  local bind_command = require("legendary").bind_command
  bind_command {
    ":CopyMessages",
    function()
      copy_messages_to_clipboard()
    end,
    description = "Copy the output of :messages to OS clipboard",
  }
  bind_command {
    ":CopyLast10Messages",
    bind(copy_messages_to_clipboard, 10),
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
