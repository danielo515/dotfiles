local M = {}

---@alias MapOptions { silent: boolean }

--- Creates a key bind in normal mode
-- The nice thing about this function is that it is returning a new
-- function for each argument, so you can call it without any  parens
-- if you are using just strings and tables
---@param description string the keymap human readabble description
function M.nmap(description)
  ---@param lhs string The key to assign
  return function(lhs)
    ---@param rhs string | function the action to execute
    return function(rhs)
      ---@param opts? MapOptions
      return function(opts)
        local o = opts or { silent = true }
        vim.keymap.set("n", lhs, rhs, { silent = o.silent, noremap = true, desc = description })
      end
    end
  end
end

return M
