@:arrayAccess
abstract LuaArray<T>(lua.Table<Int, T>) from lua.Table<Int, T> to lua.Table<Int, T> {
	@:from
	public static inline function from<T>(arr:Array<T>):LuaArray<T> {
		return lua.Table.create(arr);
	}
}
