package vim;

import lua.Table;

abstract Opts(Table<String, Bool>) {
	public inline function new(clear:Bool) {
		this = Table.create(null, {clear: clear});
	}
}

@:native("vim.api")
extern class Api {
	static function nvim_create_augroup(group:String, opts:Opts):Int;
}

@:expose("vim")
class DanieloVim {
	static public function autocmd() {
		Api.nvim_create_augroup("Pene", new Opts(false));
	}
}
