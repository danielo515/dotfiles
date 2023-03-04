/**
  Given a path that can be found by the Haxe compiler, return the directory
  that contains it.
  This is useful to get the correct paths within a library.
 */

import haxe.io.Path;

function getDirFromPackagePath(path) {
  final base = Path.directory(haxe.macro.Context.resolvePath(path));
  return base;
}
