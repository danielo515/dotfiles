package vim;

import haxe.ds.StringMap;
import haxe.Rest;

using Test;

import vim.VimTypes;
import haxe.Constraints.Function;
import lua.Table;

inline function comment() {
	untyped __lua__("---@diagnostic disable");
}

abstract GroupOpts(Table<String, Bool>) {
	public inline function new(clear:Bool) {
		this = Table.create(null, {clear: clear});
	}

	@:from
	public inline static function fromObj(arg:{clear:Bool}) {
		return new GroupOpts(arg.clear);
	}
}

abstract Group(Int) {}

abstract AutoCmdOpts(Table<String, Dynamic>) {
	public inline function new(pattern:String, cb, group:Group, description:String, once = false, nested = false) {
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
	final bang:Bool;
	final line1:Int;
	final line2:Int;
	final count:Int;
	final reg:String;
	final mods:String;
}

@:native("vim.api")
extern class Api {
	static function nvim_create_augroup(group:String, opts:GroupOpts):Group;
	static function nvim_create_autocmd(event:LuaArray<VimEvent>, opts:AutoCmdOpts):Int;
	static function nvim_create_user_command(command_name:String, command:LuaObj<CommandCallbackArgs>->Void, opts:LuaObj<{desc:String, force:Bool}>):Void;
}

@:native("vim.fn")
extern class Fn {
	static function expand(string:ExpandString):String;
	static function fnamemodify(file:String, string:PathModifier):String;
	static function executable(binaryName:String):Int;
}

@:native("vim")
extern class Vim {
	@:native("pretty_print")
	static function print(args:Rest<Dynamic>):Void;
	static inline function expand(string:ExpandString):String {
		return Fn.expand(string);
	};
}

@:expose("vim")
class DanieloVim {
	public static final autogroups:StringMap<Group> = new StringMap();

	static public function autocmd(groupName:String, events:LuaArray<VimEvent>, pattern:String, ?description:String, cb:Function) {
		var group;
		switch (autogroups.get(groupName)) {
			case null:
				final newGroup = Api.nvim_create_augroup(groupName, {clear: false});
				autogroups.set(groupName, newGroup);
				group = newGroup;
			case x:
				group = x;
		};
		Api.nvim_create_autocmd(events, new AutoCmdOpts(pattern, cb, group, description.or('$groupName:[$pattern]')));
	}
}
