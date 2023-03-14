package tools.luaParser;

import byte.ByteData;
import tools.luaParser.Lexer;
import hxparse.ParserError.ParserError;

enum Tok {
  Function(args:Array< String >);
  CommentBlock(desc:String, luaDoc:Array< String >);
}

class LuaParser extends hxparse.Parser< hxparse.LexerTokenSource< Token >, Token > implements hxparse.ParserBuilder {
  public function new(input:byte.ByteData) {
    var lexer = new LuaLexer(input);
    var ts = new hxparse.LexerTokenSource(lexer, LuaLexer.tok);
    super(ts);
  }

  public function parse():Tok {
    return switch stream {
      case [{tok: Comment(content)}]:
        final comments = parseBlockComment(content, []);
        trace(comments);
        comments;

      case [{tok: Keyword(Function)}]:
        var args = parseArgs();
        Tok.Function(args);
    }
  };

  function parseBlockComment(description:String, luaDoc:Array< String >) {
    return switch stream {
      case [{tok: Comment(content)}]:
        parseBlockComment(description + content, []);
      case [{tok: LuaDocParam(param)}]:
        luaDoc.push(param);
        parseBlockComment(description, luaDoc);
      case _: CommentBlock(description, luaDoc);
    }
  }

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
