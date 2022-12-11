package vim;

import haxe.Rest;

using Test;

import haxe.Constraints.Function;
import lua.Table;
import plenary.Job;

inline function comment() {
	untyped __lua__("---@diagnostic disable");
}

abstract BufferId(Int) from Int {
	public function new(buf:Int) {
		this = buf;
	}

	@:from
	public static inline function from(bufNum:Int):BufferId {
		return new BufferId(bufNum);
	}
}

abstract WindowId(Int) from Int {
	public function new(id:Int) {
		this = id;
	}

	@:from
	public static inline function from(id:Int):WindowId {
		return new WindowId(id);
	}
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

abstract AutoCmdOpts(Table<String, Dynamic>) {
	public inline function new(pattern:String, cb, group, description:String) {
		this = Table.create(null, {
			pattern: pattern,
			callback: cb,
			group: group,
			desc: description
		});
	}
}

enum abstract VimEvent(String) {
	final FileType;
	final CursorHold;
	final BufWrite;
	final BufWritePre;
	final BufWritePost;
	final VimEnter;
}

@:native("vim.api")
extern class Api {
	static function nvim_create_augroup(group:String, opts:GroupOpts):Int;
	static function nvim_create_autocmd(event:LuaArray<VimEvent>, opts:AutoCmdOpts):Int;
}

@:native("vim")
extern class Vim {
	@:native("pretty_print")
	static function print(args:Rest<Dynamic>):Void;
}

@:expose("vim")
class DanieloVim {
	static public function autocmd(groupName:String, events:LuaArray<VimEvent>, pattern:String, ?description:String, cb:Function) {
		var group = Api.nvim_create_augroup(groupName, {clear: false});
		Api.nvim_create_autocmd(events, new AutoCmdOpts(pattern, cb, group, description.or('$groupName:[$pattern]')));
	}

	static public function chezmoi(args:Array<String>) {
		// final job = Job.make(new JobOpts("chezmoi", args));
		// return job.start();
	}

	static function main() {
		autocmd('HaxeEvent', [BufWritePost], "*.hx", "Created from haxe", () -> Vim.print('Hello from axe'));
	}
}
