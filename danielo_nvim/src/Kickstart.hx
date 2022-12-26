import vim.Vim;
import vim.VimTypes;
import lua.Table.create;

@:luaRequire('lualine')
extern class Lualine {
  static function setup(config:LuaObj< {
    options:LuaObj< {
      icons_enabled:Bool,
      theme:String,
      component_separators:String,
      section_separators:String,
    } >
  } >):Void;
}

@:luaRequire('indent_blankline')
extern class IndentBlankline {
  static function setup(config:lua.Table< String, Dynamic >):Void;
}

typedef SignDefinition = LuaObj< {text:String} >

@:luaRequire('gitsigns')
extern class Gitsigns {
  static function setup(config:LuaObj< {
    signs:LuaObj< {
      add:SignDefinition,
      change:SignDefinition,
      delete:SignDefinition,
      topdelete:SignDefinition,
      changedelete:SignDefinition,
    } >
  } >):Void;
}

@:luaRequire('Comment')
extern class Comment {
  static function setup():Void;
}

/**
  Port to Haxe of https://github.com/nvim-lua/kickstart.nvim
 */
function main() {
  DanieloVim.autocmd(
    "Kickstart",
    [BufWritePost],
    Fn.expand(MYVIMRC),
    "Reload the config",
    () -> Vim.cmd("source <afile> | PackerCompile")
  );
  DanieloVim.autocmd(
    "Kickstart-yank",
    [TextYankPost],
    "*",
    "Highlight on yank",
    () -> untyped __lua__("vim.highlight.on_yank()")
  );
  Vim.cmd("colorscheme onedark");
  // -- Set lualine as statusline
  // -- See `:help lualine.txt`
  Lualine.setup({
    options: {
      icons_enabled: false,
      theme: 'onedark',
      component_separators: '|',
      section_separators: '',
    },
  });

  Comment.setup();

  // -- See `:help indent_blankline.txt`
  IndentBlankline.setup(create({
    char: '┊',
    show_trailing_blankline_indent: false,
  }));

  // -- See `:help gitsigns.txt`
  Gitsigns.setup({
    signs: {
      add: {
        text: '+'
      },
      change: {
        text: '~'
      },
      delete: {
        text: '_'
      },
      topdelete: {
        text: '‾'
      },
      changedelete: {
        text: '~'
      },
    },
  });
}
