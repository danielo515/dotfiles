local log = require "lvim.core.log"
local Job = require "plenary.job"
local has_chezmoi = vim.fn.executable "chezmoi" == 1
local M = { has_chezmoi = has_chezmoi }

function M.executeChezmoi(args)
  local result, _ = Job:new({
    command = "chezmoi",
    args = args,
    -- Do not set env prop or it will  fail
    on_exit = function(_, return_val)
      if return_val ~= 0 then
        print("Chezmoi command failed to execute: " .. table.concat(args, " "))
        return
      end
    end,
  }):sync()
  return result
end

function M.get_chezmoi_dir()
  local results = M.executeChezmoi { "source-path" }
  local path = results[1]
  log:debug("Using " .. path .. " as chezmoi path", { title = "Danielo" })
  return path
end

function M.re_add(path)
  local result, _ = Job:new({
    command = "chezmoi",
    args = { "managed", "-i", "files", path },
    -- Do not set env prop or it will  fail
    on_exit = function(_, return_val)
      if return_val ~= 0 then
        print "Chezmoi command failed to execute"
        return
      end
    end,
  }):sync()
  local isIncluded = #result > 0
  -- vim.pretty_print("file under control normal: ", isIncluded)
  -- vim.pretty_print(result, #result, isIncluded)
  if not isIncluded then
    return
  end
  vim.ui.select({ "re-add", "ignore" }, { prompt = "Chezmo managed file edited:" .. path }, function(choice)
    local saidYes = choice == "re-add"
    if saidYes then
      local res, code = Job:new({ command = "chezmoi", args = { "add", "-f", path } }):sync()
      -- vim.pretty_print("result", res, "code", code, result)
    end
  end)
end

_G.re_add = M.re_add
_G.executeChezmoi = M.executeChezmoi

return M
