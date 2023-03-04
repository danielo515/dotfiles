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
    trace(tokens);
    throw e;
  }
}

@colorize
class ParserTest extends buddy.SingleSuite {
  // function compareTokens(a:TokenDef, b:TokenDef) {
  //   switch ([a, b]) {
  //     case [Comment(payloadA), Comment(payloadB)]:
  //       payloadA.should.be(payloadB);
  //     case [defaultA, defaultB]:
  //       defaultA.should.equal(defaultB);
  //   }
  // }
  public function new() {
    function compareTokens(a:TokenDef, b:TokenDef) {
      switch ([a, b]) {
        case [LuaDocParam(a), LuaDocParam(b)]:
          a.should.be(b);
        case [defaultA, defaultB]:
          defaultA.should.equal(defaultB);
      }
    }
    describe("Doc lexer", {
      it("should lex the param comments", {
        final suite:Map< String, Array< LuaDoc.DocToken > > = ["func fun()" => [DocToken.Identifier(
          "func"
        ), Identifier("fun")]];
        for (string => expected in suite) {
          final lexer = new LuaDocLexer(ByteData.ofString(string));
          final tokens = consumeTokens(lexer, LuaDocLexer.paramDoc);
          for (idx => token in tokens) {
            token.should.equal(expected[idx]);
          }
        }
      });
    });
    describe("Lua Lexer", {
      it("should lex the basic function", {
        final lexer = new LuaLexer(readFixture("fixtures/basic_fn.lua"));
        final expected = [
          Comment("Invokes |vim-function| or |user-function| {func} with arguments {...}."),
          Newline,
          Comment("See also |vim.fn|."),
          Newline,
          Comment("Equivalent to:"),
          Newline,
          Comment("```lua"),
          Newline,
          Comment("vim.fn[func]({...})"),
          Newline,
          Comment("```"),
          Newline,
          LuaDocParam("func fun()"),
          Newline,
          Keyword(Function),
          Identifier("vim.call"),
          Rparen,
          Identifier("func"),
          ThreeDots,
          Lparen,
          Keyword(End),
          Newline
        ];

        final rawTokens = consumeTokens(lexer, LuaLexer.tok);
        final tokens = rawTokens.map(token -> token.tok);

        for (idx => token in tokens) {
          compareTokens(token, expected[idx]);
        }
      });

      it("should lex vim.iconv", {
        final lexer = new LuaLexer(readFixture("fixtures/vim_iconv.lua"));
        final rawTokens = consumeTokens(lexer, LuaLexer.tok);
        final tokens = rawTokens.map(token -> token.tok);
        final expected = [
          Comment("The result is a String, which is the text {str} converted from"),
          Newline,
          Comment("encoding {from} to encoding {to}. When the conversion fails `nil` is"),
          Newline,
          Comment("returned.  When some characters could not be converted they"),
          Newline,
          Comment('are replaced with "?".'),
          Newline,
          Comment("The encoding names are whatever the iconv() library function"),
          Newline,
          Comment('can accept, see ":Man 3 iconv".'),
          Newline,
          Comment("-- Parameters: ~"),
          Newline,
          Comment("• {str}   (string) Text to convert"),
          Newline,
          Comment("• {from}  (string) Encoding of {str}"),
          Newline,
          Comment("• {to}    (string) Target encoding"),
          Newline,
          Comment("-- Returns: ~"),
          Newline,
          Comment("Converted string if conversion succeeds, `nil` otherwise."),
          Newline,
          LuaDocParam("str string"),
          Newline,
          LuaDocParam("from number"),
          Newline,
          LuaDocParam("to number"),
          Newline,
          LuaDocParam("opts? table<string, any>"),
          Newline,
          Keyword(Function),
          Identifier("vim.iconv"),
          Rparen,
          Identifier("str"),
          Identifier("from"),
          Identifier("to"),
          Identifier("opts"),
          Lparen,
          Keyword(End),
          Newline
        ];

        for (idx => token in tokens) {
          compareTokens(token, expected[idx]);
        }
      });
    });
  }
}
