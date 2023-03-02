local job = require "plenary.job"
local M = {}

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250

local function add_node_bin()
  ---@diagnostic disable-next-line: missing-parameter
  local binPath = vim.fn.glob "./node_modules/.bin"
  if binPath ~= "" then
    vim.env.PATH = vim.env.PATH .. ":" .. binPath
    -- print(fullPath)
  end
end

function M.config()
  local chezmoi = require "user.util.chezmoi"
  local codelens_viewer = "lua require('nvim-lightbulb').update_lightbulb()"
  local autocommands = {
    -- Apply chezmoi whenever a dotfile is updated
    {
      "BufWritePost",
      chezmoi.get_chezmoi_dir() .. "/*",
      "execute '!chezmoi apply -v --refresh-externals=false --source-path %' | LvimReload ",
    },
    {
      "BufWritePost",
      "*.hx",
      function()
        local path = vim.fn.expand "%:p:h"
        local cwd = vim.fn.fnamemodify(path, ":h")
        local result = job
          :new({
            command = "haxe",
            args = { "build.hxml" },
            cwd = cwd,
          })
          :sync(2000)
        vim.pretty_print("build ran at " .. cwd, result)
      end,
    },
    -- Re add to chezmoi snippet files, because that is the only way to have live reload of snippets
    {
      "BufWritePost",
      "*/.config/lvim/*",
      function()
        local file = vim.fn.expand "%:p"
        chezmoi.re_add(file)
      end,
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
