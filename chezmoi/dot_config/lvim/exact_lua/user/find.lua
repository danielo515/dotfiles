local M = {}
local fzf = require "fzf-lua"
function M.fzf_find()
  local context_completion = D.get_context_suggestions()
  D.vim.input(function(search_term)
    fzf.grep { search = search_term, multiprocess = true }
  end, context_completion)
end
return M
