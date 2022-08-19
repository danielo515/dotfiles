--
local NuiText = require("nui.text")


---Render a single key -> description entry
---@param key string[]
---@param description string
---@param bufnr integer
---@return integer The length of the rendered text
local function renderKey(key, description, bufnr, column, row)
  local keyText = NuiText(' ' .. vim.fn.join(key, ','), 'WhichKeyDesc')
  local sep = NuiText(' → ', 'WhichKeySeparator')
  keyText:render(bufnr, -1, row, column, row, column)
  column = column + keyText:length()
  sep:render(bufnr, -1, row, column, row, column)
  column = column + sep:length()
  local descriptionText = NuiText(description)
  descriptionText:render(bufnr, -1, row, column, row, column)
  return keyText:length() + descriptionText:length() + sep:length()
end

---Renders help for the provided key mappings
---@param mappings Mappings
---@param bufnr number
local function renderHelp(mappings, bufnr)
  local mode = vim.fn.mode()
  mappings = vim.tbl_filter(function(mapping)
    return vim.tbl_contains(mapping.modes, mode)
  end, mappings)
  local col = 0
  for _, mapping in pairs(mappings) do
    local length = renderKey(mapping.keys, mapping.description, bufnr, col, 1)
    col = col + length
  end
end

return renderHelp
