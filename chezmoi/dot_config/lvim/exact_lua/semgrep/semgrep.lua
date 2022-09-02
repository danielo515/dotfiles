local async = require "plenary.async"
local Job = require "plenary.job"
local util = require "semgrep.util"
local config = require "semgrep.config"
local saved_queries = config.saved_queries

---@alias ResultCb fun(result:SemgrepResult[]):any

--- Execute semgrep with the given pattern and call CB with results
---@param pattern string
---@param cb ResultCb callback that will receive semgrep results
local function execute_semgrep(pattern, cb)
  local filetype = vim.bo.filetype
  Job
    :new({
      command = "semgrep",
      args = { "--pattern", pattern, "--quiet", "--json", "--lang", filetype, vim.fn.getcwd() },
      -- cwd = vim.fn.getcwd(),
      on_exit = function(j, return_val)
        if return_val ~= 0 then
          util.notify("Failed to call semgrep", "ERROR")
          return
        end
        local raw_res = j:result()
        vim.schedule(function()
          local parsed = util.safe_parse(raw_res)
          if parsed == nil then
            util.notify("Failed to parse semgrep result", "ERROR")
            return
          end
          if type(parsed) ~= "table" then
            util.notify("Got unexpected result when parsing semgrep" .. vim.inspect(parsed), "ERROR")
            return
          end
          if vim.tbl_isempty(parsed.results) then
            util.notify("Got empty list of results. Consider adding '...' to your query for broader results", "WARN")
            vim.pretty_print(parsed)
            return
          end
          cb(parsed.results)
        end)
      end,
    })
    :start()
end

local function complete_user_input()
  vim.pretty_print(saved_queries)
  return saved_queries
end

--- Interacitve method
---@param opts { show_method: fun(result:SemgrepResult[]):any } show method must be already configured, ready to be called
local function interactive(opts)
  vim.ui.input({ completion = "customlist,v:lua.require'semgrep.semgrep'.complete_user_input" }, function(user_input)
    if not user_input then
      util.notify("Got empty query, will not execute sempgrep", "WARN")
      return
    end
    execute_semgrep(user_input, opts.show_method)
  end)
end

return {
  execute_semgrep = execute_semgrep,
  interactive = interactive,
  complete_user_input = complete_user_input,
}
