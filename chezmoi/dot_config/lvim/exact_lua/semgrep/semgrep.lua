local async = require "plenary.async"
local Job = require "plenary.job"
local util = require "semgrep.util"

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

---@alias SemgrepResult { path: string, extra: { lines: string }, start: { line: number, col: number }}
---@param auto_open boolean
---@return ResultCb
local function show_in_qflist(auto_open)
  ---@param results SemgrepResult[]
  return function(results)
    local qf_list = vim.tbl_map(function(
      e --[[@as SemgrepResult]]
    )
      return { filename = e.path, text = e.extra.lines, lnum = e.start.line, col = e.start.col }
    end, results)
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn.setqflist(qf_list, "r")
    if auto_open then
      vim.cmd "copen"
    end
  end
end

local function test()
  vim.cmd [[messages clear]]
  execute_semgrep("if not $X then $FUN(...)", show_in_qflist(true))
end

--- Interacitve method
---@param opts { show_method: fun(result:SemgrepResult[]):any } show method must be already configured, ready to be called
local function interactive(opts)
  vim.ui.input({}, function(user_input)
    if not user_input then
      util.notify("Got empty query, will not execute sempgrep", "WARN")
      return
    end
    execute_semgrep(user_input, opts.show_method)
  end)
end

return {
  test = test,
  show_in_qflist = show_in_qflist,
  execute_semgrep = execute_semgrep,
  interactive = interactive,
}
