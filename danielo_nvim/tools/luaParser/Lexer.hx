package tools.luaParser;

import hxparse.Lexer;
import haxe.macro.Expr.Position;

using StringTools;

enum LKeyword {
  And;
  Break;
  Do;
  Else;
  Elseif;
  End;
  False;
  For;
  Function;
  Goto;
  If;
  In;
  Local;
  Nil;
  Not;
  Or;
  Repeat;
  Return;
  Then;
  True;
  Until;
  While;
}

final luaKeywords:Map< String, LKeyword > = [
  "and" => LKeyword.And,
  "break" => LKeyword.Break,
  "do" => LKeyword.Do,
  "else" => LKeyword.Else,
  "elseif" => LKeyword.Elseif,
  "end" => LKeyword.End,
  "false" => LKeyword.False,
  "for" => LKeyword.For,
  "function" => LKeyword.Function,
  "goto" => LKeyword.Goto,
  "if" => LKeyword.If,
  "in" => LKeyword.In,
  "local" => LKeyword.Local,
  "nil" => LKeyword.Nil,
  "not" => LKeyword.Not,
  "or" => LKeyword.Or,
  "repeat" => LKeyword.Repeat,
  "return" => LKeyword.Return,
  "then" => LKeyword.Then,
  "true" => LKeyword.True,
  "until" => LKeyword.Until,
  "while" => LKeyword.While,
];

typedef LuaDocRaw = {
  final type:String;
  final description:String;
}

enum TokenDef {
  Eof;
  Comment(content:String);
  LuaDocParam(name:String, doc:LuaDocRaw);
  LuaDocReturn(doc:LuaDocRaw);
  Newline;
  Keyword(k:LKeyword);
  Identifier(name:String);
  Lparen;
  Rparen;
  Str(content:String);
}

class Token {
  public var tok:TokenDef;
  public var pos:Position;
  public var space = "";

  public function new(tok, pos) {
    this.tok = tok;
    this.pos = pos;
  }

  public function toString() {
    return tok;
  }
}

class LuaLexer extends Lexer implements hxparse.RuleBuilder {
  static function mkPos(p:hxparse.Position) {
    return {
      file: p.psource,
      min: p.pmin,
      max: p.pmax
    };
  }

  static function mk(lexer:Lexer, td) {
    return new Token(td, mkPos(lexer.curPos()));
  }

  public static var consumeLine = @:rule ["[^\n]+" => lexer.current.ltrim()];
  // @:rule wraps the expression to the right of => with function(lexer) return
  public static var tok = @:rule [
    "[+;\\-]" => lexer.token(tok), // Yes, I ignore all this crap
    "" => mk(lexer, Eof),
    "\n" => mk(lexer, Newline),
    "[\t ]+" => {
      var space = lexer.current;
      var token:Token = lexer.token(tok);
      token.space = space;
      token;
    },
    "\\(" => mk(lexer, Rparen),
    "\\)" => mk(lexer, Lparen),
    "," => lexer.token(tok),
    "'" => {
      final content = lexer.token(string);
      mk(lexer, Str(content));
    },
    "\"" => {
      final content = lexer.token(doubleQuotedString);
      mk(lexer, Str(content));
    },
    "[a-zA-Z_][a-zA-Z0-9_]*" => {
      final content = lexer.current;
      final keyword = luaKeywords.get(content);
      if (keyword != null) {
        mk(lexer, Keyword(keyword));
      } else {
        mk(lexer, Identifier(content));
      }
    },
    "--[^@]" => {
      final content = lexer.token(consumeLine);
      mk(lexer, Comment(content));
    },
    "--@param" => {
      final content = lexer.token(consumeLine);
      mk(
        lexer,
        LuaDocParam(
          content.split(" ")[0],
          {type: content.split(" ")[1], description: content.split(" ")[2]}
        )
      );
    },
    "--@return" => {
      final content = lexer.token(returnDoc);
      mk(lexer, LuaDocReturn(content));
    },
  ];

  public static var string = @:rule ["[^']+" => {
    final content = lexer.current;
    content + lexer.token(string);
  }, "'" => ""];

  public static var doubleQuotedString = @:rule ["[^\"]+" => {
    final content = lexer.current;
    content + lexer.token(string);
  }, "\"" => ""];

  public static var returnDoc = @:rule [" [a-zA-z]+" => {
    final type = lexer.current.ltrim();
    final description = lexer.token(consumeLine);
    ({type: type, description: description} : LuaDocRaw);
  }];
}
