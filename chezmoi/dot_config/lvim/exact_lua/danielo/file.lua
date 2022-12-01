local M = {}

function M.filename_without_extension()
  return vim.fn.expand "%:t:r"
end

function M.full_path_without_extension()
  return vim.fn.expand "%:p:r"
end

return M
