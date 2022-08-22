local M = {}

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250

local function reloadSnippets()
  require("luasnip").cleanup() -- opts can be ommited
  require("luasnip.loaders.from_snipmate").load() -- opts can be ommited
  require("luasnip.loaders.from_vscode").load() -- opts can be ommited
end

local danieloSnip = vim.api.nvim_create_augroup("danielo-snip", {
  clear = true,
})

vim.api.nvim_create_autocmd({
  "BufWritePost",
}, {
  pattern = { "*.snippets" },
  callback = reloadSnippets,
  group = danieloSnip,
})

local function add_node_bin()
  ---@diagnostic disable-next-line: missing-parameter
  local binPath = vim.fn.glob "./node_modules/.bin"
  if binPath ~= "" then
    vim.env.PATH = vim.env.PATH .. ":" .. binPath
    -- print(fullPath)
  end
end

function M.config()
  local get_chezmoi_dir = require("user.util.chezmoi").get_chezmoi_dir
  local codelens_viewer = "lua require('nvim-lightbulb').update_lightbulb()"
  local autocommands = {
    -- Apply chezmoi whenever a dotfile is updated
    {
      "BufWritePost",
      get_chezmoi_dir() .. "/*",
      "execute '!chezmoi apply -v --source-path %' | LvimReload ",
    },
    { "CursorHold", "*.rs,*.go,*.ts,*.tsx,*.lua", codelens_viewer },

    -- dashboard
    { "FileType", "alpha", "nnoremap <silent> <buffer> q :q<CR>" },

    -- typescript
    { "Filetype", "typescript,typescriptreact", "nnoremap ga <Cmd>TypescriptAddMissingImports<CR>" },
    { "Filetype", "typescript,typescriptreact", "nnoremap gr <Cmd>TypescriptRenameFile<CR>" },
    { "Filetype", "typescript,typescriptreact", "nnoremap gS <Cmd>TypescriptOrganizeImports<CR>" },
    { "Filetype", "typescript,typescriptreact", "nnoremap gx <Cmd>TypescriptRemoveUnused<CR>" },
    { "BufWritePost", "typescript,typescriptreact", "TypescriptRemoveUnused" },
    -- { "Filetype", "typescript,typescriptreact", "nnoremap gx <Cmd>TypescriptFixAll<CR>" },

    -- Populate node_modules .bin
    { "VimEnter", "", add_node_bin, "Add the local node_modules to the vim PATH" },
    -- uncomment the following if you want to show diagnostics on hover
    { "CursorHold", "*", "lua vim.diagnostic.open_float()" },
  }
  local group = vim.api.nvim_create_augroup("Danielo", {})
  for _, command in ipairs(autocommands) do
    local name, pattern, cmd, desc = unpack(command)
    local options = { pattern = pattern, group = group, desc = desc }

    if type(cmd) == "string" then
      options.command = cmd
    else
      options.callback = cmd
    end

    vim.api.nvim_create_autocmd(name, options)
  end
end

return M
