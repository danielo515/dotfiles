package vim;

using Test;

import haxe.Constraints.Function;
import lua.Table;

abstract Opts(Table<String, Bool>) {
	public inline function new(clear:Bool) {
		this = Table.create(null, {clear: clear});
	}
}

abstract AutoCmdOpts(Table<String, Dynamic>) {
	public inline function new(pattern, cb, group, description:String) {
		this = Table.create(null, {
			pattern: pattern,
			callback: cb,
			group: group,
			description: description
		});
	}
}

@:native("vim.api")
extern class Api {
	static function nvim_create_augroup(group:String, opts:Opts):Int;
	static function nvim_create_autocmd(opts:AutoCmdOpts):Int;
}

inline function comment() {
	untyped __lua__("---@diagnostic disable");
}

@:expose("vim")
class DanieloVim {
	static public function autocmd(groupName:String, pattern:String, ?description:String, cb:Function) {
		var group = Api.nvim_create_augroup(groupName, new Opts(false));
		Api.nvim_create_autocmd(new AutoCmdOpts(pattern, cb, group, description.or('$groupName:[$pattern]')));
	}
}
