package vim.ui;

import vim.VimTypes;
import haxe.Constraints.Function;

typedef SelectConfig = {
	var prompt:String;
}

@:native('vim.ui')
extern class Ui {
	static function select(options:LuaArray<String>, config:LuaObj<SelectConfig>, onSelect:(Null<String>, Null<Int>) -> Void):Void;
}
