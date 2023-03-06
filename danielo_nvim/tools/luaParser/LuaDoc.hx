package tools.luaParser;

import byte.ByteData;
import hxparse.Lexer;

using StringTools;
using Safety;

typedef Param = {
  final type:String;
  final description:String;
}

enum TypeToken {
  Function;
  Number;
  String;
  Table;
  Boolean;
  Nil;
}

enum DocToken {
  Identifier(name:String);
  Description(text:String);
  DocType(type:TypeToken);
  ArrayMod;
  OptionalMod;
  Comma;
  CurlyOpen;
  CurlyClose;
  SquareOpen;
  SquareClose;
  Lparen;
  Rparen;
  TypeOpen;
  TypeClose;
  Pipe;
  SPC;
  EOL;
}

class LuaDocLexer extends Lexer implements hxparse.RuleBuilder {
  static var ident = "[a-zA-Z_][a-zA-Z0-9_]*";

  public static var desc = @:rule [
    "[^\n]*" => Description(lexer.current.ltrim()),
    "" => EOL
  ];
  public static var paramDoc = @:rule [
    ident => {final name = lexer.current.ltrim().rtrim(); Identifier(name);},
    " " => SPC,
    "" => EOL,
  ];
  public static var typeDoc = @:rule [
    " " => SPC,
    // " " => lexer.token(typeDoc),
    "," => lexer.token(typeDoc),
    "\\[\\]" => ArrayMod,
    "\\?" => OptionalMod,
    "<" => TypeOpen,
    ">" => TypeClose,
    "{" => CurlyOpen,
    "}" => CurlyClose,
    "[" => SquareOpen,
    "]" => SquareClose,
    "\\(" => Lparen,
    "\\)" => Rparen,
    "\\|" => Pipe,
    "number" => DocType(TypeToken.Number),
    "string" => DocType(TypeToken.String),
    "table" => DocType(TypeToken.Table),
    "boolean" => DocType(TypeToken.Boolean),
    "function" => DocType(TypeToken.Function),
    "fun" => DocType(TypeToken.Function),
    "nil" => DocType(Nil),
    "" => EOL,
    // ident => throw 'Unknown type "${lexer.current}"',
  ];
}

class LuaDocParser extends hxparse.Parser< hxparse.LexerTokenSource< DocToken >, DocToken > implements hxparse.ParserBuilder {
  private final inputAsString:byte.ByteData;

  public function new(input:byte.ByteData) {
    inputAsString = (input);
    var lexer = new LuaDocLexer(input);
    var ts = new hxparse.LexerTokenSource(lexer, LuaDocLexer.paramDoc);
    super(ts);
  }

  public function parse() {
    return switch stream {
      case [SPC]: parse();
      case [Identifier(name)]:
        switch stream {
          case [EOL]:
            return {name: name, type: null, description: null};
          case [SPC]:
            stream.ruleset = LuaDocLexer.typeDoc;
            try {
              final t = parseType();
              stream.ruleset = LuaDocLexer.desc;
              final text = parseDesc();
              return {name: name, type: t, description: text};
            }
            catch (e) {
              Log.print2("Error parsing type: ", e);
              Log.print("Remaining input: ");
              final pos = stream.curPos().pmin;
              Log.print('"${inputAsString.readString(pos, inputAsString.length - pos)}"');
              throw(e);
            }
          case _:
            trace("Expecting identifier, dup state", null);
            trace(stream, null);
            throw "Unexpected token";
        }
    }
  }

  public function parseType() {
    return switch stream {
      // case [CurlyOpen, t = parseType(), CurlyClose,]:
      //   'Object($t)';
      case [DocType(Table)]:
        switch stream {
          case [SPC]: 'Table';
          case [TypeOpen, t = parseTypeArgs(), TypeClose]:
            'Table<$t>';
        }
      case [DocType(t)]:
        switch stream {
          case [SPC]: '$t';
          case [Pipe, e = parseEither('$t')]: e;
          case _: '$t';
        }
    }
  }

  public function parseEither(left) {
    return switch stream {
      case [DocType(t)]:
        switch stream {
          case [SPC]:
            'Either<$left, $t>';
          case [Pipe, e = parseEither('$t')]: 'Either<$left, $e>';
        }
    };
  }

  public function parseTypeArgs() {
    return switch stream {
      case [TypeClose]: '';
      case [DocType(Table), TypeOpen, t = parseTypeArgs()]: t;
      // @formatter:on
      case [DocType(t)]: t + '';
    };
  }

  public function parseDesc() {
    return switch stream {
      case [Description(text), EOL]:
        text;
      case _: "";
    }
  }
}
