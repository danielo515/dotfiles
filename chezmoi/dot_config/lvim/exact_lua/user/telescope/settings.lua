local plugins = {
  {
    "nvim-telescope/telescope-frecency.nvim",
    requires = { "tami5/sqlite.lua" },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
  },
  { "kdheepak/lazygit.nvim" },
  { "nvim-telescope/telescope-packer.nvim" },
  "nvim-telescope/telescope-live-grep-args.nvim",
  "LinArcX/telescope-env.nvim",
  "nvim-telescope/telescope-symbols.nvim",
}

lvim.builtin.telescope.path_display = "truncate"

lvim.builtin.telescope.on_config_done = function(tele)
  -- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
  local _, actions = pcall(require, "telescope.actions")
  local state = require "telescope.actions.state"
  tele.load_extension "frecency"
  -- tele.load_extension("command_palette")
  -- tele.load_extension "notify"
  tele.load_extension "file_browser"
  tele.load_extension "lazygit"
  tele.load_extension "packer"
  tele.load_extension "luasnip"
  tele.load_extension "live_grep_args"
  tele.load_extension "env"
  local opts = {
    -- Default mappings are handled below
    pickers = {
      highlights = {
        mappings = {
          i = {
            ["<cr>"] = function(prompt_bufnr)
              local selection = state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.api.nvim_paste(selection.value, false, -1)
            end,
          },
        },
      },
      lsp_workspace_symbols = {
        mappings = {
          i = {
            ["<cr>"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              print(vim.inspect(selection))
            end,
          },
        },
      },
      buffers = {
        sort_lastused = true,
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer,
          },
        },
      },
      live_grep = {
        mappings = {
          i = {
            ["<c-f>"] = actions.to_fuzzy_refine,
          },
        },
      },
    },
    -- extensions = {
    -- 	frecency = {
    -- 		auto_validate = false,
    -- 		default_workspace = "CWD",
    -- 		show_unindexed = true,
    -- 		show_scores = true,
    -- 	},
    -- },
  }

  tele.setup(opts)
end

local user_telescope = require "user.telescope"

-- Change Telescope navigation
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-r>"] = actions.cycle_history_prev,
    ["<cr>"] = user_telescope.multi_selection_open,
    ["<c-v>"] = user_telescope.multi_selection_open_vsplit,
    ["<c-s>"] = user_telescope.multi_selection_open_split,
    ["<c-t>"] = user_telescope.multi_selection_open_tab,
    ["<C-X>"] = actions.delete_buffer,
    ["<c-h>"] = "which_key",
  },
  -- for normal mode
  n = {
    ["j"] = actions.move_selection_next,
    ["k"] = actions.move_selection_previous,
    ["q"] = actions.smart_send_to_qflist + actions.open_qflist,
    ["Q"] = actions.smart_add_to_qflist + actions.open_qflist,
    ["x"] = actions.delete_buffer,
    ["<C-r>"] = user_telescope.refine_search,
    ["<cr>"] = user_telescope.multi_selection_open,
    ["<c-v>"] = user_telescope.multi_selection_open_vsplit,
    ["<c-s>"] = user_telescope.multi_selection_open_split,
    ["<c-t>"] = user_telescope.multi_selection_open_tab,
  },
}

lvim.builtin.telescope.extensions.frecency = {
  auto_validate = false,
  default_workspace = "CWD",
  show_unindexed = false,
  show_scores = true,
}
return plugins
