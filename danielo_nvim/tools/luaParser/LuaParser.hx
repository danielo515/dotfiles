package tools.luaParser;

/**
  This is a very specific parser for Lua files within the NeoVim context.
  It is used to extract function signatures from Lua files for use in haxe-nvim.
  It is not meant to be able to parse real Lua code, or do any smart inference around it.
  It will only parse top level functions, and will not parse any nested code, that will be ignored.
**/
import byte.ByteData;
import tools.luaParser.Lexer;
import hxparse.ParserError.ParserError;

enum Tok {
  Function(name:String, args:Array< String >);
  FunctionWithDocs(name:String, args:Array< String >, description:String, luaDoc:Array< String >);
  CommentBlock(desc:String, luaDoc:Array< String >);
}

class LuaParser extends hxparse.Parser< hxparse.LexerTokenSource< Token >, Token > implements hxparse.ParserBuilder {
  final input:ByteData;

  public function new(input:byte.ByteData) {
    this.input = input;
    var lexer = new LuaLexer(input);
    var ts = new hxparse.LexerTokenSource(lexer, LuaLexer.tok);
    super(ts);
  }

  function dumpAtCurrent() {
    ParseDump.dumpAtCurrent(stream.curPos(), this.input, this.last.toString());
  }

  public function parse():Tok {
    return try {
      switch stream {
        case [{tok: Comment(content)}]:
          final comments = parseBlockComment([content], []);
          final func = parseFunction();
          FunctionWithDocs(func.name, func.args, comments.description, comments.luaDoc);
      }
    }
    catch (e:ParserError) {
      Log.print('Parser error: "$e"');
      dumpAtCurrent();
      throw e;
    }
  };

  public function parseFunction() {
    return switch stream {
      case [{tok: Keyword(Function)}, {tok: Identifier(name)}]:
        final args = parseArgs();
        {name: name, args: args};
    }
  }

  function parseBlockComment(description:Array< String >, luaDoc:Array< String >) {
    return switch stream {
      case [{tok: Comment(content)}]:
        description.push(content);
        parseBlockComment(description, []);
      case [{tok: LuaDocParam(param)}]:
        luaDoc.push(param);
        parseBlockComment(description, luaDoc);
      case [{tok: LuaDocReturn(content)}]:
        luaDoc.push(content);
        parseBlockComment(description, luaDoc);
      case _: {description: description.join('\n'), luaDoc: luaDoc};
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
      case [{tok: ThreeDots}]:
        "kwargs";
      case [{tok: Identifier(ident)}]:
        ident;
    }
  }
}
