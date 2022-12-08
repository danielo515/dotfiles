package plenary;

import lua.Table;

@:build(TableBuilder.build())
abstract JOpts(Table<String, Dynamic>) {
	extern public inline function new(command:String, args:Array<String>)
		this = throw "no macro!";
}

typedef StrList = Table<Int, String>;

abstract JobOpts(Table<String, Dynamic>) {
	public inline function new(command:String, args:StrList) {
		this = Table.create(null, {
			command: command,
			arguments: args,
		});
	}
}

@:luaRequire("plenary.job")
extern class Job {
	static inline function make(args:JobOpts):Job {
		return untyped __lua__('require"plenary.job":new({0})', args);
	}
	@:native('new')
	function _make(args:JobOpts):Job;
	function start():Job;
}
