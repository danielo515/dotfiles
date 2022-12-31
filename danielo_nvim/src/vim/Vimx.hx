package vim;

import vim.Api;
import lua.StringMap;
import vim.VimTypes;
import haxe.Constraints.Function;

using Safety;

@:expose("vim")
class Vimx {
  public static final autogroups:StringMap< Group > = new StringMap();

  static public function autocmd(
    groupName:String,
    events:LuaArray< VimEvent >,
    pattern:String,
    ?description:String,
    cb:Function
  ) {
    var group:Group;
    switch (autogroups.get(groupName)) {
      case null:
        group = Api.nvim_create_augroup(groupName, {clear: true});
        autogroups.set(groupName, group);
      case x:
        group = x;
    };
    Api.nvim_create_autocmd(
      events,
      new AutoCmdOpts(pattern, cb, group, description.or('$groupName:[$pattern]'))
    );
  }
}
