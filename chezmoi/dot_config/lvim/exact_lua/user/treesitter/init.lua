local textObjects = require "user.treesitter.textObjects"
local textSubjects = require "user.treesitter.textSubjects"
local M = {}
--treesiter related plugins
M.plugins = {
  textObjects.plugin,
  textSubjects.plugin,
  -- Show current function at the top of the screen when function does not fit in screen
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            "class",
            "function",
            "method",
          },
        },
      }

      local set_ok = pcall(function()
        local colors = require("catppuccin.api.colors").get_colors() -- fetch colors with API
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = colors.surface1 })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = colors.overlay2, fg = colors.text })
      end)
      -- fallback
      if not set_ok then
        -- This will make more visible which lines are part of the context-area
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#545c7e" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#00ff10" })
      end
    end,
  },
  {
    "nvim-treesitter/playground",
  },
  -- I'm not interested in the refactors, only in the navigations
  "nvim-treesitter/nvim-treesitter-refactor",
  -- Highlight parens and that stuff using treesitter
  { "p00f/nvim-ts-rainbow" },
}

local refactor_config = {
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = false },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = ",r",
        goto_previous_usage = "gNr",
      },
    },
  },
}

local rainbow_config = {
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1500,
    colors = {
      "#f30f3f",
      "#ffa500",
      "#ffff00",
      "#018000",
      "#0af34f",
      "#cf4eea",
      "#ee82ee",
    },
  },
}
local playground_config = {
  playground = {
    enable = true,
    updatetime = 20,
    persist_queries = true,
  },
}

local settings = {
  highlight = { enable = true },
  indent = { enable = true },
  autotag = { enable = true },
  ignore_install = { "haskell", "php", "phpdoc" },
  ensure_installed = "all",
}
-- Setup the required configs for treesitter plugins
function M.config()
  -- if you don't want all the parsers change this to a table of the ones you want
  lvim.builtin.treesitter = vim.tbl_deep_extend(
    "force",
    lvim.builtin.treesitter,
    settings,
    playground_config,
    rainbow_config,
    textObjects.config,
    textSubjects.config,
    refactor_config
  )
end

return M
