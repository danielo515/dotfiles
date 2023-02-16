local M = {}
local fzf = require "fzf-lua"
-- Shows a input window with some autocomplete suggestions
-- and then calls fzf grep (which uses rg and fzf) with the provided term
function M.fzf_find()
  local context_completion = D.get_context_suggestions()
  D.vim.input(function(search_term)
    fzf.grep { search = search_term, multiprocess = true }
  end, context_completion)
end
return M
