-- Fuck it, I'm gonna drop some global utility functions for my personal use!!
_G.D = {} -- But namespaced, obviously!

function D.Peek(arg)
  vim.pretty_print(arg)
  return arg
end

---Make a require of a module in a protected call. If the call succeeds, then call the on_success
---Everything is executed within protected calls
---@param path string
---@param on_success function
---@param on_fail function
function D.require(path, on_success, on_fail)
  local ok, lib = pcall(require, path)
  if ok then
    pcall(on_success, lib)
  else
    vim.notify("Failed to require library: " .. path, vim.log.levels.ERROR, { title = "Danielo" })
    pcall(on_fail)
  end
end
-- Yes, a function that does nothing, deal with it
D.noop = function() end
-- Shortcut
_G.preq = D.require
