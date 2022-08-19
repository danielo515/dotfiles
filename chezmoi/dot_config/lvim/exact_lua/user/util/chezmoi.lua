local log = require "lvim.core.log"
local has_chezmoi = vim.fn.executable "chezmoi" == 1
local M = { has_chezmoi = has_chezmoi }

function M.get_chezmoi_dir()
  local results = vim.fn.execute "!chezmoi source-path"
  local results_split = vim.split(results, "\n", { trimempty = true })
  local path = results_split[3]
  log:debug("Using " .. path .. " as chezmoi path", { title = "Danielo" })
  return path
end

return M
