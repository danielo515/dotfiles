package plugins;

import vim.plugin.Plugin.VimPlugin;
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

extern class Lspconfig implements VimPlugin {
  inline static final libName = 'lspconfig';
  final lua_ls:LspConfigSetupFn;
  final haxe_language_server:LspConfigSetupFn;
  final jsonls:LspConfigSetupFn;
}
