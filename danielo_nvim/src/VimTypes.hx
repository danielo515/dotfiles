@:arrayAccess
abstract LuaArray<T>(lua.Table<Int, T>) from lua.Table<Int, T> to lua.Table<Int, T> {
	// Can this be converted into a macro to avoid even calling fromArray ?
	@:from
	public static function from<T>(arr:Array<T>):LuaArray<T> {
		return lua.Table.fromArray(arr);
	}
}

// Some boilerplate here for type safety
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
