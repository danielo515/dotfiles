package kickstart;

import vim.VimTypes;

extern class LspConfigSetupFn {
  @:luaDotMethod
  function setup(config:LuaObj< {
    on_attach:(a:Dynamic, bufnr:Buffer) -> Void,
    settings:lua.Table< String, Dynamic >,
    capabilities:Dynamic
  } >):Void;
}

@:luaRequire('lspconfig')
extern class Lspconfig {
  static final sumneko_lua:LspConfigSetupFn;
}
