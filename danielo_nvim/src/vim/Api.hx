package vim;

import haxe.extern.EitherType;
import lua.StringMap;
import haxe.Rest;

using Test;

import vim.VimTypes;
import haxe.Constraints.Function;
import lua.Table;

typedef CommandCallbackArgs = {
  final args:String;
  final fargs:Table< String, String >;
  final bang:Bool;
  final line1:Int;
  final line2:Int;
  final count:Int;
  final reg:String;
  final mods:String;
}

typedef UserCommandOpts = TableWrapper< {
  desc:String,
  force:Bool,
  ?nargs:Nargs,
  ?bang:Bool,
  // ?range:CmdRange,
} >

abstract AutoCmdOpts(Table< String, Dynamic >) {
  public inline function new(
    pattern:String,
    cb,
    group:Group,
    description:String,
    once = false,
    nested = false
  ) {
    this = Table.create(null, {
      pattern: pattern,
      callback: cb,
      group: group,
      desc: description,
      once: once,
      nested: nested,
    });
  }
}

@:native("vim.api")
// @:build(ApiGen.attachApi("api"))
extern class Api {
  static function nvim_create_augroup(group:String, opts:GroupOpts):Group;
  static function nvim_create_autocmd(event:LuaArray< VimEvent >, opts:AutoCmdOpts):Int;
  static function nvim_create_user_command(
    command_name:String,
    command:LuaObj< CommandCallbackArgs > -> Void,
    opts:TableWrapper< {
      desc:String,
      force:Bool,
      ?nargs:Nargs,
      ?bang:Bool,
      ?range:CmdRange,
    } >
  ):Void;
}
