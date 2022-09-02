local util = require "semgrep.util"
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

---@return ResultCb
local function show_in_telescope()
  ---@param results SemgrepResult[]
  return function(results)
    util.notify("Sorry, not yet implemented", "WARN")
  end
end

return {
  show_in_qflist = show_in_qflist,
  show_in_telescope = show_in_telescope,
}
