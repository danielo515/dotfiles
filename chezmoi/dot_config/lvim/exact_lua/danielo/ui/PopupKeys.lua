local Popup = require "nui.popup"
local PopupKeys = Popup:extend "ExtPopup"

---A modifier version of the popup that tracks the keymaps
--you add and removes them on unmouns
---@param options table
function PopupKeys:init(options)
  PopupKeys.super.init(self, options)
  -- set some values for better editor integration
  ---@type table<string,table<string,boolean>>
  self._keymap_tracker = {
    n = {},
    i = {},
  }
end

function PopupKeys:map(mode, key, handler, opts)
  if not self._keymap_tracker[mode] then
    self._keymap_tracker[mode] = {}
  end
  self._keymap_tracker[mode][key] = true

  PopupKeys.super.map(self, mode, key, handler, opts)
end

function PopupKeys:unmap(mode, key)
  local mapping = self._keymap_tracker[mode][key]
  if mapping ~= nil then
    -- Remove from the tracker in case anyone removes it manually
    self._keymap_tracker[mode] = nil
  end
  PopupKeys.super.unmap(self, mode, key)
end

function PopupKeys:unmount()
  -- unmap keymaps from self._keymap_tracker
  for mode, maps in pairs(self._keymap_tracker) do
    for keymap, _ in pairs(maps) do
      PopupKeys.super.unmap(self, mode, keymap)
    end
  end
  PopupKeys.super.unmount(self)
end

return PopupKeys
