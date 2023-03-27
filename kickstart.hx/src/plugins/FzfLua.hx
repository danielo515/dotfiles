package plugins;

import vim.plugin.Plugin;
import lua.Table.create as t;

typedef FzfConfig = {
  winopts:{
    height:Int, width:Int, row:Int, col:Int, border:Array< String >, fullscreen:Bool,
  },
  preview:{
    border:String, // border|noborder, applies only to
    wrap:String, // wrap|nowrap
    hidden:String, // hidden|nohidden
    vertical:String, // up|down:size
    horizontal:String, // right|left:size
    layout:String, // horizontal|vertical|flex
    flip_columns:Int, // #cols to switch to horizontal on flex
    title:Bool, // preview border title (file/buf)?
    title_align:String, // left|center|right, title alignment
    scrollbar:String, // `Bool` or string:'float|border'
    scrolloff:String, // float scrollbar offset from right
    scrollchars:Array< String >, // float scrollbar chars
    delay:Int, // delay(ms) displaying the preview
    winopts:{ // builtin previewer window options
      number:Bool, relativenumber:Bool, cursorline:Bool, cursorlineopt:String, cursorcolumn:Bool, signcolumn:String, list:Bool, foldenable:Bool,
      foldmethod:String,
    },
  },
  keymap:{
    builtin:lua.Table< String, String >, fzf:lua.Table< String, String >
  }
};

extern class FzfLua implements VimPlugin {
  inline static final libName = 'fzf-lua';
  @:luaDotMethod function setup(config:Dynamic):Void;
}

inline function configure() {
  FzfLua.require()!.setup(t({}));
}
