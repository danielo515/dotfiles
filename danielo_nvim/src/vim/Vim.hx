package vim;

using Test;

import haxe.Constraints.Function;
import lua.Table;

abstract Opts(Table<String, Bool>) {
	public inline function new(clear:Bool) {
		this = Table.create(null, {clear: clear});
	}
}

abstract ArgsList(Table<Int, String>) {
	public inline function new(data) {
		this = Table.create(data);
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

abstract JobOpts(Table<String, Dynamic>) {
	public inline function new(command:String, args:Array<String>) {
		this = Table.create(null, {
			command: command,
			arguments: Table.create(args)
		});
	}
}

@:luaRequire("plenary.job")
extern class Job {
	public function new(args:JobOpts);
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

	static public function chezmoi(args:Array<String>) {
		new Job(new JobOpts("chezmoi", ["-v"]));
	}
}
