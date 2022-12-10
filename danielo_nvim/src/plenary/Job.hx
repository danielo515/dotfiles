package plenary;

import lua.Table;
import vim.Vim;

@:arrayAccess
abstract LuaArray<T>(lua.Table<Int, T>) from lua.Table<Int, T> to lua.Table<Int, T> {
	@:from
	public static inline function from<T>(arr:Array<T>):LuaArray<T> {
		return lua.Table.fromArray(arr);
	}
}

typedef Job_opts = {
	final command:String;
	final cwd:Null<String>;
	final arguments:LuaArray<String>;
}

// @:build(TableBuilder.build())

@:luaRequire("plenary.job")
extern class Job {
	private static inline function create(args:Table<String, Dynamic>):Job {
		Vim.print("job args", args);
		return untyped __lua__("{0}:new({1})", Job, args);
	}
	static inline function make(jobargs:Job_opts):Job {
		return create(Table.create(jobargs));
	}
	function start():Job;
	function sync():Job;
}

function main() {
	var job = Job.make({
		command: "chezmoi",
		cwd: "/Users/danielo/",
		arguments: ['-v']
	});
	Vim.print(job);
}
