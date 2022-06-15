-- Deactivate the builtin git plugin because this one overseeds it
-- lvim.builtin.gitsigns.active = false
return {
  'tanvirtin/vgit.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('vgit').setup({
      kymaps = {},
      settings = {
        git = {
          cmd = 'git', -- optional setting, not really required
          fallback_cwd = vim.fn.expand("$HOME"),
          fallback_args = {
            "--git-dir",
            vim.fn.expand("$HOME/dots/yadm-repo"),
            "--work-tree",
            vim.fn.expand("$HOME"),
          },
        },
        hls = {
          GitBackground = 'Normal',
          GitHeader = 'NormalFloat',
          GitFooter = 'NormalFloat',
          GitBorder = 'LineNr',
          GitLineNr = 'LineNr',
          GitComment = 'Comment',
          GitSignsAdd = {
            gui = nil,
            fg = '#d7ffaf',
            bg = nil,
            sp = nil,
            override = false,
          },
          GitSignsChange = {
            gui = nil,
            fg = '#7AA6DA',
            bg = nil,
            sp = nil,
            override = false,
          },
          GitSignsDelete = {
            gui = nil,
            fg = '#e95678',
            bg = nil,
            sp = nil,
            override = false,
          },
          GitSignsAddLn = 'DiffAdd',
          GitSignsDeleteLn = 'DiffDelete',
          GitWordAdd = {
            gui = nil,
            fg = nil,
            bg = '#5d7a22',
            sp = nil,
            override = false,
          },
          GitWordDelete = {
            gui = nil,
            fg = nil,
            bg = '#960f3d',
            sp = nil,
            override = false,
          },
        },
        live_blame = {
          enabled = false,
        },
        live_gutter = {
          enabled = false,
          edge_navigation = false, -- This allows users to navigate within a hunk
        },
        authorship_code_lens = {
          enabled = false,
        },
        scene = {
          diff_preference = 'unified',
        },
        diff_preview = {
          keymaps = {
            buffer_stage = 'S',
            buffer_unstage = 'U',
            buffer_hunk_stage = 's',
            buffer_hunk_unstage = 'u',
            toggle_view = 'q',
          },
        },
        project_diff_preview = {
          keymaps = {
            buffer_stage = 's',
            buffer_unstage = 'u',
            buffer_hunk_stage = 'gs',
            buffer_hunk_unstage = 'gu',
            buffer_reset = 'r',
            stage_all = 'S',
            unstage_all = 'U',
            reset_all = 'R',
          },
        },
        symbols = { void = '⣿' },
      }
    })
  end
}
