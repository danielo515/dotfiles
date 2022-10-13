local cmp = require "cmp"
local luasnip = require "luasnip"

local sorting = {
  priority_weight = 100,
  comparators = {
    cmp.config.compare.offset,
    cmp.config.compare.exact,
    cmp.config.compare.score,
    -- require("cmp-under-comparator").under,
    cmp.config.compare.sort_text,
    cmp.config.compare.length,
    cmp.config.compare.order,
  },
}

local source_names = {
  nvim_lsp = "(LSP)",
  emoji = "(Emoji)",
  path = "(Path)",
  calc = "(Calc)",
  cmp_tabnine = "(Tabnine)",
  vsnip = "(Snippet)",
  luasnip = "(Snippet)",
  buffer = "(Buffer)",
  tmux = "(TMUX)",
  rg = "(RG)",
  treesitter = "(TreeSitter)",
}

lvim.builtin.cmp.sorting = sorting
lvim.builtin.cmp.formatting.source_names = source_names
-- CMP specific plugins and configurations
local sources = {
  { name = "npm", keyword_length = 4 },
  --#region Copied from someone
  { name = "path", priority_weight = 110, option = { label = "[Path]" } },
  { name = "git", priority_weight = 110 },
  { name = "nvim_lsp", max_item_count = 20, priority_weight = 100 },
  { name = "nvim_lua", priority_weight = 90 },
  { name = "luasnip", priority_weight = 80 },
  { name = "buffer", max_item_count = 5, priority_weight = 70 },
  {
    name = "rg",
    keyword_length = 4,
    max_item_count = 5,
    priority_weight = 60,
    option = {
      additional_arguments = "--smart-case --hidden",
    },
  },
  { name = "tmux", max_item_count = 5, option = { all_panes = true, label = "[tmux]" }, priority_weight = 50 },
  {
    name = "look",
    keyword_length = 5,
    max_item_count = 5,
    option = { convert_case = true, loud = true },
    priority_weight = 40,
  },
}

for _, source in ipairs(sources) do
  table.insert(lvim.builtin.cmp.sources, source)
end

local cmdlineOk = pcall(function()
  -- Setup CMP on / and : prompts
  -- local mapping = {
  --   ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Replace }, { "c" }),
  --   ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Replace }, { "c" }),
  -- }
  -- cmp.setup.cmdline("/", {
  --   mapping = cmp.mapping.preset.cmdline(mapping),
  --   sources = {
  --     { name = "buffer" },
  --   },
  -- })

  -- cmp.setup.cmdline(":", {
  --   mapping = cmp.mapping.preset.cmdline(mapping),
  --   sources = {
  --     { name = "cmdline" },
  --   },
  -- })

  local cmdline_mappings = {
    select_next_item = {
      c = function(fallback)
        if cmp.visible() then
          return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
        else
          return cmp.mapping.complete { reason = cmp.ContextReason.Auto }(fallback)
        end
      end,
    },
    select_prev_item = {
      c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    },
  }

  cmp.setup.cmdline(":", {
    mapping = {
      ["<Down>"] = cmdline_mappings.select_next_item,
      ["<C-n>"] = cmdline_mappings.select_next_item,
      ["<Tab>"] = cmdline_mappings.select_next_item,
      ["<C-p>"] = cmdline_mappings.select_prev_item,
      ["<Up>"] = cmdline_mappings.select_prev_item,
      ["<S-Tab>"] = cmdline_mappings.select_prev_item,
    },
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }, {
      { name = "buffer" },
    }, {
      { name = "cmdline_history" },
    }),
  })
  cmp.setup.cmdline("/", {
    mapping = {
      ["<Down>"] = cmdline_mappings.select_next_item,
      ["<C-n>"] = cmdline_mappings.select_next_item,
      ["<Tab>"] = cmdline_mappings.select_next_item,
      ["<C-p>"] = cmdline_mappings.select_prev_item,
      ["<Up>"] = cmdline_mappings.select_prev_item,
      ["<S-Tab>"] = cmdline_mappings.select_prev_item,
    },
    sources = cmp.config.sources({
      { name = "buffer" },
    }, {
      { name = "cmdline_history" },
    }),
  })
end)
--#region builtin overrides
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
--#endregion
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
  { "hrsh7th/cmp-calc" },
}
