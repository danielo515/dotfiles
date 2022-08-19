-- credit: https://github.com/LinArcX
local themes = require "telescope.themes"

function themes.vscode(opts)
  opts = opts or {}
  local theme_opts = {
    theme = "dropdown",
    results_title = false,
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      anchor = "N",
      prompt_position = "top",
      width = function(_, max_columns, _)
        return math.min(max_columns, 120)
      end,
      height = function(_, _, max_lines)
        return math.min(max_lines, 15)
      end,
    },
  }
  if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
    theme_opts.borderchars = {
      prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      results = { "─", "│", "─", "│", "╭", "╮", "┤", "├" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    }
  end
  return vim.tbl_deep_extend("force", theme_opts, opts)
end
