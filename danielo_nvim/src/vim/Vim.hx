package vim;

import haxe.extern.EitherType;
import lua.StringMap;
import haxe.Rest;

using Test;

import vim.VimTypes;
import haxe.Constraints.Function;
import lua.Table;

inline function comment() {
  untyped __lua__("---@diagnostic disable");
}

abstract GroupOpts(Table< String, Bool >) {
  public inline function new(clear:Bool) {
    this = Table.create(null, {clear: clear});
  }

  @:from
  public inline static function fromObj(arg:{clear:Bool}) {
    return new GroupOpts(arg.clear);
  }
}

abstract Group(Int) {}

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

@:native("vim.api")
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

@:native("vim.fs")
@:build(ApiGen.attachApi("fs"))
extern class Fs {}

@:native("vim.fn")
@:build(ApiGen.attachApi("fn"))
extern class Fn {
  static function expand(string:ExpandString):String;
  static function fnamemodify(file:String, string:PathModifier):String;
  static function executable(binaryName:String):Int;
  static function json_encode(value:Dynamic):String;
  static function json_decode(json:String):Table< String, Dynamic >;
}

@:native("vim.keymap")
extern class Keymap {
  public static function set(
    mode:EitherType< VimMode, LuaArray< VimMode > >,
    keys:String,
    map:EitherType< Function, String >,
    opts:TableWrapper< {desc:String} >
  ):Void;
}

@:native("vim")
extern class Vim {
  @:native("pretty_print")
  static function print(args:Rest< Dynamic >):Void;
  static inline function expand(string:ExpandString):String {
    return Fn.expand(string);
  };
  public static function tbl_map< T, B >(fn:T -> B, tbl:LuaArray< T >):LuaArray< B >;
  public static function cmd(command:String):Void;
  public static function notify(message:String, level:String):Void;
}

@:expose("vim")
class DanieloVim {
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
