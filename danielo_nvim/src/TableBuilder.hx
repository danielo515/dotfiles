import haxe.rtti.CType.Typedef;

using haxe.macro.Tools;
using haxe.macro.TypeTools;

import haxe.macro.Expr;
import haxe.macro.Context;

// Thanks to
// https://stackoverflow.com/a/74711862/1734815
class TableBuilder {
	macro public static function getFields(td:Expr):Array<Field> {
		var t = Context.getType(td.toString()).follow();
		var anon = switch (t) {
			case TAnonymous(ref): ref.get();
			case _: Context.error("Structure expected", td.pos);
		}
		for (tdf in anon.fields) {
			trace('generate function: resolve_${tdf.name};');
		}

		return null;
	}

	public static macro function build():Array<Field> {
		var fields = Context.getBuildFields();
		for (field in fields) {
			if (field.name != "make")
				continue; // look for new()

			var f = switch (field.kind) { // ... that's a function
				case FFun(_f): _f;
				default: continue;
			}
			var val = switch (f.expr.expr) {
				case EBlock([{expr: EReturn({expr: ECall(_, params)})}]): params;
				default: continue;
			}
			var objFields:Array<ObjectField> = [];
			for (arg in f.args) {
				var argVal = arg.value;
				switch (arg.type) {
					case TPath({name: x}):
						var theType = (Context.getType(x).follow());
						switch (theType) {
							case TAnonymous(ref):
								final fields = ref.get();
								// trace('anon', fields);
								for (field in fields.fields) {
									var name = field.name;
									objFields.push({
										field: name,
										expr: macro($i{arg.name}).$name,
									});
								}
							case _: continue;
						}
					default:
						continue;
				}
			}
			var objExpr:Expr = {expr: EObjectDecl(objFields), pos: Context.currentPos()};
			trace(objFields.toString());
			val[0].expr = (macro lua.Table.create(null, $objExpr)).expr;
		}
		return fields;
	}
}
