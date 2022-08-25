--- Creates a key bind in normal mode
---@param lhs string The key to assign
---@param rhs string | function the action to execute
---@param desc string the keymap human readabble description
local function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, noremap = true, desc = desc })
end

return {
  nmap = nmap,
}
