local M = {}

local fun = require "danielo.fun"

---Dummy function to be able to offer auto-complete from lua.
-- It takes an argument, and returns a function that will return that argument.
-- This allows you to parametrize the lua function that vim will call
function M.expand(text)
  return function()
    return text
  end
end

---Nicer method to call vim.ui.input.
--Takes care of some of the gotchas like providing a list
--of completion strings and does not call the callback if it gets an empty response
---@param callback fun(text:string)
---@param completion_list string[]
function M.input(callback, completion_list)
  vim.ui.input({
    --This has several limitations. We need to pass a single argument because trying to provide several
    -- is going to make the string become invalid.
    --also need to escape the line feed or the provided string will be invalid.
    completion = string.format(
      "custom,v:lua.require'danielo.vim'.expand('%s')",
      --custom can have several options, but they must be newline separated
      table.concat(completion_list, "\\n")
    ),
  }, function(text)
    if not text or text == "" then
      return
    end
    callback(text)
  end)
end

---Create an autocommand, creating the autogroup if needed
---@param events string[]
---@param group string
---@param opts { pattern: string, desc: string, callback: function }
function M.autocmd(events, group, opts)
  local real_group = vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(events, fun.assign({ group = real_group }, opts))
end

function M.send_keys(text)
  -- escape any key references in the text
  local escaped_text = vim.api.nvim_replace_termcodes(text, false, true, true)
  -- send the escaped text to nvim
  vim.api.nvim_feedkeys(escaped_text, "n", true)
end

return M
