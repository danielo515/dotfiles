package kickstart;

import lua.Table;

typedef CmpConfig = TableWrapper< {
  snippet:{
    expand:Dynamic -> Void,
  },
  mapping:lua.Table< String, Dynamic >,
  sources:Array< {name:String} >
} >

typedef Dict = lua.Table< String, Dynamic >;

@native('preset')
extern class Preset {
  @:luaDotMethod
  function insert(arg:Dict):Dict;
}

@:luaRequire('cmp')
extern class Cmp {
  static final mapping:{preset:Preset};
  static function setup(config:CmpConfig):Void;
  inline function getMappings():Dict {
    return untyped __lua__("
{
    ['<C-d>'] = {0}.mapping.scroll_docs(-4),
    ['<C-f>'] = {0}.mapping.scroll_docs(4),
    ['<C-Space>'] = {0}.mapping.complete(),
    ['<CR>'] = {0}.mapping.confirm {
      behavior = {0}.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = {0}.mapping(function(fallback)
      if {0}.visible() then
        {0}.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = {0}.mapping(function(fallback)
      if {0}.visible() then
        {0}.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }
      ",
      this);
  }
}

function configure() {
  final mapping = Cmp.mapping.preset.insert(lua.Table.create());
  Cmp.setup({
    snippet: {expand: (args:Dynamic) -> kickstart.Kickstart.Luasnip.lsp_expand(args.body)},
    mapping: mapping,
    sources: [{name: 'luasnip'}, {name: 'nvim_lsp'}]
  });
}
