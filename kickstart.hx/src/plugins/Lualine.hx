package plugins;

import vim.plugin.Plugin.VimPlugin;

extern class Lualine implements VimPlugin {
  inline static final libName = 'Lualine';
  @:luaDotMethod function setup(config:TableWrapper< {
    options:{
      icons_enabled:Bool,
      theme:String,
      component_separators:String,
      section_separators:String,
    }
  } >):Void;
}
