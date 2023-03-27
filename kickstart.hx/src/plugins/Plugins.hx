package plugins;

import vim.VimTypes;
import vim.Vimx;
import vim.plugin.Plugin;

extern class NeoTree implements VimPlugin {
  inline static final libName = 'neo-tree';
  @:luaDotMethod function setup(opts:TableWrapper< {close_if_last_window:Bool} >):Void;
  inline static function configure():Void {
    NeoTree.require()!.setup({close_if_last_window: false});
  }
}

extern class IndentBlankline implements VimPlugin {
  inline static final libName = 'indent_blankline';
  @:luaDotMethod function setup(config:lua.Table< String, Dynamic >):Void;
}

extern class Comment implements VimPlugin {
  inline static final libName = 'Comment';
  @:luaDotMethod function setup():Void;
}

extern class Neodev implements VimPlugin {
  inline static final libName = 'neodev';
  @:luaDotMethod function setup():Void;
}

extern class Mason implements VimPlugin {
  inline static final libName = 'mason';
  @:luaDotMethod function setup():Void;
}

extern class Fidget implements VimPlugin {
  inline static final libName = 'fidget';
  @:luaDotMethod function setup():Void;
}

extern class Cmp_nvim_lsp implements VimPlugin {
  inline static final libName = 'cmp_nvim_lsp';
  @:luaDotMethod function default_capabilities(opts:Dynamic):Dynamic;
}

extern class MasonLspConfig implements VimPlugin {
  inline static final libName = 'mason-lspconfig';
  @:luaDotMethod function setup(opts:TableWrapper< {ensure_installed:Array< String >} >):Void;
  @:luaDotMethod function setup_handlers(handlers:LuaArray< (name:String) -> Void >):Void;
}

extern class Luasnip implements VimPlugin {
  inline static final libName = 'luasnip';
  @:luaDotMethod function lsp_expand(args:Dynamic):Void;
  @:luaDotMethod function expand_or_jumpable():Bool;
  @:luaDotMethod function expand_or_jump():Void;
  @:luaDotMethod function jumpable(?direction:Int):Bool;
  @:luaDotMethod function jump(?direction:Int):Void;
}

extern class JsonSchemas {
  public function schemas():LuaArray< {
    url:String,
    name:String,
    fileMatch:LuaArray< String >,
    description:String
  } >;
}

extern class SchemaStore implements VimPlugin {
  inline static final libName = 'schemastore';
  final json:JsonSchemas;
}
