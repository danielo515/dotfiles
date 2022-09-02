local plugin_name = "Semgrep"
local M = {}

--- Easily extend the defaults with the provided option values
--- Returns a new table
---@generic T table
---@param default T
---@param extension table?
---@return T
function M.defaults(default, extension)
  return vim.tbl_deep_extend("force", default, extension or {})--[[@as table]]
end

--- Helper to show a notification to user
---@param msg string the message to send
---@param level 'ERROR'|'WARN'|'INFO'
function M.notify(msg, level)
  vim.notify(msg, vim.log.levels[level], { title = plugin_name })
end

--- Parses any JSON string without throwing
---@param json_str string
---@return table|nil
function M.safe_parse(json_str)
  local ok, val = pcall(vim.fn.json_decode, json_str)
  if ok then
    return val
  end
  return nil
end

function M.register_autocommands(autocommands)
  local group = vim.api.nvim_create_augroup(plugin_name, {})
  for _, command in ipairs(autocommands) do
    local name, pattern, cmd, desc = unpack(command)
    local options = { pattern = pattern, group = group, desc = desc }

    if type(cmd) == "string" then
      options.command = cmd
    else
      options.callback = cmd
    end

    vim.api.nvim_create_autocmd(name, options)
  end
end

function M.complete_list(list_as_string)
  return function()
    return vim.fn.split(list_as_string, ",")
  end
end

local completion_table = {}

function M.complete(lead, cmdline, pos)
  local cmd_key = vim.trim(cmdline)
  return completion_table[cmd_key] or {}
end

--- Shortcut for creatring user commands
---@param user_commands string[][]
function M.register_commands(user_commands)
  for _, command in ipairs(user_commands) do
    local name, cmd, complete, nargs, desc = unpack(command)
    completion_table[name] = complete
    local custom_complete = [[customlist,v:lua.require'semgrep.util'.complete]]
    local options = { complete = custom_complete, desc = desc, nargs = nargs or 0, force = true }
    vim.pretty_print(options)
    vim.api.nvim_create_user_command(name, cmd, options)
  end
end
return M
