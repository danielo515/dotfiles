local M = {}

function M.config()
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    {
      name = "eslint_d",
    },
    -- { name = "stylua" },
  }

  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup {
    { command = "eslint", filetypes = { "typescript", "typescriptreact" } },
  }
  local graphql_lsp_opts = {
    filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript" },
  }

  require("lvim.lsp.manager").setup("graphql", graphql_lsp_opts)
  require("lvim.lsp.manager").setup("jsonls", {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  })
end

return M
