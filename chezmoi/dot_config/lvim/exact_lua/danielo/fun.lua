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

---Shallow merge any number of objects into a new one
--which is then returned
----@generic T
----@param ... { [string]: T }
----@return { [string]: T }
function M.assign(...)
  local sources = { ... }
  local result = {}
  for _, source in ipairs(sources) do
    for key, value in pairs(source) do
      result[key] = value
    end
  end
  return result
end

----Typed version of assign for just two
----@generic A,B
----@param  a A
----@param b B
----@return A|B
function M.assign2(a, b)
  M.assign(a, b)
end

---Calls a value if it is a function within a protected call
---@generic T
---@param fn fun(...:any):T
---@param ... any arguments the function may need
---@return boolean,T|nil
function M.call(fn, ...)
  local args = { ... }
  if type(fn) == "function" then
    local ok, res = pcall(fn, unpack(args))
    return ok, res
  end
  return false, nil
end

---Creates a constant function that always returns the provided value
---@generic T
---@param k T
---@return fun():T
function M.const(k)
  return function()
    return k
  end
end

---Map over a list of values and transform each one using fn
---@generic T
---@generic K
---@param fn fun(arg:T):K the function to transform the values
---@param tbl T[] the table to transform its values
---@return K[]
M.map = function(fn, tbl)
  return vim.tbl_map(fn, tbl)
end

return M
