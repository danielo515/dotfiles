package tools.luaParser;

import byte.ByteData;
import hxparse.Lexer;
import hxparse.ParserError.ParserError;

using StringTools;
using Safety;

typedef Param = {
  final type:String;
  final description:String;
}

enum TypeToken {
  TFunction;
  Number;
  String;
  Table;
  Boolean;
  Nil;
  Colon;
  TIdentifier(name:String);
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
    "function" => DocType(TypeToken.TFunction),
    "fun" => DocType(TypeToken.TFunction),
    "nil" => DocType(Nil),
    ":" => DocType(Colon),
    ident => DocType(TIdentifier(lexer.current)),
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

  public function dumpAtCurrent() {
    final pos = stream.curPos();
    final max:Int = inputAsString.length - 1;
    Log.print2("> Last parsed token: ", this.last);
    Log.print2("> ", inputAsString.readString(0, max));
    // final cursorWidth = (pos.pmax - pos.pmin) - 1;
    // Log.print("^".lpad(" ", pos.pmin + 1) + "^".lpad(" ", cursorWidth));
    Log.print("^".lpad(" ", pos.pmax + 2));
  }

  public function parse() {
    return switch stream {
      case [SPC]: parse();
      case [Identifier(name)]:
        switch stream {
          case [EOL]:
            return {name: name, type: "Any", description: ""};
          case [SPC]:
            stream.ruleset = LuaDocLexer.typeDoc;
            try {
              Log.print("Abou to parse types");
              final t = parseType();
              Log.print("Parsed types");
              stream.ruleset = LuaDocLexer.desc;
              if (peek(0) == SPC) {
                junk();
              } else {
                Log.print("WARNING: No space after types");
              }
              final text = parseDesc();
              return {name: name, type: t, description: text};
            }
            catch (e:ParserError) {
              Log.print2("Error parsing type: \n\t", e);
              dumpAtCurrent();
              Log.print2("line", e.pos.format(inputAsString));
              throw(e);
            }
          case _:
            trace("Expecting identifier, dup state", null);
            dumpAtCurrent();
            throw "Unexpected token";
        }
    }
  }

  public function parseType() {
    return switch stream {
      case [DocType(Table)]:
        Log.print("Hey table");
        switch stream {
          // If the whole types is within parens and table is last, ignore paren close
          // case [Rparen]:
          //   Log.print("Hey table+paren");
          //   'Table';
          // case [SPC]:
          //   Log.print("Hey table+space");
          //   'Table';
          case [TypeOpen, t = parseTypeArgs(), TypeClose]:
            'Table<$t>';
          case _:
            Log.print("Hey default within table");
            "Table";
        }
      case [Lparen, t = parseType(), Rparen]: // This is ridiculous, but neovim people thinks is nice
        Log.print("Hey within parents");
        '$t';
      case [DocType(TFunction), Lparen, t = parseFunctionArgs()]:
        '$t';
      case [DocType(t)]:
        switch stream {
          case [SPC]: '$t';
          case [Pipe, e = parseEither('$t')]: e;
          case _: '$t';
        }
    }
  }

  public function parseFunctionArgs() {
    return switch stream {
      case [DocType(TIdentifier(name)), DocType(Colon)]:
        // We should discard spaces that may be separating argument and type
        if (peek(0) == SPC)
          junk();
        final t = parseType();
        // account for potential return type
        final returnType = switch [peek(0), peek(1), peek(2)] {
          case [Rparen, DocType(Colon), SPC]:
            junk();
            junk();
            junk();
            parseType();
          case [Rparen, DocType(Colon), _]:
            junk();
            junk();
            parseType();
          case _: 'Void';
        }
        'FunctionWithArgs($name: $t):$returnType';
    }
  }

  public function parseEither(left) {
    return switch stream {
      case [DocType(t)]:
        switch stream {
          case [SPC]:
            'Either<$left, $t>';
          // case [Pipe, e = parseEither('$t')]: 'Either<$left, $e>';
          case [Pipe, e = parseType()]: 'Either<$left, $e>';
        }
    };
  }

  public function parseTypeArgs() {
    Log.print("Hey table args parsing");
    return switch stream {
      case [TypeClose]: '';
      case [DocType(Table), TypeOpen, t = parseTypeArgs()]: t;
      // @formatter:on
      case [DocType(t)]: t + '';
    };
  }

  public function parseDesc() {
    Log.print("Hey desc parsing");
    return switch stream {
      case [Description(text), EOL]:
        text;
    }
  }
}
