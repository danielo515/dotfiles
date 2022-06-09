local M = {}

local util = require "user.util"

M.config = function()
  local status_ok, command_center = pcall(require, "command_center")
  if not status_ok then
    vim.notify("Command center not loaded", "warn")
    return
  end
  -- local noremap = { noremap = true }
  -- local silent_noremap = { noremap = true, silent = true }
  command_center.add({
    { description = "Search within the project (Live grep)", cmd = ":Telescope live_grep<cr>" },
    { description = "Live grep", cmd = ":Telescope live_grep_args<cr>" },
    { description = "Search and replace", cmd = ":lua require('spectre').open()<cr>" },
    { description = "Select entire text", cmd = ':call feedkeys("GVgg")<cr>' },
    { description = "Show file browser", cmd = ":Telescope file_browser<cr>" },
    { description = "Find files", cmd = ":lua require('telescope.builtin').find_files()<cr>" },
    { description = "Find hidden files", cmd = ":Telescope find_files hidden=true<cr>" },
    { description = "Find Git files", cmd = ":lua require('lvim.core.telescope').find_project_files()<cr>" },
    { description = "Show recent files", cmd = ":Telescope oldfiles<cr>" },
    { description = "Rerun last search", cmd = ":lua require('telescope.builtin').resume({cache_index=3})<cr>" },
    { description = "Search inside current buffer", cmd = ":Telescope current_buffer_fuzzy_find<cr>" },
    {
      description = "Search/grep inside open buffers",
      cmd = require("user.telescope.finders").grep_open_files,
    },
    {
      description = "Send harpoon command",
      cmd = function()
        vim.ui.input({ prompt = " Command to execute" }, function(user_input)
          require("harpoon.term").sendCommand(1, user_input .. "\n")
        end)
      end,
    },
    { description = "Quit", cmd = ":qa<cr>" },
    { description = "Save all files", cmd = ":wa<cr>" },
    { description = "Save current file", cmd = ":w<cr>" },
    { description = "Copy :messages to the clipboard", cmd = util.copy_messages_to_clipboard },
    { description = "Search word", cmd = ":lua require('user.telescope').find_string()<cr>" },
    { description = "Format document", cmd = ":lua vim.lsp.buf.formatting_seq_sync()<cr>" },
    { description = "Workspace diagnostics", cmd = ":Telescope diagnostics<cr>" },
    { description = "Workspace symbols", cmd = ":Telescope lsp_workspace_symbols<cr>" },
    { description = "List projects", cmd = ":Telescope projects<cr>" },
    { description = "Build project", cmd = ":AsyncTask project-build<cr>" },
    { description = "Run project", cmd = ":AsyncTask project-run<cr>" },
    { description = "Show tasks", cmd = ":AsyncTaskList<cr>" },
    { description = "Show opened buffers", cmd = ":Telescope buffers<cr>" },
    { description = "Find man pages", cmd = ":Telescope man_pages<cr>" },
    { description = "Check health", cmd = ":checkhealth<cr>" },
    { description = "Switch colorschemes", cmd = ":Telescope colorscheme<cr>" },
    { description = "Command history", cmd = ":lua require('telescope.builtin').command_history()<cr>" },
    { description = "Show all available commands", cmd = ":Telescope commands<cr>" },
    {
      description = "Telescope builtin commands",
      cmd = "<cmd>Telescope builtin include_extensions=true<cr>",
    },

    {
      description = "Execute bash commands through telescope",
      cmd = "<cmd>Telescope bashed list<cr>",
    },
    { description = "Toggle cursor column", cmd = ":set cursorcolumn!<cr>" },
    { description = "Toggle cursor line", cmd = ":set cursorline!<cr>" },
    { description = "Show jumplist", cmd = ":Telescope jumplist<cr>" },
    { description = "Show workspace git commits", cmd = ":Telescope git_commits<cr>" },
    { description = "Show all key maps", cmd = ":Telescope keymaps<cr>" },
    { description = "Open buffers in a nice tree", cmd = "<cmd>Neotree float buffers<cr>" },
    { description = "Toggle paste mode", cmd = ":set paste!<cr>" },
    { description = "Show registers", cmd = ":lua require('telescope.builtin').registers()<cr>" },
    { description = "Toggle relative number", cmd = ":set relativenumber!<cr>" },
    { description = "Reload vimrc", cmd = ":source $MYVIMRC<cr>" },
    { description = "Toggle search highlighting", cmd = ":set hlsearch!<cr>" },
    { description = "Show search history", cmd = ":lua require('telescope.builtin').search_history()<cr>" },
    { description = "Toggle spell checker", cmd = ":set spell!<cr>" },
    { description = "Edit vim options", cmd = ":Telescope vim_options<cr>" },
    { description = "Show Cheatsheet", cmd = ":help index<cr>" },
    { description = "Quick reference", cmd = ":help quickref<cr>" },
    { description = "Find help documentations", cmd = ":lua require('telescope.builtin').help_tags()<cr>" },
    { description = "Help summary", cmd = ":help summary<cr>" },
    { description = "Help tips", cmd = ":help tips<cr>" },
    { description = "Help tutorial", cmd = ":help tutor<cr>" },
    { description = "Typescript import all", cmd = "TypescriptAddMissingImports" },
    -- TODO:
    -- Search in parent directory and or sibling directory
  }, command_center.mode.ADD_ONLY)
end

return M
