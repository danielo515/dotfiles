local components = require "lvim.core.lualine.components"
local colors = require("user.theme").current_colors()
local gps_ok, gps = pcall(require, "nvim-navic")

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

if gps_ok then
  lvim.lsp.on_attach_callback = function(client, buf)
    local disallowed_servers = { "html", "cssls", "ionide", "fsautocomplete" }
    if client.server_capabilities.documentSymbolProvider and not vim.tbl_contains(disallowed_servers, client.name) then
      gps.attach(client, buf)
    end
  end
end

local nvim_gps = function()
  if not gps_ok then
    return "no gps"
  end
  local gps_location = gps.get_location()
  if gps_location == "error" then
    return "gps error"
  else
    if gps_location == "" then
      return "gps --"
    else
      return gps_location
    end
  end
end

local windows = {
  "windows",
  show_filename_only = true, -- Shows shortened relative path when set to false.
  show_modified_status = true, -- Shows indicator when the window is modified.

  mode = 0, -- 0: Shows window name
  -- 1: Shows window index
  -- 2: Shows window name + window index

  -- max_length = vim.o.columns * 2 / 3, -- Maximum width of windows component,
  -- it can also be a function that returns
  -- the value of `max_length` dynamically.
  filetype_names = {
    TelescopePrompt = "Telescope",
    dashboard = "Dashboard",
    packer = "Packer",
    fzf = "FZF",
    alpha = "Alpha",
  }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )

  disabled_buftypes = { "quickfix", "NvimTree" }, -- Hide a window if its buffer's type is disabled

  windows_color = {
    -- Same values as the general color option can be used here.
    active = "lualine_{section}_normal", -- Color for active window.
    inactive = "lualine_{section}_inactive", -- Color for inactive window.
  },
}

lvim.builtin.lualine.options = {
  theme = "auto", -- lualine theme
  component_separators = { left = "", right = "" },
  section_separators = { left = "", right = "" },
  disabled_filetypes = {}, -- Filetypes to disable lualine for.
  always_divide_middle = false, -- When set to true, left sections i.e. 'a','b' and 'c'
  -- can't take over the entire statusline even
  -- if neither of 'x', 'y' or 'z' are present.
  globalstatus = vim.opt.laststatus:get() == 3, -- enable global statusline (have a single statusline
  -- at bottom of neovim instead of one for  every window).
  -- This feature is only available in neovim 0.7 and higher.
}

lvim.builtin.lualine.sections.lualine_a = {
  {
    "filename",
    file_status = true, -- Displays file status (readonly status, modified status)
    path = 1, -- 0: Just the filename
    -- 1: Relative path
    -- 2: Absolute path

    shorting_target = 60, -- Shortens path to leave 60 spaces in the window
    symbols = {
      modified = "[+]", -- Text to show when the file is modified.
      readonly = "[!]", -- Text to show when the file is non-modifiable or readonly.
      unnamed = "[No Name]", -- Text to show for unnamed buffers.
    },
  },
}

lvim.builtin.lualine.sections.lualine_b = {
  components.branch, --[[ "windows" ]]
}
lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.lsp,
  components.diagnostics,
  components.treesitter,
  { nvim_gps, cond = hide_in_width },
}
lvim.builtin.lualine.sections.lualine_x = {
  components.filetype,
}
lvim.builtin.lualine.sections.lualine_y = { "tabs", "location" }
