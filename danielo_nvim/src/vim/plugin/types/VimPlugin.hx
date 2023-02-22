package vim.plugin.types;

import lua.Lua;

abstract Plugin< T >(Option< T >) {
  inline function new(pluginName:String) {
    final requireResult = Lua.pcall(Lua.require, pluginName);
    if (requireResult.status) {
      this = cast Some(requireResult.value);
    } else {
      this = cast None;
    }
  }

  @:from
  public static inline function from< T >(pluginName:String):Plugin< T > {
    return new Plugin(pluginName);
  }

  public inline function map< R >(f:T -> R):Option< R > {
    return switch (this) {
      case Some(value):
        Some(f(value));
      case None: None;
    }
  }

  public inline function call(f:T -> Void):Void {
    switch (this) {
      case Some(lib):
        f(lib);
      case None:
        None;
    }
  }
}
