local cmp = require "cmp"
local luasnip = require "luasnip"
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
  local mapping = {
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Replace }, { "c" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Replace }, { "c" }),
  }
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(mapping),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(mapping),
    sources = {
      { name = "cmdline" },
    },
  })
end)
-- This works for me. To avoid future problems with Lvim updating this, i will be overriding it anyway
lvim.builtin.cmp.mapping["<CR>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    local confirm_opts = {
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }
    if cmp.confirm(confirm_opts) then
      return
    end
  end

  if luasnip.jumpable(1) and luasnip.jump(1) then
    return
  end
  fallback()
end, { "i" })

if not cmdlineOk then
  vim.notify("Could not require cmp to setup cmdline", vim.log.levels.ERROR, { title = "Danielo" })
end

lvim.builtin.cmp.window.completion.max_height = 80
vim.opt.pumheight = 0 -- use all available space
lvim.builtin.cmp.formatting.source_names.rg = "(RG)"
-- Return a list of plugins to install to insert in main plugins list
return {
  { "lukas-reineke/cmp-rg" },
  { "ray-x/cmp-treesitter" },
  { "andersevenrud/cmp-tmux" },
  {
    "David-Kunz/cmp-npm",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmp-npm").setup {}
    end,
  },
  { "hrsh7th/cmp-emoji" },
  { "hrsh7th/cmp-cmdline", commit = "9c0e331" },
  { "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" },
}
