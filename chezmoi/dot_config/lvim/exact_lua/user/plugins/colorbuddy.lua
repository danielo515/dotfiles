--[[ 
  We use colorbuddy to easily tune up the neovim interface colors
  independenlty from the theme
--]]

local function setup()
  local Color, colors, Group, groups, styles = require("colorbuddy").setup()
  Group.new("WinSeparator", colors.red)
  print "Colors are supposed to be customized now"
end

D.autocmd({ "ColorScheme" }, "Danielo-colorscheme", {
  pattern = "*",
  desc = "Config using colorbuddy",
  callback = setup,
})

return { "tjdevries/colorbuddy.nvim" }
