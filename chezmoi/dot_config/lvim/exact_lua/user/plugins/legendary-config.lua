local function config()
  local legendary = require "legendary"
  local mappings = lvim.builtin.which_key.mappings
  local wich_opts = lvim.builtin.which_key.opts
  legendary.setup {
    which_key = {
      mappings = mappings,
      opts = wich_opts,
      auto_register = false,
      -- false if which-key.nvim handles binding them,
      -- set to true if you want legendary.nvim to handle binding
      -- the mappings; if not passed, true by default
      -- do_binding = false,
    },
  }
  -- local compat = require "legendary.compat.which-key"
  -- compat.parse_whichkey(mappings, wich_opts, false)
end
return {
  "mrjones2014/legendary.nvim",
  config = config,
}
