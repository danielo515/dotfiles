import lua.Table.AnyTable;
import vim.Vim;
import vim.VimTypes;
import lua.Table.create in t;

@:luaRequire('lualine')
extern class Lualine {
  static function setup(config:TableWrapper< {
    options:TableWrapper< {
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

@:luaRequire('neodev')
extern class Neodev {
  static function setup():Void;
}

@:luaRequire('mason')
extern class Mason {
  static function setup():Void;
}

@:luaRequire('fidget')
extern class Fidget {
  static function setup():Void;
}

@:luaRequire('cmp')
extern class Cmp {
  static function setup():Void;
}

@:luaRequire('mason-lspconfig')
extern class MasonLspConfig {
  static function setup(opts:TableWrapper< {ensure_installed:Array< String >} >):Void;
  static function setup_handlers(handlers:Array< (name:String) -> Void >):Void;
}

typedef LspConfigSetupFn = {
  final setup:(
    config:TableWrapper< {on_attach:(a:Dynamic, bufnr:Buffer) -> Void, Settings:AnyTable, capabilities:Dynamic} >
  ) -> Void;
}

@:luaRequire('lspconfig')
extern class Lspconfig {
  final sumneko_lua:LspConfigSetupFn;
}

@:luaRequire('luasnip')
extern class Luasnip {
  static function lsp_expand(args:Dynamic):Void;
  static function expand_or_jumpable():Bool;
  static function expand_or_jump():Void;
  static function jumpable(?direction:Int):Bool;
  static function jump(?direction:Int):Void;
}

inline function keymaps() {
  Keymap.set(
    t([Normal, Visual]),
    '<Space>',
    '<Nop>',
    {desc: 'do nothing', silent: true, expr: false}
  );
  Keymap.set(
    Normal,
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    {desc: 'up when word-wrap', silent: true, expr: true}
  );
  Keymap.set(
    Normal,
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    {desc: 'down when word-wrap', silent: true, expr: true}
  );
}

/**
  Port to Haxe of https://github.com/nvim-lua/kickstart.nvim
 */
function main() {
  DanieloVim.autocmd(
    "Kickstart",
    t([BufWritePost]),
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
      icons_enabled: true,
      theme: 'onedark',
      component_separators: '|',
      section_separators: '',
    },
  });

  Comment.setup();

  // -- See `:help indent_blankline.txt`
  IndentBlankline.setup(t({
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

  Neodev.setup();
  Mason.setup();
  Fidget.setup();
}
