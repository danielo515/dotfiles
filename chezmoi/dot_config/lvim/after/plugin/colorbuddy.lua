-- grabed from lua/user/colorbuddy make sure to remove it from there if this works
local function setup()
  local Color, colors, Group, groups, styles = require('colorbuddy').setup()
  Group.new('WinSeparator', colors.red)
  print "Colors are supposed to be customized now"
end

vim.schedule_wrap(function()
  local OK = pcall(setup)
  if not OK then
    vim.notify("Failed to setup colorbuddy", vim.log.levels.ERROR)
  end
end)
