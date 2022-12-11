package plenary;

import lua.Table;
import vim.Vim;

typedef Job_opts = {
	final command:String;
	final cwd:Null<String>;
	final arguments:Array<String>;
	final nested:{x:String};
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
		arguments: ['-v'],
		nested: {x: "X"},
	});
	Vim.print(job);
}
