--- String helper methods that, for some reason, are not
--part of the standard library nor are present in plenary

local M = {}

---@alias string_tuple { _0: string, _1: string  }

---Split a string at the given character starting at nth
---@param str string
---@param nth number
---@param char? string
---@return string_tuple
function M.split_at_nth(str, nth, char)
  local char = char or " "
  local start = str:find(char, nth)
  local left = str:sub(0, start)
  local right = str:sub(start)
  return { left, right }
end

return M
