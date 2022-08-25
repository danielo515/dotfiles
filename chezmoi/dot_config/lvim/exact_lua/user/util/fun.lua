local M = {}

--@alias Cb
--@generic T any,D any
--@param x:T
--@return D

--- Executes a function in a protected call. Returns the default value if it fails
---@generic T,D
---@param fn function the function to call
---@param default D
---@param ... any the rest of the args
---@return `T`|`D`
function M.try_def(fn, default, ...)
  local ok, result = pcall(fn, ...)
  if ok then
    return result
  end
  return default
end
return M
