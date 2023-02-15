local builtin_ok, builtin = pcall(require, "telescope.builtin")
local themes_ok, themes = pcall(require, "telescope.themes")
local log = require "lvim.core.log"
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local dotfiles = require "user.util.dotfiles"

if not themes_ok then
  log:warn "Could not load telescope themes"
end

if not builtin_ok then
  log:warn "Could not load telescope builtin"
end

local M = {}

M.dotfiles = function()
  builtin.find_files { cwd = dotfiles.path }
end

M.find_siblings = function()
  local opts = themes.get_dropdown { cwd = vim.fn.expandcmd "%:h", prompt_title = "Sibling files" }
  builtin.find_files(opts)
end

M.find_on_parent = function()
  builtin.find_files(themes.get_dropdown { cwd = vim.fn.expandcmd "%:h:h", prompt_title = "Parent files" })
end

---Dummy function to be able to offer auto-complete from lua.
-- It takes an argument, and returns a function that will return that argument.
-- This allows you to parametrize the lua function that vim will call
function M.expand(text)
  return function()
    return text
  end
end

local function path_and_text_entry_maker(entry)
  vim.pretty_print(entry)
  return entry
end

-- utility function for the <C-f> find key
function M.grep_files(opts)
  opts = opts or {}
  local cwd = vim.fn.getcwd()
  local theme_opts = themes.get_ivy {
    sorting_strategy = "ascending",
    layout_strategy = "bottom_pane",
    prompt_prefix = ">> ",
    prompt_title = "~ Grep " .. cwd .. " ~",
    search_dirs = { cwd },
    -- entry_maker = path_and_text_entry_maker,
    path_display = { "truncate" },
  }

  opts = vim.tbl_deep_extend("force", theme_opts, opts)
  local context_completion = D.get_context_suggestions()
  vim.ui.input({
    --This has several limitations. We need to pass a single argument because trying to provide several
    -- is going to make the string become invalid.
    --also need to escape the line feed or the provided string will be invalid.
    completion = string.format(
      "custom,v:lua.require'user.telescope.finders'.expand('%s')",
      --custom can have several options, but they must be newline separated
      table.concat(context_completion, "\\n")
    ),
  }, function(text)
    if not text or text == "" then
      return
    end
    builtin.grep_string(vim.tbl_extend("force", opts, { search = text }))
  end)
end

function M.grep_open_files(opts)
  opts = opts or {}
  builtin.live_grep(vim.tbl_extend("force", opts, { grep_open_files = true, disable_coordinates = true }))
end

function M.grep_parent_directory(opts)
  opts = opts or {}
  ---@diagnostic disable-next-line: missing-parameter
  builtin.live_grep(vim.tbl_extend("force", opts, { cwd = vim.fn.expand "%:h:p" }))
end

-- show code actions in a fancy floating window
function M.code_actions()
  local opts = {
    layout_config = {
      prompt_position = "top",
      width = 80,
      height = 12,
    },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    previewer = false,
    shorten_path = false,
  }
  builtin.lsp_code_actions(themes.get_dropdown(opts))
end

function M.buffers()
  require("telescope.builtin").buffers(require("telescope.themes").vscode {
    layout_config = {
      height = 50,
    },
    sort_last_used = true,
    sort_mru = true,
  })
end

-- Open whatever you have selected
function M._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()
  local border_contents = picker.prompt_border.contents[1]
  -- TODO: better logic to determine if should kick in or not
  if not (string.find(border_contents, "Find Files") or string.find(border_contents, "Git Files")) then
    actions.select_default(prompt_bufnr)
    return
  end
  if num_selections > 1 then
    vim.cmd "bw!"
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", open_cmd, entry.value))
    end
    vim.cmd "stopinsert"
  else
    if open_cmd == "vsplit" then
      actions.file_vsplit(prompt_bufnr)
    elseif open_cmd == "split" then
      actions.file_split(prompt_bufnr)
    elseif open_cmd == "tabe" then
      actions.file_tab(prompt_bufnr)
    else
      actions.file_edit(prompt_bufnr)
    end
  end
end

function M.multi_selection_open_vsplit(prompt_bufnr)
  M._multiopen(prompt_bufnr, "vsplit")
end

function M.multi_selection_open_split(prompt_bufnr)
  M._multiopen(prompt_bufnr, "split")
end

function M.multi_selection_open_tab(prompt_bufnr)
  M._multiopen(prompt_bufnr, "tabe")
end

function M.multi_selection_open(prompt_bufnr)
  M._multiopen(prompt_bufnr, "edit")
end

local action_utils = require "telescope.actions.utils"
local from_entry = require "telescope.from_entry"

---When you are on a telescope search prompt, this action will get all the results that
-- are visible and will open a new telescope prompt with only those search results,
-- so you can refine the search
---@param propmpt_bufnr number
function M.refine_search(propmpt_bufnr)
  local picker = action_state.get_current_picker(propmpt_bufnr)
  local files = vim.tbl_map(function(item)
    return item.filename
  end, picker:get_multi_selection())
  if #files == 0 then
    action_utils.map_entries(propmpt_bufnr, function(entry, idx, row)
      vim.pretty_print("entry", from_entry.path(entry), row)
      table.insert(files, from_entry.path(entry))
    end)
  end

  -- vim.pretty_print("Files", files)
  builtin.live_grep {
    search_dirs = files,
  }
end

return M
