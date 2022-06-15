--
local NuiText = require("nui.text")
local function ensureTable(val)
  if vim.tbl_islist(val) then
    return val
  end
  return { val }
end

local padding = 1

---comment
---@param mappings { switch_key : string|string[], exit_key : string }
---@param bufnr number
function renderHelp(mappings, bufnr)
  local switch_keys = vim.fn.join(ensureTable(mappings.switch_key), ',')
  local switch_keys_text = NuiText(switch_keys, "Error")
  local switch_desc = NuiText(' Jump to next input')
  local row, col = 1, 0
  switch_keys_text:render(bufnr, -1, row, col, row, col)
  col = col + switch_keys_text:length() + padding
  switch_desc:render(bufnr, -1, row, col, row, col)
end

local m = { switch_key = '<Tab>', exit_key = 'q' }

renderHelp(m, 0)

return renderHelp
