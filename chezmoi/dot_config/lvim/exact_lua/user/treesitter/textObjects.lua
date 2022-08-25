local keymap = require "user.util.keymap"
local M = {}

M.config = {

  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",

        ["ia"] = "@parameter.inner", -- "ap" is already used
        ["aa"] = "@parameter.outer", -- "ip" is already used
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["iv"] = "@variable",
        ["av"] = "@variable",
      },
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["gnp"] = "@parameter.inner",
        ["gnf"] = "@function.outer",
        ["gnv"] = "@variable",
        -- ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        -- ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[p"] = "@parameter.inner",
        ["[f"] = "@function.outer",
        -- ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        -- ["[]"] = "@class.outer",
      },
    },
  },
}

--- Creates a new function that will try to jump to the next start of query, and
--- if it does not find any, will try to jump to the previous
---@param query string the name of the capture group of the tree-sitter query you want to jump to
local function smart_start(query)
  return function()
    -- Sadly this are not available at startup time, so we need to require them at runtime
    local tso = require "nvim-treesitter.textobjects.move"
    local next = tso.goto_next_start
    local prev = tso.goto_previous_start
    local curRow = unpack(vim.api.nvim_win_get_cursor(0))
    next(query)
    local newRow = unpack(vim.api.nvim_win_get_cursor(0))
    if curRow == newRow then
      print "No movement, trying backwards"
      prev(query)
    end
  end
end

keymap.nmap(",f", smart_start "@function.inner", "Go to next function body")

-- treesitter
M.plugin = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = "BufRead",
}

return M
