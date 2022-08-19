local M = {}

function M.ensureTable(val)
  if vim.tbl_islist(val) then
    return val
  end
  return { val }
end

return M
