local M = {}

---Concatenate several list like tables
---@generic T
---@param ... T
---@return T[]
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

--@alias Cb
--@generic T
--@generic D
--@param x:T
--@return D

--- Executes a function in a protected call. Returns the default value if it fails
---@generic T,D
---@param fn fun(arg:T):D the function to call
---@param default D
---@param ... any the rest of the args
---@return T|D
function M.try_or_default(fn, default, ...)
  local ok, result = pcall(fn, ...)
  if ok then
    return result
  end
  return default
end

---Assigns the properties of one object to another object
---@generic T
---@generic O { [string]: T }
---@param target table
---@param source O
---@return O
function M.assign(target, source)
  for key, value in pairs(source) do
    target[key] = value
  end
  return target
end

---Calls a value if it is a function within a protected call
---@generic T
---@param fn fun(...:any):T
---@param ... any arguments the function may need
function M.call(fn, ...)
  local args = { ... }
  if type(fn) == "function" then
    return pcall(fn, unpack(args))
  end
end

return M
