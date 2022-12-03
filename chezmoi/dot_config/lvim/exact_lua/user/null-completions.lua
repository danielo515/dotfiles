local null_ls = require "null-ls"

local open_lets = {
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "reason" },
  name = "open-lets",
  generator = {
    fn = function(context)
      local letsOpen = "open Lets;"

      local current_line_content = context.content[context.row]
      local contains_lets_binding = current_line_content:match "let%.(%w+)"

      local first_line = context.content[1]

      if first_line ~= letsOpen and contains_lets_binding then
        return {
          {
            title = "Open lets at the top",
            action = function()
              local lines = { letsOpen, "", first_line }

              vim.api.nvim_buf_set_lines(context.bufnr, 0, 1, false, lines)
            end,
          },
        }
      end
    end,
  },
}
local reason_react_helpers = {
  method = null_ls.methods.CODE_ACTION,
  filetypes = { "reason" },
  name = "reason-react-helpers",
  generator = {
    fn = function(context)
      local current_line_content = context.content[context.row]
      local before, className, classString, after = current_line_content:match '(.*)(className=)("[%w%s-:.]+")(.*)$'

      if classString == nil then
        return
      end

      if classString:len() > 50 then
        local row = context.row
        -- local filal_len = before:len() + className:len() + classString:len()
        return {
          {
            title = "split long classname",
            action = function()
              local lines = { before .. className .. ("{%s}"):format(classString) .. after }

              vim.api.nvim_buf_set_lines(context.bufnr, row - 1, row, false, lines)
            end,
          },
        }
      end
    end,
  },
}

null_ls.register { reason_react_helpers, open_lets }
