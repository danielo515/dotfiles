package plugins;

import vim.VimTypes.LuaArray;
import lua.Table.create as t;
import vim.Vim;
import lua.Lua;

var is_bootstrap = false;

function ensureInstalled() {
	final install_path = Fn.stdpath("data") + "/site/pack/packer/start/packer.nvim";
	if (vim.Fn.empty(vim.Fn.glob(install_path, null)) > 0) {
		is_bootstrap = true;
		vim.Fn.system(t([
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path
		]), null);
		Vim.cmd("packadd packer.nvim");
	}
}

typedef PluginSpec = {
	final name:String;
}

typedef Plugins = LuaArray<PluginSpec>;

extern class Packer {
	static function startup(cb:((Plugins) -> Void)->Void):Void;
	inline static function init(plugins:Plugins):Void {
		ensureInstalled();
		startup(function(use) {
			use(plugins);
		});
		final packer = Lua.require("packer");
		if (is_bootstrap) {
			packer.sync();
		}
	}
}
