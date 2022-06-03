-- CMP specific plugins and configruations
local sources = {
  { name = "npm", keyword_length = 4 },
  {
    {
      name = "tmux",
      option = {
        all_panes = true,
        label = "[tmux]",
        trigger_characters = { "." },
        trigger_characters_ft = {}, -- { filetype = { '.' } }
      },
    },
  },
  -- { name = "rg" },
  { name = "emoji" },
}

for _, source in ipairs(sources) do
  table.insert(lvim.builtin.cmp.sources, source)
end

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
  { "hrsh7th/cmp-emoji" },
}
