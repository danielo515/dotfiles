package tools.luaParser;

import haxe.io.Path;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.Lexer;
import tools.luaParser.Lexer.TokenDef;

using StringTools;
using buddy.Should;

function readFixture(path:String):ByteData {
  final file = File.read(Path.join([Sys.getCwd(), "tools", "luaParser", path]), false).readAll();
  return byte.ByteData.ofBytes(file);
}

function consumeTokens(lexer:LuaLexer):Array< Token > {
  var tokens = [];
  var token = lexer.token(LuaLexer.tok);
  while (token.tok != Eof) {
    tokens.push(token);
    token = lexer.token(LuaLexer.tok);
  }
  return tokens;
}

class ParserTest extends buddy.SingleSuite {
  public function new() {
    // A test suite:
    describe("Lexer", {
      final lexer = new LuaLexer(readFixture("fixtures/basic_fn.lua"));

      it("should parse the basic function", {
        final tokens = consumeTokens(lexer);
        tokens.length.should.be(12);
      });
    });
  }

  static function main() {
    final input = "
      -- This is a comment
      -- This is another comment
      --@param name description
      --@return string description
      function foo(name)
        return 'Hello ' + name;
      end
      ".ltrim();
    final inputBytes = byte.ByteData.ofString(input);
    final lexer = new LuaLexer(inputBytes);
    var token = lexer.token(LuaLexer.tok);
    while (token.tok != Eof) {
      trace(token);
      token = lexer.token(LuaLexer.tok);
    }
  }
}
