-- CMP specific plugins and configruations
local sources = {
  { name = "npm", keyword_length = 4 },
  {
    {
      name = "tmux",
      option = {
        all_panes = true,
        label = "[tmux]",
        trigger_characters = {},
        trigger_characters_ft = {}, -- { filetype = { '.' } }
      },
      max_item_count = 10,
    },
  },
  -- { name = "rg", keyword_length = 3, option = { pattern = "[\\w ]+'" } },
  { name = "rg", keyword_length = 3, max_item_count = 10 },
  { name = "emoji" },
  { name = "treesitter", max_item_count = 10 },
}

for _, source in ipairs(sources) do
  table.insert(lvim.builtin.cmp.sources, source)
end

local cmdlineOk = pcall(function()
  local cmp = require "cmp"

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "cmdline" },
    },
  })
end)

if not cmdlineOk then
  vim.notify("Could not require cmp to setup cmdline", vim.log.levels.ERROR, { title = "Danielo" })
end

lvim.builtin.cmp.window.completion.max_height = 80
vim.opt.pumheight = 0 -- use alla available space
lvim.builtin.cmp.formatting.source_names.rg = "(RG)"
-- Return a list of plugins to install to insert in main plugins list
return {
  { "lukas-reineke/cmp-rg" },
  "ray-x/cmp-treesitter",
  { "andersevenrud/cmp-tmux" },
  {
    "David-Kunz/cmp-npm",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "hrsh7th/cmp-emoji" },
  { "hrsh7th/cmp-cmdline" },
}
