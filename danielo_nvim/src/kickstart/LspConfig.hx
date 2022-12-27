package kickstart;

import vim.VimTypes;

typedef LspConfigSetupFn = {
  setup:(config:TableWrapper< {
    on_attach:(a:Dynamic, bufnr:Buffer) -> Void,
    settings:lua.Table< String, Dynamic >,
    capabilities:Dynamic
  } >) -> Void
}

@:luaRequire('lspconfig')
extern class Lspconfig {
  static final sumneko_lua:LspConfigSetupFn;
}
