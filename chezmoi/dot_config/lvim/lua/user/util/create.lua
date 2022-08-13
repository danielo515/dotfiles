local M = {}

function M.create_sibling_file()
  local path = vim.fn.expand "%:p:h"
  local filename = vim.fn.inputdialog("New file name> ", "")
  vim.cmd("e: " .. path .. "/" .. filename)
end

return M
