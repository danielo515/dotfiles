package tools.luaParser;

/**
  This is a very specific parser for Lua files within the NeoVim context.
  It is used to extract function signatures from Lua files for use in haxe-nvim.
  It is not meant to be able to parse real Lua code, or do any smart inference around it.
  It will only parse top level functions, and will not parse any nested code, that will be ignored.
**/
import byte.ByteData;
import tools.luaParser.Lexer;
import tools.luaParser.LuaDoc;
import hxparse.ParserError.ParserError;

typedef FunctionDefinition = {
  name:String,
  namespace:Array< String >,
  args:Array< String >,
  typedArgs:Array< ParamDoc >,
  description:String
};

enum Tok {
  FunctionWithDocs(definition:FunctionDefinition);
  CommentBlock(desc:String, luaDoc:Array< String >);
}

class LuaParser extends hxparse.Parser< hxparse.LexerTokenSource< Token >, Token > implements hxparse.ParserBuilder {
  final input:ByteData;

  public function new(input:byte.ByteData, sourceName = "") {
    this.input = input;
    var lexer = new LuaLexer(input, sourceName);
    var ts = new hxparse.LexerTokenSource(lexer, LuaLexer.tok);
    super(ts);
  }

  function dumpAtCurrent() {
    ParseDump.dumpAtCurrent(stream.curPos(), this.input, this.last.toString());
  }

  final public function parse():Tok {
    try {
      while (true) {
        switch stream {
          case [{tok: Comment(content)}]:
            final comments = parseBlockComment([content], []);
            final func = parseOptional(parseFunction);
            if (func == null) {
              Log.print('Ignoring comment block');
              continue;
            }
            return FunctionWithDocs({
              name: func.name,
              namespace: func.namespace,
              args: func.args,
              typedArgs: comments.luaDoc,
              description: comments.description
            });
          case [{tok: Eof}]:
            return null;
          case [x]:
            Log.print('Ignoring top level token: "$x"');
            continue;
        }
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
      case [{tok: Keyword(Local)},]:
        switch stream {
          case [
            {tok: Keyword(Function)},
            ident = parseNamespacedIdent([])
          ]:
            final args = parseArgs();
            ignoreFunctionBody(1);
            {name: ident.name, namespace: ident.namespace, args: args};
        }
      case [
        {tok: Keyword(Function)},
        ident = parseNamespacedIdent([])
      ]:
        final args = parseArgs();
        ignoreFunctionBody(1);
        {name: ident.name, namespace: ident.namespace, args: args};
    }
  }

  /**
    I told you at the top of the file, we only parse top level stuff.
    This will ignore everytihing withint the function body, even other functions
   */
  public function ignoreFunctionBody(nestLevel:Int) {
    return switch stream {
      case [
        {tok: Keyword(If | For | While | Until | Function)}
      ]:
        ignoreFunctionBody(nestLevel + 1);
      case [{tok: Keyword(End)}]:
        if (nestLevel == 1) {
          return;
        }
        ignoreFunctionBody(nestLevel - 1);
      // just doing `case _:` does not consume the token
      case [_]:
        ignoreFunctionBody(nestLevel);
    }
  }

  function parseBlockComment(description:Array< String >, luaDoc:Array< ParamDoc >) {
    return switch stream {
      case [{tok: Comment(content)}]:
        description.push(content);
        parseBlockComment(description, []);
      case [{tok: LuaDocParam(param)}]:
        final paramParsed = new LuaDocParser(ByteData.ofString(param)).parse();
        luaDoc.push(paramParsed);
        parseBlockComment(description, luaDoc);
      case [{tok: LuaDocReturn(content)}]:
        // luaDoc.push(content);
        Log.print('LuaDocReturn: "$content"');
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

  public function parseIdent():String {
    return switch stream {
      case [{tok: ThreeDots}]:
        "kwargs";
      case [{tok: Identifier(name)}]:
        name;
    }
  }

  public function parseNamespacedIdent(namespace:Array< String >) {
    return switch stream {
      case [{tok: Namespace(name)}]:
        parseNamespacedIdent(namespace.concat([name]));
      case [name = parseIdent()]:
        {name: name, namespace: namespace};
    }
  }
}
