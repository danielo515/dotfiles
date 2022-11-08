local M = {}

function M.create_sibling_file()
  local path = vim.fn.expand "%:p:h"
  local currentFileName = vim.fn.expand "%:t:r"
  D.vim.input(function(filename)
    vim.cmd("e " .. path .. "/" .. filename)
  end, { currentFileName })
end

return M
