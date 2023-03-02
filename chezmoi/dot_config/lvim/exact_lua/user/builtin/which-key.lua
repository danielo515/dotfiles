function Yank_file_name()
  local path = vim.fn.expand "%:."
  vim.fn.setreg("*", path)
  vim.notify(path .. " yanked to keyboard")
end

function Yank_full_file_name()
  local path = vim.fn.expand "%:p"
  vim.fn.setreg("*", path)
  vim.notify(path .. " yanked to keyboard")
end

lvim.builtin.which_key.setup.plugins.presets = {
  operators = true, -- adds help for operators like d, y, ...
  motions = true, -- adds help for motions
  text_objects = true, -- help for text objects triggered after entering an operator
  windows = true, -- default bindings on <c-w>
  nav = true, -- misc bindings to work with windows
  z = true, -- bindings for folds, spelling and others prefixed with z
  g = true, -- bindings for prefixed with g
}

lvim.builtin.which_key.setup.hidden =
  { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ ", "require'[^']*'." } -- hide mapping boilerplate

lvim.builtin.which_key.setup.triggers_blacklist.v = nil

lvim.builtin.which_key.mappings.q = nil

-- This config will be merged with the one that lvim has by default
local whichConfig = {
  ["<space>"] = { ":Telescope command_history<cr>", "Command history" },
  u = { ":Neotree float reveal<cr>", "Open floating file explorer" },
  c = { ":Legendary<cr>", "Legendary prompt" },
  -- extend search
  s = {
    d = { "<cmd>lua require('user.telescope').dotfiles()<cr>", "Search dotfiles" },
    q = { "<cmd>Telescope quickfix<cr>", "QuickFix" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    C = { "<cmd>Telescope command_history<cr>", "Commands history" },
    s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
    g = { "<cmd>Telescope live_grep_args<cr>", "Live grep with rg" },
    n = { "<cmd>Telescope notify<cr>", "Notifications" },
    j = { "<cmd>Telescope jumplist<cr>", "Jump list" },
    P = { "<cmd>Telescope packer<cr>", "Packer search" },
    o = { require("user.telescope.finders").grep_open_files, "Grep on open files" },
    ["."] = { "<cmd>Telescope resume<cr>", "Repeat search" },
    S = {
      "<cmd>lua require('spectre').open_visual({select_word=true})<CR>",
      "Spectre search",
    },
    [","] = {
      "<cmd>lua require('user.telescope').grep_parent_directory()<cr>",
      "Search files on parent folder",
    },
  },
  ["."] = {
    "<cmd>lua require('user.telescope').find_siblings()<cr>",
    "Search sibling files",
  },

  [","] = {
    "<cmd>lua require('user.telescope').find_on_parent()<cr>",
    "Search files on parent folder",
  },
  ["P"] = { "<cmd>Telescope projects<CR>", "Projects" },
  ["t"] = {
    name = "+Trouble",
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace diagnostics" },
  },
  -- extend git
  ["g"] = {
    S = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    s = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage file" },
    B = { "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>", "Toggle blame" },
    d = { "<cmd>DiffviewOpen<cr>", "Open git diff" },
    h = { "<cmd>DiffviewFileHistory %<cr>", "Open file history" },
    H = { "<cmd>DiffviewFileHistory<cr>", "Open file history for current branch" },
    g = { "<cmd>lua require 'lazygit'.lazygit()<cr>", "Open git diff" },
    f = { "<cmd>Telescope git_status<cr>", "Search changed files" },
  },
  -- file section
  f = {
    name = "Files",
    -- f = { require("lvim.core.telescope.custom-finders").find_project_files, "Find project files" },
    f = { "<cmd>FzfLua files<cr>", "Find project files" },
    r = { "<cmd>Telescope frecency <cr>", "Browse recent files" },
    b = { "<cmd>Telescope file_browser<cr>", "Browse file tree cool" },
    -- g = { require("user.telescope.finders").grep_open_files, "Search on open files" },
    g = { "<cmd>FzfLua lines<cr>", "Search on open files" },
    y = { "<cmd>lua Yank_file_name()<CR>", "Yank current file path" },
    Y = { "<cmd>lua Yank_full_file_name()<CR>", "Yank full file path" },
  },
  -- Contextual section. This will be filled from filetype functions
  x = {
    name = "contextual",
    u = { "gUiw", "Make word uppercase" },
    l = { "guiw", "Make word lowercase" },
    p = { "ysiw(", "Surryound word with parens" },
    r = { "viwP", "Replace word with clipboard content" },
  },
  ["?"] = { "<cmd>Cheat<CR>", " Cheat.sh" },
}

--#region search-replace plugin binds
local keymap = lvim.builtin.which_key.mappings
keymap["r"] = { name = "SearchReplaceSingleBuffer" }

keymap["r"]["s"] = { "<CMD>SearchReplaceSingleBufferSelections<CR>", "SearchReplaceSingleBuffer [s]election list" }
keymap["r"]["o"] = { "<CMD>SearchReplaceSingleBufferOpen<CR>", "[o]pen" }
keymap["r"]["w"] = { "<CMD>SearchReplaceSingleBufferCWord<CR>", "[w]ord" }
keymap["r"]["W"] = { "<CMD>SearchReplaceSingleBufferCWORD<CR>", "[W]ORD" }
keymap["r"]["e"] = { "<CMD>SearchReplaceSingleBufferCExpr<CR>", "[e]xpr" }
keymap["r"]["f"] = { "<CMD>SearchReplaceSingleBufferCFile<CR>", "[f]ile" }
keymap["r"]["n"] = {
  function()
    local util = require "search-replace.util"
    vim.cmd(
      ':call feedkeys(":%s/\\\\v'
        .. "\\\\_.{-}"
        .. util.double_escape(vim.fn.expand "<cword>")
        .. "//g"
        .. string.rep("\\<Left>", 2)
        .. '")'
    )
  end,
  "[n]ewline until word",
}
keymap["r"]["p"] = {
  function()
    D.vim.send_keys(":%s/\\v([^\\)]+)/\\1/g" .. string.rep("<Left>", 15))
  end,
  "capture [p]arens",
}

keymap["r"]["t"] = {
  function()
    D.vim.send_keys(":%s/\vtrue|false/ Bool/g" .. string.rep("<Left>", 5))
  end,
  "[t]rue false to Bool",
}

keymap["r"]["i"] = {
  function()
    D.vim.send_keys(':%s/\v"[^"]*"/ String/g' .. string.rep("<Left>", 5))
  end,
  "literal str[i]ng to type",
}

keymap["r"]["r"] = {
  function()
    D.vim.send_keys(":s/\\v\\i+/\\0/g" .. string.rep("<Left>", 4))
  end,
  "[r]epeat word",
}

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "haxe",
  callback = function()
    require("which-key").register({
      name = "haxe",
      o = {
        function()
          D.vim.send_keys(":s/\\v(\\i+)\\s*\\=/\\1:/g" .. string.rep("<Left>", 4))
        end,
        "haxe from lua [o]bject",
      },
      b = {
        function()
          D.vim.send_keys(":s/\\v(true|false)/Bool/g" .. string.rep("<Left>", 4))
        end,
        "haxe from lua [b]oolean type",
      },
    }, {
      mode = "n",
      prefix = "<leader>rh",
      buffer = 0,
      silent = false,
      noremap = true,
      nowait = false,
    })
  end,
})

keymap["r"]["b"] = { name = "SearchReplaceMultiBuffer" }

keymap["r"]["b"]["s"] = { "<CMD>SearchReplaceMultiBufferSelections<CR>", "SearchReplaceMultiBuffer [s]election list" }
keymap["r"]["b"]["o"] = { "<CMD>SearchReplaceMultiBufferOpen<CR>", "[o]pen" }
keymap["r"]["b"]["w"] = { "<CMD>SearchReplaceMultiBufferCWord<CR>", "[w]ord" }
keymap["r"]["b"]["W"] = { "<CMD>SearchReplaceMultiBufferCWORD<CR>", "[W]ORD" }
keymap["r"]["b"]["e"] = { "<CMD>SearchReplaceMultiBufferCExpr<CR>", "[e]xpr" }
keymap["r"]["b"]["f"] = { "<CMD>SearchReplaceMultiBufferCFile<CR>", "[f]ile" }

lvim.keys.visual_block_mode["<C-r>"] = [[<CMD>SearchReplaceSingleBufferVisualSelection<CR>]]
lvim.keys.visual_block_mode["<C-b>"] = [[<CMD>SearchReplaceWithinVisualSelectionCWord<CR>]]
--#endregion
-- merge our custom config with the one from lvim
local lv_which = lvim.builtin.which_key.mappings
lvim.builtin.which_key.mappings = vim.tbl_deep_extend("force", lv_which, whichConfig)

lvim.builtin.which_key.on_config_done = function(which)
  local registerOpts = { prefix = "<leader>" }
  which.register(whichConfig, registerOpts)
  vim.notify "Reloaded which keys"
end
