package kickstart;

import vim.VimTypes;

extern class LspConfigSetupFn {
  inline function setup(config:{
    on_attach:(client:Dynamic, bufnr:Buffer) -> Void,
    settings:lua.Table< String, Dynamic >,
    capabilities:Dynamic
  }):Void {
    untyped __lua__(
      "{0}.setup({
      on_attach = {1},
      settings = {2},
      capabilities = {3},
    })",
      this,
      config.on_attach,
      config.settings,
      config.capabilities
    );
  };
}

@:luaRequire('lspconfig')
extern class Lspconfig {
  static final sumneko_lua:LspConfigSetupFn;
}

typedef X = {
  doX:Int,
  test:Bool,
  nest:{a:Float},
};

typedef W = TableWrapper< X >;
extern function testMethod(x:W):Void;

function doY() {
  testMethod({doX: 99, test: true, nest: {a: 1.1}});
}
