package tools.luaParser;

import hxparse.Lexer;
import haxe.io.Path;
import haxe.Json;
import sys.io.File;
import byte.ByteData;
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
    describe("Lua Lexer", {
      it("should parse the basic function", {
        final parser = new LuaParser(readFixture("fixtures/basic_fn.lua"));
        final expectedDescription = [
          "Invokes |vim-function| or |user-function| {func} with arguments {...}.",
          "See also |vim.fn|.",
          "Equivalent to:",
          "```lua",
          "    vim.fn[func]({...})",
          "```",
        ].join('\n');
        final actual = parser.parse();
        switch (actual) {
          case FunctionWithDocs(def):
            def.name.should.be("call");
            def.args.should.containExactly(["func", "kwargs"]);
            def.namespace.should.containExactly(["vim"]);
            Json.stringify(def.typedArgs).should.be(Json.stringify([{
              name: "func",
              description: "",
              isOptional: false,
              type: "Function"
            }]));
            def.description.should.be(expectedDescription);
          case _: fail("Expected function with docs");
        }
      });

      it("should lex vim.iconv", {
        final parser = new LuaParser(readFixture("fixtures/vim_iconv.lua"));
        final expected = [];
        final actual = parser.parse();
      });
      it("should lex filetype_getLInes", {
        final parser = new LuaParser(readFixture("fixtures/filetype_getLInes.lua"));
        final expected = [];
        final actual = parser.parse();
      });
    });
  }
}
