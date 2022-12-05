class Test {
	static public inline function or<T>(v:Null<T>, fallback:T):T
		return v != null ? v : fallback;
}
