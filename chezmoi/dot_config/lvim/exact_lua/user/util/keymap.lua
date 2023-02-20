--- Creates a key bind in normal mode
---@param lhs string The key to assign
---@param rhs string | function the action to execute
---@param desc string the keymap human readabble description
---@param silent? boolean say if the mapping should be silent or not. Defaults to being silent
local function nmap(lhs, rhs, desc, silent)
  silent = silent == nil and true or false
  vim.keymap.set("n", lhs, rhs, { silent = silent, noremap = true, desc = desc })
end

--- Creates a key bind in insert mode and select mode
---@param lhs string The key to assign
---@param rhs string | function the action to execute
---@param desc string the keymap human readabble description
local function imap(lhs, rhs, desc)
  vim.keymap.set({ "i", "s" }, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

--- Creates a key bind in visual mode exclusively (not select to avoid problems with snippet engines)
---@param lhs string The key to assign
---@param rhs string | function the action to execute
---@param desc string the keymap human readabble description
---@param silent? boolean say if the mapping should be silent or not. Defaults to being silent
local function vmap(lhs, rhs, desc, silent)
  silent = silent == nil and true or false
  vim.keymap.set("x", lhs, rhs, { silent = silent, noremap = true, desc = desc })
end

return {
  nmap = nmap,
  imap = imap,
  vmap = vmap,
}
