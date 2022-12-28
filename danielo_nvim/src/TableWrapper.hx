// From https://try.haxe.org/#0D7f4371
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.TypeTools;
#end

// Class that transforms any Haxe object into a plain lua table
// Thanks to @kLabz
#if macro abstract TableWrapper< T:{} >(Dynamic) { #else abstract TableWrapper< T:{} >(lua.Table< String, Dynamic >) {#end @:pure @:noCompletion extern public static inline function check< T:{} >(v:T):TableWrapper< T > {

  return null;
};

#if macro
public static function followTypesUp(arg:haxe.macro.Type) {
  return switch (arg) {
    case TAnonymous(_.get().fields => fields):
      fields;
    case TAbstract(_, [type]):
      followTypesUp(type);
    case TType(_, _):
      followTypesUp(arg.follow());
    case other:
      trace("other", other);
      throw "dead end 2?";
  }
}

static function extractObjFields(objExpr) {
  return switch Context.getTypedExpr(Context.typeExpr(objExpr)).expr {
    case EObjectDecl(inputFields):
      var inputFields = inputFields.copy();
      {fieldExprs: [for (f in inputFields) f.field => f.expr], inputFields: inputFields};

    case _:
      throw "Must be called with an anonymous object";
  }
}
#end

@:from public static macro function fromExpr(ex:Expr):Expr {
  var expected = Context.getExpectedType();
  var complexType = expected.toComplexType();

  switch expected {
    case TAbstract(_, [type]):
      final fields = followTypesUp(type);
      final x = extractObjFields(ex);
      final inputFields = x.inputFields;
      final fieldExprs = x.fieldExprs;

      var objFields:Array< ObjectField > = [for (f in fields) {
        switch (f.type) {
          case _.toComplexType() => macro :Array< String > :{
            field:f.name,
            expr:macro
            lua.Table.create
            (${fieldExprs.get(f.name)})
          };

          case TAbstract(_.toString() => "TableWrapper", [_]):
            var ct = f.type.toComplexType();

            for (inf in inputFields) if (inf.field == f.name) {
              inf.expr = macro(TableWrapper.check(${inf.expr}) : $ct);
              break;
            }

            {field: f.name, expr: macro(TableWrapper.fromExpr(${fieldExprs.get(f.name)}) : $ct)};

          case _:
            {field: f.name, expr: macro ${fieldExprs.get(f.name)}};
        }
      }];

      var inputObj = {expr: EObjectDecl(inputFields), pos: ex.pos};
      var obj = {expr: EObjectDecl(objFields), pos: ex.pos};

      return macro @:mergeBlock {
        // Type checking; should be removed by dce
        @:pos(ex.pos) var _:$complexType = TableWrapper.check($inputObj);

        // Actual table creation
        (cast lua.Table.create(null, $obj) : $complexType);
      };

    case other:
      trace(other);
      // trace(followTypesUp(other));
      throw "TableWrapper<T> only works with anonymous objects";
  }
}
}
