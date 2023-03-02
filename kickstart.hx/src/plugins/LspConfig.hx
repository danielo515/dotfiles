package plugins;

import plugins.Plugins._require;
import vim.VimTypes;

extern class LspConfigSetupFn {
  inline function setup(config:{
    on_attach:(client:Dynamic, bufnr:Buffer) -> Void,
    settings:lua.Table< String, Dynamic >,
    ?capabilities:Dynamic
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

extern class Lspconfig {
  final lua_ls:LspConfigSetupFn;
  final haxe_language_server:LspConfigSetupFn;
  final jsonls:LspConfigSetupFn;

  inline static function require():Null< Lspconfig > {
    final module:Null< Lspconfig > = _require('lspconfig');
    return module;
  }
}
