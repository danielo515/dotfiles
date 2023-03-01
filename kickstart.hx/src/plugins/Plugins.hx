package plugins;

import vim.VimTypes;

@:native('safeRequire') function _require< T >(name):Null< T > {
  final module = lua.Lua.pcall(lua.Lua.require, name);
  return if (module.status) {
    module.value;
  } else {
    null;
  };
}

extern class IndentBlankline {
  @:luaDotMethod function setup(config:lua.Table< String, Dynamic >):Void;
  inline static function require():Null< IndentBlankline > {
    final module:Null< IndentBlankline > = _require('indent_blankline');
    return module;
  }
}

extern class Comment {
  @:luaDotMethod function setup():Void;
  inline static function require():Null< Comment > {
    final module:Null< Comment > = _require('Comment');
    return module;
  }
}

extern class Neodev {
  @:luaDotMethod function setup():Void;
  inline static function require():Null< Neodev > {
    final module:Null< Neodev > = _require('neodev');
    return module;
  }
}

extern class Mason {
  @:luaDotMethod function setup():Void;
  inline static function require():Null< Mason > {
    final module:Null< Mason > = _require('mason');
    return module;
  }
}

extern class Fidget {
  @:luaDotMethod function setup():Void;
  inline static function require():Null< Fidget > {
    final module:Null< Fidget > = _require('fidget');
    return module;
  }
}

extern class Cmp_nvim_lsp {
  @:luaDotMethod function default_capabilities(opts:Dynamic):Dynamic;
  inline static function require():Null< Cmp_nvim_lsp > {
    final module:Null< Cmp_nvim_lsp > = _require('cmp_nvim_lsp');
    return module;
  }
}

extern class MasonLspConfig {
  @:luaDotMethod function setup(opts:TableWrapper< {ensure_installed:Array< String >} >):Void;
  @:luaDotMethod function setup_handlers(handlers:LuaArray< (name:String) -> Void >):Void;
  inline static function require():Null< MasonLspConfig > {
    final module:Null< MasonLspConfig > = _require('mason-lspconfig');
    return module;
  }
}

extern class Luasnip {
  @:luaDotMethod function lsp_expand(args:Dynamic):Void;
  @:luaDotMethod function expand_or_jumpable():Bool;
  @:luaDotMethod function expand_or_jump():Void;
  @:luaDotMethod function jumpable(?direction:Int):Bool;
  @:luaDotMethod function jump(?direction:Int):Void;
  inline static function require():Null< Luasnip > {
    final module:Null< Luasnip > = _require('luasnip');
    return module;
  }
}

extern class JsonSchemas {
  public function schemas():LuaArray< {
    url:String,
    name:String,
    fileMatch:LuaArray< String >,
    description:String
  } >;
}

extern class SchemaStore {
  final json:JsonSchemas;
  inline static function require():Null< SchemaStore > {
    final module:Null< SchemaStore > = _require('schemastore');
    return module;
  }
}
