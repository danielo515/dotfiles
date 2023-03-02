package vim;

import vim.Vim.Fn;
import vim.Vim.Loop;
import vim.Api;
import lua.StringMap;
import vim.VimTypes;
import haxe.Constraints.Function;

using Safety;

final pathSeparator = Loop.os_uname().sysname == 'Windows' ? '\\' : '/';

@:expose("vimx")
class Vimx {
  public static final autogroups:StringMap< Group > = new StringMap();

  /**
    Creates a new autocommand and associates it to the given group name.
    If the group has not been registered before, it gets created and cached
    so future commands with the same group name will re-use the same group.
    Note that existing commands on the group created outside of this function
    are not checked for existence.
   */
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

  /**
    Copies the given string to the system clipboard
   */
  public static function copyToClipboard(str:String) {
    final cmd = 'let @* = "$str"';
    Vim.cmd(cmd);
    Vim.notify("Copied to clipboard", "info");
  }

  /**
    Returns the number of lines of the current file in the current window
   */
  public static inline function linesInCurrentWindow():Int {
    return Fn.line('$', CurrentWindow);
  };

  /**
    Returns the line number of the first visible line
    on the current window
   */
  public static inline function firstLineVisibleCurrentWindow():Int {
    return Fn.line('w0', CurrentWindow);
  };

  /**
    Returns the line number of the last visible line
    on the current window
   */
  public static inline function lastLineVisibleCurrentWindow():Int {
    return Fn.line('w$', CurrentWindow);
  };

  /**
    Given a list of paths as strings, joins them using the
    path separator.
    This is supposed to be used from Haxe code
   */
  public static function join_paths(paths:Array< String >):String {
    return paths.join(pathSeparator);
  }

  /**
    Little wrapper that returns true if a file exists and is readable
   */
  public static function file_exists(path:String):Bool {
    return if (Fn.filereadable(path) == 0) {
      true;
    } else {
      false;
    }
  }
}
