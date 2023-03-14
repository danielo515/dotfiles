package tools.luaParser;

import hxparse.Lexer;
import haxe.io.Path;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.Lexer;
import tools.luaParser.LuaDoc;
import tools.luaParser.Lexer.TokenDef;

using StringTools;
using buddy.Should;

function readFixture(path:String):ByteData {
  final file = File.read(Path.join([Sys.getCwd(), "tools", "luaParser", path]), false).readAll();
  return byte.ByteData.ofBytes(file);
}

function consumeTokens< T >(lexer:Lexer, tok):Array< T > {
  var tokens = [];
  try {
    var token = lexer.token(tok);
    while (token != null) {
      tokens.push(token);
      token = lexer.token(tok);
    }
    return tokens;
  }
  catch (e:Dynamic) {
    trace("Error parsing", e);
    trace("Dumping tokens:");
    return tokens;
  }
}

function dumpComments(tokens:Array< TokenDef >) {
  for (token in tokens) {
    switch (token) {
      case LuaDocParam(payload):
        Log.print('"$payload",');
      case _:
    }
  }
}

@colorize
class ParserTest extends buddy.SingleSuite {
  public function new() {
    function compareTokens(a:TokenDef, b:TokenDef) {
      switch ([a, b]) {
        case [LuaDocParam(a), LuaDocParam(b)]:
          a.should.be(b);
        case [defaultA, defaultB]:
          defaultA.should.equal(defaultB);
      }
    }
    describe("Lua Lexer", {
      it("should parse the basic function", {
        final parser = new LuaParser(readFixture("fixtures/basic_fn.lua"));
        final expected = [];
        final actual = parser.parse();
        trace(actual);
      });

      it("should lex vim.iconv", {
        final parser = new LuaParser(readFixture("fixtures/vim_iconv.lua"));
        final expected = [];
        final actual = parser.parse();
        trace(actual);
      });
      it("should lex filetype_getLInes", {
        final parser = new LuaParser(readFixture("fixtures/filetype_getLInes.lua"));
        final expected = [];
        final actual = parser.parse();
        Log.print(actual);
      });
    });
  }
}
