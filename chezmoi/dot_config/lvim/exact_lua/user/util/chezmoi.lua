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

local Job = require "plenary.job"

function M.re_add(path)
  Job:new({
    command = "chezmoi",
    args = { "managed", "-i", "files", path },
    -- Do not set env prop or it will  fail
    on_exit = function(j, return_val)
      vim.pretty_print("file under control: ", return_val == 0)
      local result = j:result()
      local isIncluded = #result > 0
      vim.ui.select({ "yes", "no" }, { prompt = "Chezmo managed file edited. re-add it?" }, function(choice)
        local saidYes = choice == "yes"
        if saidYes then
          print(saidYes, result)
          vim.fn.execute("!chemzoi add -f " .. path)
        end
      end)
    end,
  }):sync()
end

_G.re_add = M.re_add

return M
