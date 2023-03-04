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
  try {
    var token = lexer.token(LuaLexer.tok);
    while (token.tok != Eof) {
      tokens.push(token);
      token = lexer.token(LuaLexer.tok);
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
  function compareTokens(a, b) {
    // switch ([a, b]) {
    //   case [Comment(payloadA), Comment(payloadB)]:
    //     payloadA.should.be(payloadB);
    //   case [defaultA, defaultB]:
    //     defaultA.should.equal(defaultB);
    // }
  }

  public function new() {
    // A test suite:
    describe("Lexer", {
      it("should parse the basic function", {
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
          Comment("@param func fun()"),
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

        final tokens = consumeTokens(lexer).map(token -> token.tok);

        for (idx => token in tokens) {
          token.should.equal(expected[idx]);
        }
      });

      it("should parse vim.iconv", {
        final lexer = new LuaLexer(readFixture("fixtures/vim_iconv.lua"));
        final rawTokens = consumeTokens(lexer);
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
          Comment("@param str string"),
          Newline,
          Comment("@param from number"),
          Newline,
          Comment("@param to number"),
          Newline,
          Comment("@param opts? table<string, any>"),
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

        tools.Log.print(rawTokens);
        for (idx => token in tokens) {
          token.should.equal(expected[idx]);
        }
      });
    });
  }

  static function main() {
    // final input = "
    //   -- This is a comment
    //   -- This is another comment
    //   --@param name description
    //   --@return string description
    //   function foo(name)
    //     return 'Hello ' + name;
    //   end
    //   ".ltrim();
    // final inputBytes = byte.ByteData.ofString(input);
    // final lexer = new LuaLexer(inputBytes);
    // var token = lexer.token(LuaLexer.tok);
    // while (token.tok != Eof) {
    //   token = lexer.token(LuaLexer.tok);
    // }
  }
}
