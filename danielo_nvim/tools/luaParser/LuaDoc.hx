package tools.luaParser;

import hxparse.Lexer;

using StringTools;
using Safety;

typedef Param = {
  final type:String;
  final description:String;
}

enum DocToken {
  Identifier(name:String);
  ArrayMod;
  OptionalMod;
  Keyword(name:String);
  Comma;
  CurlyOpen;
  CurlyClose;
  SquareOpen;
  SquareClose;
  Lparen;
  Rparen;
  TypeOpen;
  TypeClose;
  EOL;
}

class LuaDocLexer extends Lexer implements hxparse.RuleBuilder {
  public static var paramDoc = @:rule [
    "[a-zA-z]+" => {
      final name = lexer.current;
      Identifier(name);
    },
    " " => lexer.token(paramDoc),
    "," => lexer.token(paramDoc),
    "\\[\\]" => ArrayMod,
    "\\?" => OptionalMod,
    "<" => TypeOpen,
    ">" => TypeClose,
    "{" => CurlyClose,
    "}" => CurlyClose,
    "[" => SquareOpen,
    "]" => SquareClose,
    "\\(" => Lparen,
    "\\)" => Rparen,
    "" => null,
  ];
}
