local S = require "semgrep.semgrep"
local util = require "semgrep.util"
local M = {}

---@alias ShowMethod 'quickfix' | 'telescope'
---@alias Opts { show_method: ShowMethod, auto_open: boolean }

---@type Opts
local default_options = {
  show_method = "quickfix",
  auto_open = true,
}

---@type { [ShowMethod]: function }
local show_methods = {
  quickfix = S.show_in_qflist,
  telescope = function()
    return function()
      util.notify("Not yet implemented", "INFO")
    end
  end,
}

--- Main search method. Opens the UI and asks for user input
---@param opts Opts execution options
function M.search(opts)
  local o = util.defaults(default_options, opts)
  local show_method = show_methods[o.show_method]
  S.interactive { show_method = show_method(o.auto_open) }
end

util.register_commands { { "SemgrepSearch", M.search, { "quickfix", "telescope" }, 1, "Opens semgrep search-ui" } }

return M
