local M = {}

local status_ok, nls = pcall(require, "null-ls")
if not status_ok then
  return
end

function M.config()
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    { name = "eslint_d" },
    { name = "stylua" },
  }

  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup {
    { command = "eslint", filetypes = { "typescript", "typescriptreact" } },
  }
  local graphql_lsp_opts = {
    filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript" },
  }
  local lspManager = require "lvim.lsp.manager"
  lspManager.setup("graphql", graphql_lsp_opts)
  lspManager.setup("jsonls", {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  })
  lspManager.setup("sumneko_lua", {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = get_runtime_dir(),
        },

        diagnostics = {
          globals = { "vim", "lvim", "packer_plugins", "fmt", "s", "i" },
        },
        completion = {
          autoRequire = true,
          displayContext = 50,
        },
      },
    },
  })
  local setup_code_actions = require("lvim.lsp.null-ls.code_actions").setup
  local refactorin_opts = nls.builtins.code_actions.refactoring.with {
    filetypes = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
  }
  setup_code_actions { refactorin_opts }
end

return M
