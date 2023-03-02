package plugins;

extern class Lualine {
  inline static function require():Null< Lualine > {
    final module = lua.Lua.pcall(lua.Lua.require, "lualine");
    return module.status ? module.value : null;
  }
  @:luaDotMethod function setup(config:TableWrapper< {
    options:{
      icons_enabled:Bool,
      theme:String,
      component_separators:String,
      section_separators:String,
    }
  } >):Void;
}
