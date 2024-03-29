local components = require "lvim.core.lualine.components"
local colors = require("user.theme").current_colors()
local gps_ok, gps = pcall(require, "nvim-navic")

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end
local is_git_workspace = function()
  local filepath = vim.fn.expand "%:p:h"
  local gitdir = vim.fn.finddir(".git", filepath .. ";")
  return gitdir and #gitdir > 0 and #gitdir < #filepath
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

lvim.builtin.lualine.options = {
  theme = "auto", -- lualine theme
  icons_enabled = true,
  component_separators = { left = "", right = "" },
  section_separators = { left = "", right = "" },
  disabled_filetypes = {
    "dashboard",
    "NvimTree",
    "Outline",
    "alpha",
    "vista",
    "vista_kind",
    "TelescopePrompt",
  }, -- Filetypes to disable lualine for.
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
  {
    "b:gitsigns_head",
    icon = " ",
    cond = is_git_workspace,
    color = { fg = "#7FB4CA" },
    padding = 0,
  },
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
