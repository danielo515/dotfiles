package tools.luaParser;

import hxparse.Lexer;

using StringTools;
using Safety;

typedef Param = {
  final type:String;
  final description:String;
}

enum DocType {
  Function;
  Number;
  String;
  Table;
  Boolean;
}

enum DocToken {
  Identifier(name:String);
  Description(text:String);
  ArrayMod;
  OptionalMod;
  DocType(type:DocType);
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
  EOL;
}

class LuaDocLexer extends Lexer implements hxparse.RuleBuilder {
  public static var desc = @:rule ["[^\n]*" => Description(lexer.current),];
  public static var paramDoc = @:rule [
    "[a-zA-z]+" => {
      final name = lexer.current;
      Identifier(name);
    },
    " +" => lexer.token(paramDoc),
  ];
  public static var typeDoc = @:rule [
    " " => lexer.token(typeDoc),
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
    "" => null,
  ];
}

class LuaDocParser extends hxparse.Parser< hxparse.LexerTokenSource< DocToken >, DocToken > implements hxparse.ParserBuilder {
  public function new(input:byte.ByteData) {
    var lexer = new LuaDocLexer(input);
    var ts = new hxparse.LexerTokenSource(lexer, LuaDocLexer.paramDoc);
    super(ts);
  }

  public function parse() {
    return switch stream {
      case [
        Identifier(name),
        t = parseType(),
        Description(text),
        EOL
      ]:
        return [name, t, text];
    }
  }

  public function parseType() {
    return switch stream {
      case [CurlyOpen, t = parseType(), CurlyClose,]:
        t + "";
      case [DocType(t), Pipe, t2 = parseType()]:
        'Either($t, $t2)';
      case [DocType(t)]:
        t + "";
    }
  }
}
