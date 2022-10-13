return {
  -- I provide this dependency separately so packer stops annoying me about removing it
  "skywind3000/asyncrun.vim",
  {
    "skywind3000/asynctasks.vim",
    requires = {
      "skywind3000/asyncrun.vim",
    },
    setup = function()
      vim.cmd [[
          let g:asyncrun_open = 8
          let g:asynctask_template = '~/.config/lvim/task_template.ini'
          let g:asynctasks_extra_config = ['~/.config/lvim/tasks.ini']
          ]]
    end,
  },
}
