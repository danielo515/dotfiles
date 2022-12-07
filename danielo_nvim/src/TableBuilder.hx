import haxe.macro.Context;
import haxe.macro.Expr;

// Thanks to
// https://stackoverflow.com/a/74711862/1734815
class TableBuilder {
	public static macro function build():Array<Field> {
		var fields = Context.getBuildFields();
		for (field in fields) {
			if (field.name != "_new")
				continue; // look for new()
			var f = switch (field.kind) { // ... that's a function
				case FFun(_f): _f;
				default: continue;
			}
			// abstract "constructors" transform `this = val;`
			// into `{ var this; this = val; return this; }`
			var val = switch (f.expr.expr) {
				case EBlock([_decl, macro this = $x, _ret]): x;
				default: continue;
			}
			//
			var objFields:Array<ObjectField> = [];
			for (arg in f.args) {
				var expr = macro $i{arg.name};
				if (arg.type.match(TPath({name: "Array", pack: []}))) {
					// if the argument's an array, make an unwrapper for it
					expr = macro lua.Table.create($expr, null);
				}
				objFields.push({field: arg.name, expr: expr});
			}
			var objExpr:Expr = {expr: EObjectDecl(objFields), pos: Context.currentPos()};
			val.expr = (macro lua.Table.create(null, $objExpr)).expr;
		}
		return fields;
	}
}
