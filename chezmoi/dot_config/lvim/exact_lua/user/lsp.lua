local M = {}

lvim.lsp.null_ls.setup.debug = false -- activate this only when needed

local status_ok, nls = pcall(require, "null-ls")
if not status_ok then
  return
end

local function check_binary(binary_name)
  if vim.fn.executable(binary_name) == 1 then
    -- All good
    return
  end
  vim.notify("Missing required binary: " .. binary_name, vim.log.levels.ERROR)
end

lvim.lsp.automatic_configuration.skipped_filetypes = { "reason", "rescript", "markdown" }

function M.config()
  --#region null-ls
  -- https://www.lunarvim.org/languages/#linting-formatting

  check_binary "codespell"
  check_binary "eslint_d"
  check_binary "stylua"
  check_binary "hadolint"
  check_binary "fixjson"

  -- Just use the default null-ls config by referencing the formatters by name
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    { name = "eslint_d" },
    { name = "stylua" },
    { name = "fixjson" },
    -- { name = "codespell" }, -- too aggressive
  }

  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup {
    { command = "eslint_d", filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" } },
    { name = "codespell" },
    { name = "hadolint" },
  }

  local setup_code_actions = require("lvim.lsp.null-ls.code_actions").setup
  local refactorin_opts = nls.builtins.code_actions.refactoring.with {
    filetypes = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
  }
  setup_code_actions { refactorin_opts, nls.builtins.code_actions.gitsigns }
  --#endregion
  --#region LSP
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
  -- lspManager.setup "reason_ls"
  -- This may be the only thing you need to work with Tella rescript
  lspManager.setup("rescriptls", {
    cmd = {
      "node",
      "/Users/danielo/.config/coc/extensions/rescript-vscode-1.2.1/extension/server/out/server.js",
      "--stdio",
    },
    filetypes = { "reason", "rescript" },
  })
  --#endregion
end

return M
