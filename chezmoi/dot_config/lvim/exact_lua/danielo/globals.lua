-- Fuck it, I'm gonna drop some global utility functions for my personal use!!
_G.D = {} -- But namespaced, obviously!

---Prints whatever argument it gets, and then returns it.
--Useful to add in the middle of any pipeline without much trouble
---@generic T
---@param arg T
---@return T
function D.Peek(arg)
  vim.pretty_print(arg)
  return arg
end

---Make a require of a module in a protected call. If the call succeeds, then call the on_success
---Everything is executed within protected calls
---@param path string
---@param on_success function
---@param on_fail? function
function D.require(path, on_success, on_fail)
  local ok, lib = pcall(require, path)
  on_fail = on_fail or D.noop
  if ok then
    pcall(on_success, lib)
  else
    vim.notify("Failed to require library: " .. path, vim.log.levels.ERROR, { title = "Danielo" })
    pcall(on_fail)
  end
end

---Requires the configuration module in a protected call
-- and calls its setup or config function if it exists
---@param path string path to the module that needs to be configured
function D.pconf(path, ...)
  local args = { ... }
  D.require(path, function(module)
    local setup_fn = module.config or module.setup
    return D.call(setup_fn, unpack(args))
  end)
end

-- Yes, a function that does nothing, deal with it
D.noop = function() end
-- Shortcut
_G.preq = D.require
local fun = require "danielo.fun"
D = fun.assign(D, fun)
