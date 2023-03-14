package tools.luaParser;

import byte.ByteData;
import tools.luaParser.Lexer;
import hxparse.ParserError.ParserError;

enum Tok {
  Function(args:Array< String >);
}

class LuaParser extends hxparse.Parser< hxparse.LexerTokenSource< Token >, Token > implements hxparse.ParserBuilder {
  public function new(input:byte.ByteData) {
    var lexer = new LuaLexer(input);
    var ts = new hxparse.LexerTokenSource(lexer, LuaLexer.tok);
    super(ts);
  }

  public function parse():Tok {
    return switch stream {
      case [{tok: Keyword(Function)}]:
        var args = parseArgs();
        Tok.Function(args);
    }
  };

  public function parseArgs():Array< String > {
    return switch stream {
      case [{tok: OpenParen}]:
        var args = parseSeparated(tok -> tok.tok == Comma, parseIdent);
        switch stream {
          case [{tok: CloseParen}]:
            args;
        }
    }
  };

  public function parseIdent() {
    return switch stream {
      case [{tok: Identifier(ident)}]:
        ident;
    }
  }
}
