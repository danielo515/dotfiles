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

typedef SignDefinition = TableWrapper< {text:String} >

@:luaRequire('gitsigns')
extern class Gitsigns {
  static function setup(config:TableWrapper< {
    signs:TableWrapper< {
      add:{text:String},
      change:{text:String},
      delete:{text:String},
      topdelete:{text:String},
      changedelete:{text:String},
    } >
  } >):Void;
}

@:luaRequire('Comment')
extern class Comment {
  static function setup():Void;
}

inline function keymaps() {
  Keymap.set(create([Normal, Visual]), '<Space>', '<Nop>', {desc: 'do nothing'});
}

/**
  Port to Haxe of https://github.com/nvim-lua/kickstart.nvim
 */
function main() {
  DanieloVim.autocmd(
    "Kickstart",
    create([BufWritePost]),
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
  keymaps();
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
