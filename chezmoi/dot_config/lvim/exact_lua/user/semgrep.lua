local async = require "plenary.async"
local a = async
local Job = require "plenary.job"
-- semgrep  --pattern 'local $X = require($W)' --lang 'lua' chezmoi/dot_config/lvim/
local pattern = "local $X = require($W)"
local lang = "lua"
local plugin_name = "Semgrep"

--- Helper to show a notification to user
---@param msg string the message to send
---@param level 'ERROR'|'WARN'|'INFO'
local function notify(msg, level)
  vim.notify(msg, vim.log.levels[level], { title = plugin_name })
end

local function safe_parse(json_str)
  local ok, val = pcall(vim.fn.json_decode, json_str)
  if ok then
    return val
  end
  return nil
end

--- Execute semgrep with the given pattern and call CB with results
---@param pattern string
---@param cb function callback that will receive semgrep results
local function execute_semgrep(pattern, cb)
  local filetype = vim.bo.filetype
  Job
    :new({
      command = "semgrep",
      args = { "--pattern", pattern, "--quiet", "--json", "--lang", filetype, vim.fn.getcwd() },
      -- cwd = vim.fn.getcwd(),
      on_exit = function(j, return_val)
        if return_val ~= 0 then
          notify("Failed to call semgrep", "ERROR")
          return
        end
        local raw_res = j:result()
        vim.schedule(function()
          local parsed = safe_parse(raw_res)
          if parsed == nil then
            notify("Failed to parse semgrep result", "ERROR")
            return
          end
          if type(parsed) ~= "table" then
            notify("Got unexpected result when parsing semgrep" .. vim.inspect(parsed), "ERROR")
            return
          end
          if vim.tbl_isempty(parsed.results) then
            notify("Got empty list of results. Consider adding '...' to your query for broader results", "WARN")
            vim.pretty_print(parsed)
            return
          end
          cb(parsed.results)
        end)
      end,
    })
    :start()
end

local function show_in_qflist(results, auto_open)
  local qf_list = vim.tbl_map(function(e)
    return { filename = e.path, text = e.extra.lines, lnum = e.start.line, col = e.start.col }
  end, results)
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.setqflist(qf_list, "r")
end

local function test()
  vim.cmd [[messages clear]]
  execute_semgrep("if not $X then $FUN(...)", show_in_qflist)
end

local function interactive(opts)
  local o = vim.tbl_deep_extend("keep", opts or {}, {
    show_results = show_in_qflist,
    auto_open = true,
  })
  vim.ui.input({}, function(user_input)
    if not user_input then
      notify("Got empty query, will not execute sempgrep", "WARN")
      return
    end
    execute_semgrep(user_input, o.show_results)
  end)
end

interactive()

return {
  show_in_qflist = show_in_qflist,
  execute_semgrep = execute_semgrep,
}
