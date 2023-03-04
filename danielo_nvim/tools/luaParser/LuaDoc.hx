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
  Keyword(name:String);
  Comma;
  CurlyOpen;
  CurlyClose;
  SquareOpen;
  SquareClose;
  TypeOpen;
  TypeClose;
  EOL;
}

class LuaDocLexer extends Lexer implements hxparse.RuleBuilder {
  public static var paramDoc = @:rule [
    "[a-zA-z]+ " => {
      final name = lexer.current.rtrim();
      Identifier(name);
    },
    " " => lexer.token(paramDoc),
    "," => lexer.token(paramDoc),
    "<" => TypeOpen,
    "{" => CurlyClose,
    "}" => CurlyClose,
    "[" => SquareOpen,
    "]" => SquareClose,
    "" => EOL,
  ];
  public static var returnDoc = @:rule ["[a-zA-z]+" => {
    final type = lexer.current.ltrim();
    type;
  }];
}
