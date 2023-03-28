package vim.plugin;

using haxe.macro.TypeTools;
using haxe.macro.ExprTools;

import haxe.macro.Context;
import haxe.macro.Expr;

class PluginMacro {
  /**
    helper to transform the values passed to the @module annotation.
    It expects the **contents** of the annotation which should look like this:
    @module(["name" => Type, "name2" => Type2])
    e.g.:
    ```haxe 
      case {meta: [{name: "module", params: [p]}]}: makeModule(p.expr);
    ```
  **/
  static public function makeModule(e:ExprDef) {
    return switch e {
      case EArrayDecl(f):
        f.map(x -> switch x {
          case macro $lh => $rh:
            {name: lh.getValue(), type: rh.toString()};
          case _: throw "Not what I expected";
        });
      case x:
        trace("sorry but", x);
        throw "unexpected construct";
    }
  }

  macro static public function pluginInterface():Array< Field > {
    final fields = Context.getBuildFields();
    final localType = Context.getLocalType().toComplexType();
    final returnType = macro :$localType;
    final newFields = [for (field in fields) {
      switch field {
        case {name: "libName", kind: FVar(_, {expr: EConst(CString(val, _))})}:
          final built = macro class X {
            inline static public function require():Null< $returnType > {
              return vim.Vimx.require($v{val});
            }
          };
          built.fields[0];

        case _:
          continue;
      }
    }];
    if (newFields.length == 0) {
      Context.error("No libName field found in plugin interface", Context.currentPos());
    }
    return fields.concat(newFields);
  }
}
