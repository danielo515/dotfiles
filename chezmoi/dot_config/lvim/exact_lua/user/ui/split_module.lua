local Layout = require "nui.layout"
local Popup = require "danielo.ui.PopupKeys"

local win_options = {
  -- winblend = 10,
  winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
}

local buf_options = {
  modifiable = true,
  readonly = false,
  buflisted = true,
}

---Map the common set of keys for each popup
---@param popups any[]
---@param layout any
local function mapKeys(layout, popups)
  -- because when all you have is two windows, who cares about direction?
  local maps = { "<c-h>", "<c-l>", "<Tab>" }

  for i, pop in ipairs(popups) do
    local next = popups[i + 1] or popups[i - 1] -- next or previous, who cares
    local function goto_alt()
      vim.api.nvim_set_current_win(next.winid)
    end
    --bind the navigation keymaps
    vim.tbl_map(function(key)
      pop:map("n", key, goto_alt)
    end, maps)

    --On exit, bindings are automatically removed by my extended popup
    pop:map("n", "<Esc>", function()
      layout:unmount()
    end)
  end
end

local NuiText = require "nui.text"

---Mounts a split window with the two buffers loaded into each side.
---@alias buffId number
---@param moduleName string
---@param buffers { implementation: buffId, interface: buffId } table with buffer ids
local function mount_window(moduleName, buffers)
  local p1 = Popup {
    enter = true,
    bufnr = buffers.implementation,
    win_options = win_options,
    buf_options = buf_options,
    border = {
      style = "double",
      text = {
        top = NuiText(moduleName .. ".re", "WhichKeyDesc"),
        bottom = "<Esc> close this window",
      },
    },
  }

  local p2 = Popup {
    win_options = win_options,
    buf_options = buf_options,
    bufnr = buffers.interface,
    border = {
      style = "rounded",
      text = {
        top = NuiText(moduleName .. ".rei", "String"),
      },
    },
  }

  local layout = Layout(
    { position = "50%", size = "90%", relative = "editor" },
    Layout.Box {
      Layout.Box({
        Layout.Box(p1, { size = "50%" }),
        Layout.Box(p2, { size = "50%" }),
      }, { size = "100%" }),
    }
  )

  layout:mount()
  -- Always map after mount
  mapKeys(layout, { p1, p2 })
end

---Given a module name, creates two different buffers pointing to
--the implementation and interface files
--The module name should not include extension
---@param moduleName string
---@return {interface: number, implementation: number}
local function make_buffers(moduleName)
  local implementation = vim.fn.bufadd(moduleName .. ".re")
  local interface = vim.fn.bufadd(moduleName .. ".rei")

  vim.fn.bufload(implementation)
  vim.fn.bufload(interface)

  return { interface = interface, implementation = implementation }
end

---Creates a new module (interface + implementation) and opens
--it in a split floating window
local function create_module()
  local current_file = vim.fn.expand "%:t:r"
  D.vim.input(function(name)
    local path = vim.fn.expand "%:p:h"
    local buffers = make_buffers(path .. "/" .. name)
    mount_window(name, buffers)
  end, { current_file })
end

---@generic T
---@param list T[]
---@param item T
local function reAddOnTop(list, item)
  local filtered = vim.tbl_filter(function(value)
    return item ~= value
  end, list)
  return vim.list_extend(filtered, { item }, 1)
end

---@type { list: string[], values: table<string,{name: string, path: string}>}
local opened_cache = { list = {}, values = {} }

local function addToCache(name, path)
  opened_cache.values[name] = { name = name, path = path }
  opened_cache.list = reAddOnTop(opened_cache.list, name)
end

local function open_mod(name, path)
  local buffers = make_buffers(path)
  addToCache(name, path)
  mount_window(name, buffers)
end
---Opens the current file as a module in a floating window
local function open_module()
  -- current file without extension
  local path = vim.fn.expand "%:p:r"
  local name = vim.fn.expand "%:r"
  open_mod(name, path)
end

local function re_open_module()
  local function re_open(choice)
    if not choice then
      return
    end
    local module = opened_cache.values[choice]
    if not module then
      return
    end
    open_mod(module.name, module.path)
  end
  if #opened_cache.list == 0 then
    vim.notify "There are no recent modules to open"
    return
  end
  vim.ui.select(opened_cache.list, {}, re_open)
end

local M = {
  create_module = create_module,
  open_module = open_module,
  re_open_module = re_open_module,
}

return M
