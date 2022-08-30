--- Creates a key bind in normal mode
---@param lhs string The key to assign
---@param rhs string | function the action to execute
---@param desc string the keymap human readabble description
local function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, noremap = true, desc = desc })
end

--- Creates a key bind in insert mode and select mode
---@param lhs string The key to assign
---@param rhs string | function the action to execute
---@param desc string the keymap human readabble description
local function imap(lhs, rhs, desc)
  vim.keymap.set({ "i", "s" }, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

return {
  nmap = nmap,
  imap = imap,
}
