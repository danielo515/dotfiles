package plugins;

import vim.VimTypes.LuaArray;
import lua.Table.create as t;
import vim.Vim;
import lua.Lua;

function ensureInstalled():Bool {
  final install_path = Fn.stdpath("data") + "/site/pack/packer/start/packer.nvim";
  return if (vim.Fn.empty(vim.Fn.glob(install_path, null)) > 0) {
    vim.Fn.system(t([
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path
    ]), null);
    Vim.cmd("packadd packer.nvim");
    return true;
  } else {
    return false;
  };
}

typedef PluginSpec = {
  final name:String;
  final ?cmd:String;
  final ?event:String;
}

abstract Plugin(PluginSpec) {
  @:from
  public static inline function from(spec:PluginSpec):Plugin {
    return untyped __lua__(
      "{ {0}, cmd = {1}, event = {2}, config = {3} }",
      spec.name,
      spec.cmd,
      spec.event,
      spec.config
    );
  };
}

extern class Packer {
  @:luaDotMethod
  function startup(cb:(Plugin -> Void) -> Void):Void;
  @:luaDotMethod
  function sync():Void;

  inline static function init(plugins:Array< Plugin >):Void {
    final is_bootstrap = ensureInstalled();
    final packer:Packer = Lua.require("packer");
    Vim.print("Plugins", plugins);
    packer.startup((use) -> {
      for (plugin in plugins) {
        use(plugin);
      }
    });
    if (is_bootstrap) {
      packer.sync();
    }
  }
}
