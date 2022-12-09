package plenary;

import lua.Table;
import vim.Vim;

typedef Job_opts = {
	final command:String;
	final cwd:Null<String>;
	// final arguments:Array<String>;
}

@:build(TableBuilder.build())
abstract JOpts(Table<String, Dynamic>) {
	extern public inline function new(args:Job_opts)
		this = throw "no macro!";
}

abstract JobOpts(Table<String, Dynamic>) {
	public inline function new(command:String, args:Array<String>, ?cwd:String) {
		final args = Table.fromArray(args);
		this = Table.create(null, {
			command: command,
			arguments: args,
			cwd: cwd,
		});
	}
}

@:luaRequire("plenary.job")
extern class Job {
	private static inline function create(args:Table<String, Dynamic>):Job {
		Vim.print("job args", args);
		return untyped __lua__("{0}:new({1})", Job, args);
	}
	static inline function make(args:Job_opts, cmdArgs:Array<String>):Job {
		final jobArgs = Table.create(null, args);
		jobArgs.arguments = Table.create(cmdArgs);
		return create(jobArgs);
	}
	function start():Job;
	function sync():Job;
}

function main() {
	final job = Job.make({
		command: "chezmoi",
		cwd: "/Users/danielo/",
	}, ["-v",]);
	Vim.print(job.sync());
}
