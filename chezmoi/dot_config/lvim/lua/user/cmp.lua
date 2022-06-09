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
  { name = "rg", option = { pattern = '[\\w ]+"' } },
  { name = "emoji" },
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
  { "hrsh7th/cmp-cmdline" },
}
