local default_workspace = {
  library = {
    vim.fn.expand "$VIMRUNTIME",
    get_lvim_base_dir(),
    require("neodev.config").types(),
    os.getenv "HOME" .. "/.hammerspoon/Spoons/EmmyLua.spoon/annotations",
    "${3rd}/busted/library",
    "${3rd}/luassert/library",
  },

  maxPreload = 5000,
  preloadFileSize = 10000,
}

local opts = {
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = {
        version = "LuaJIT",
        special = {
          reload = "require",
        },
      },
      diagnostics = {
        globals = { "vim", "lvim", "packer_plugins", "reload" },
      },
      workspace = default_workspace,
    },
  },
}
require("lvim.lsp.manager").setup("sumneko_lua", opts)
