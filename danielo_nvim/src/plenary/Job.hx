package plenary;

import lua.Table;

@:build(TableBuilder.build())
abstract JOpts(Table<String, Dynamic>) {
	extern public inline function new(command:String, args:Array<String>, ?cwd:String)
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
	static inline function make(args:JobOpts):Job {
		return untyped __lua__("{0}:new({1})", Job, args);
	}
	function start():Job;
	function sync():Job;
}
