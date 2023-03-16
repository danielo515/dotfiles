package tools.luaParser;

import hxparse.Lexer;
import haxe.macro.Expr.Position;

using StringTools;
using Safety;

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

enum TokenDef {
  Eof;
  Comment(content:String);
  LuaDocParam(content:String);
  LuaDocReturn(content:String);
  Keyword(k:LKeyword);
  Identifier(name:String);
  Namespace(name:String);
  Str(content:String);
  Newline;
  OpenParen;
  CloseParen;
  CurlyOpen;
  CurlyClose;
  SquareOpen;
  SquareClose;
  ThreeDots;
  Comma;
  Colon;
  Equal;
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
    return switch (tok) {
      case Comment(content): 'Comment("$content")';
      case LuaDocParam(content): 'LuaDocParam("$content")';
      case LuaDocReturn(doc): 'LuaDocReturn("$doc")';
      case Keyword(k): 'Keyword($k)';
      case Identifier(name): 'Identifier("$name")';
      case Str(content): 'Str("$content")';
      case other:
        '$other';

        // case Newline: 'Newline';
        // case OpenParen: '(';
        // case CloseParen: ')';
        // case ThreeDots: 'ThreeDots';
        // case Eof: 'Eof';
        // case CurlyOpen: '{';
        // case CurlyClose: '}';
        // case SquareOpen: '[';
        // case SquareClose: ']';
        // case Comma: '","';
        // case Equal: '"="';
    }
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

  static final identifier_ = "[a-zA-Z_][a-zA-Z0-9_]*";

  public static var consumeLine = @:rule ["[^\n]+" => lexer.current];
  // @:rule wraps the expression to the right of => with function(lexer) return
  public static var tok = @:rule [
    "return" => {
      // I don't care about this things, so I just consume them
      lexer.token(consumeLine);
      lexer.token(tok);
    },
    "[+;\\-]" => lexer.token(tok), // Yes, I ignore all this crap
    "\\.\\.\\." => mk(lexer, ThreeDots),
    "\n\n" => mk(lexer, Newline),
    "\n" => lexer.token(tok),
    "[\t ]+" => {
      var space = lexer.current;
      var token:Token = lexer.token(tok);
      token.space = space;
      token;
    },
    "\\{" => mk(lexer, CurlyOpen),
    "\\}" => mk(lexer, CurlyClose),
    "\\(" => mk(lexer, OpenParen),
    "\\)" => mk(lexer, CloseParen),
    "," => mk(lexer, Comma),
    "=" => mk(lexer, Equal),
    ":" => mk(lexer, Colon),
    "'" => {
      final content = lexer.token(string);
      mk(lexer, Str(content));
    },
    "\"" => {
      final content = lexer.token(doubleQuotedString);
      mk(lexer, Str(content));
    },
    identifier_ + "\\." => { // Path access
      final content = lexer.current;
      mk(lexer, Namespace(content.replace(".", "")));
    },
    identifier_ => {
      final content = lexer.current;
      final keyword = luaKeywords.get(content);
      if (keyword != null) {
        mk(lexer, Keyword(keyword));
      } else {
        mk(lexer, Identifier(content));
      }
    },
    "--- ?@param" => {
      final content = lexer.token(consumeLine);
      mk(lexer, LuaDocParam(content));
    },
    "--- ?@return" => {
      final content = lexer.token(consumeLine);
      mk(lexer, LuaDocReturn(content));
    },
    "---?[^@]" => {
      final content = lexer.token(consumeLine);
      mk(lexer, Comment(content));
    },
    "" => null,
  ];
  public static var string = @:rule ["[^']+" => {
    final content = lexer.current;
    content + lexer.token(string);
  }, "'" => ""];
  public static var doubleQuotedString = @:rule ["[^\"]+" => {
    final content = lexer.current;
    content + lexer.token(string);
  }, "\"" => ""];
}
