-- CMP specific plugins and configruations
table.insert(lvim.builtin.cmp.sources, {
  name = "rg",
})
table.insert(lvim.builtin.cmp.sources, { name = "npm", keyword_length = 4 })
table.insert(lvim.builtin.cmp.sources, {
  {
    name = "tmux",
    option = {
      all_panes = false,
      label = "[tmux]",
      trigger_characters = { "." },
      trigger_characters_ft = {}, -- { filetype = { '.' } }
    },
  },
})

return {
  {
    "lukas-reineke/cmp-rg",
  },
  {
    "andersevenrud/cmp-tmux",
  },
  {
    "David-Kunz/cmp-npm",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  },
}
