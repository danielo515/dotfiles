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
  luasnip = "(LuaSnip)",
  buffer = "(Buffer)",
  tmux = "(TMUX)",
  rg = "(RG)",
  treesitter = "(TreeSitter)",
}

lvim.builtin.cmp.sorting = sorting
lvim.builtin.cmp.formatting.source_names = source_names
-- CMP specific plugins and configurations
local sources = {
  { name = "luasnip", priority_weight = 80 },
  {
    name = "nvim_lsp",
    max_item_count = 20,
    entry_filter = function(entry, ctx)
      local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
      if kind == "Snippet" and ctx.prev_context.filetype == "java" then
        return false
      end
      if kind == "Text" then
        return false
      end
      return true
    end,
  },

  { name = "cmp_tabnine" },
  { name = "calc" },
  { name = "emoji" },
  { name = "crates" },
  { name = "npm", keyword_length = 4 },
  { name = "path", priority_weight = 110 },
  { name = "git", priority_weight = 110 },
  { name = "nvim_lsp", max_item_count = 20, priority_weight = 100 },
  { name = "nvim_lua", priority_weight = 90 },
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
  { name = "treesitter" },
}

lvim.builtin.cmp.sources = sources

local cmdlineOk = pcall(function()
  -- Setup CMP on / and : prompts
  local mapping = {
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Replace }, { "c" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Replace }, { "c" }),
  }
  -- cmp.setup.cmdline("/", {
  --   mapping = cmp.mapping.preset.cmdline(mapping),
  --   sources = {
  --     { name = "buffer" },
  --   },
  -- })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(mapping),
    sources = {
      { name = "cmdline" },
      { name = "path" },
      { name = "buffer" },
      { name = "cmdline_history" },
    },
  })

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

  -- cmp.setup.cmdline(":", {
  --   mapping = {
  --     ["<Down>"] = cmdline_mappings.select_next_item,
  --     ["<C-n>"] = cmdline_mappings.select_next_item,
  --     ["<Tab>"] = cmdline_mappings.select_next_item,
  --     ["<C-p>"] = cmdline_mappings.select_prev_item,
  --     ["<Up>"] = cmdline_mappings.select_prev_item,
  --     ["<S-Tab>"] = cmdline_mappings.select_prev_item,
  --   },
  --   sources = {
  --     { name = "path" },
  --     { name = "cmdline" },
  --     { name = "buffer" },
  --     { name = "cmdline_history" },
  --   },
  -- })
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

local jumpable = require("lvim.core.cmp").methods.jumpable

lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.choice_active() then
    luasnip.change_choice(1)
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  elseif jumpable(1) then
    luasnip.jump(1)
  else
    fallback()
  end
end, { "i", "s" })

lvim.builtin.cmp.mapping["<C-s>"] = cmp.mapping.complete {
  config = {
    sources = {
      { name = "luasnip" },
    },
  },
}

if not cmdlineOk then
  vim.notify("Could not require cmp to setup cmdline", vim.log.levels.ERROR, { title = "Danielo" })
end

lvim.builtin.cmp.window.completion.max_height = 80
vim.opt.pumheight = 50 -- 0 will use all available space, but could cause performance issues
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
