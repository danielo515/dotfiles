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

class LuaDocLexerTest extends buddy.SingleSuite {
  public function new() {
    describe("lua/luadoc.lua", {
      it("foo string", {
        final lexer = new LuaDocLexer(ByteData.ofString("foo string"));
        final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
        final expected = [Identifier("foo"), Identifier("string")];
        for (idx => token in actual) {
          token.should.equal(expected[idx]);
        }
      });
    });
  }
}

