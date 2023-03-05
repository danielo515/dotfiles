package tools.luaParser;

import hxparse.Lexer;
import haxe.io.Path;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.Lexer;
import tools.luaParser.LuaDoc;
import tools.luaParser.LuaDoc.DocToken;

using StringTools;
using buddy.Should;

@colorize
class LuaDocLexerTest extends buddy.SingleSuite {
  public function new() {
    describe("vim/filetype.lua", {
      it(" bufnr number|nil The buffer to get the lines from", {
        final lexer = new LuaDocLexer(
          ByteData.ofString(" bufnr number|nil The buffer to get the lines from")
        );
        final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
        final expected = [Identifier("bufnr"), Identifier("number")];
        for (idx => token in actual) {
          token.should.equal(expected[idx]);
        }
      });

      it(
        " start_lnum number|nil The line number of the first line (inclusive, 1-based)",
        {
          final lexer = new LuaDocLexer(
            ByteData.ofString(
              " start_lnum number|nil The line number of the first line (inclusive, 1-based)"
            )
          );
          final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
          final expected = [Identifier("start_lnum"), Identifier("number")];
          for (idx => token in actual) {
            token.should.equal(expected[idx]);
          }
        }
      );

      it(
        " end_lnum number|nil The line number of the last line (inclusive, 1-based)",
        {
          final lexer = new LuaDocLexer(
            ByteData.ofString(
              " end_lnum number|nil The line number of the last line (inclusive, 1-based)"
            )
          );
          final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
          final expected = [Identifier("end_lnum"), Identifier("number")];
          for (idx => token in actual) {
            token.should.equal(expected[idx]);
          }
        }
      );

      it(" s string The string to check", {
        final lexer = new LuaDocLexer(ByteData.ofString(" s string The string to check"));
        final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
        final expected = [
          Identifier("s"),
          Identifier("string"),
          Identifier("The"),
          Identifier("string"),
          Identifier("to"),
          Identifier("check")
        ];
        for (idx => token in actual) {
          token.should.equal(expected[idx]);
        }
      });

      it(" patterns table<string> A list of Lua patterns", {
        final lexer = new LuaDocLexer(
          ByteData.ofString(" patterns table<string> A list of Lua patterns")
        );
        final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
        final expected = [
          Identifier("patterns"),
          Identifier("table"),
          TypeOpen,
          Identifier("string"),
          TypeClose,
          Identifier("A"),
          Identifier("list"),
          Identifier("of"),
          Identifier("Lua"),
          Identifier("patterns")
        ];
        for (idx => token in actual) {
          token.should.equal(expected[idx]);
        }
      });

      it(" bufnr number The buffer to get the line from", {
        final lexer = new LuaDocLexer(
          ByteData.ofString(" bufnr number The buffer to get the line from")
        );
        final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
        final expected = [
          Identifier("bufnr"),
          Identifier("number"),
          Identifier("The"),
          Identifier("buffer"),
          Identifier("to"),
          Identifier("get"),
          Identifier("the"),
          Identifier("line"),
          Identifier("from")
        ];
        for (idx => token in actual) {
          token.should.equal(expected[idx]);
        }
      });

      it(
        " start_lnum number The line number of the first line to start from (inclusive, 1-based)",
        {
          final lexer = new LuaDocLexer(
            ByteData.ofString(
              " start_lnum number The line number of the first line to start from (inclusive, 1-based)"
            )
          );
          final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
          final expected = [
            Identifier("start_lnum"),
            Identifier("number"),
            Identifier("The"),
            Identifier("line"),
            Identifier("number"),
            Identifier("of"),
            Identifier("the"),
            Identifier("first"),
            Identifier("line"),
            Identifier("to"),
            Identifier("start"),
            Identifier("from"),
            Lparen,
            Identifier("inclusive")
          ];
          for (idx => token in actual) {
            token.should.equal(expected[idx]);
          }
        }
      );

      it(" filetypes table A table containing new filetype maps (see example).", {
        final lexer = new LuaDocLexer(
          ByteData.ofString(" filetypes table A table containing new filetype maps (see example).")
        );
        final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
        final expected = [
          Identifier("filetypes"),
          Identifier("table"),
          Identifier("A"),
          Identifier("table"),
          Identifier("containing"),
          Identifier("new"),
          Identifier("filetype"),
          Identifier("maps"),
          Lparen,
          Identifier("see"),
          Identifier("example"),
          Rparen
        ];
        for (idx => token in actual) {
          token.should.equal(expected[idx]);
        }
      });

      it(
        " args table Table specifying which matching strategy to use. Accepted keys are:",
        {
          final lexer = new LuaDocLexer(
            ByteData.ofString(
              " args table Table specifying which matching strategy to use. Accepted keys are:"
            )
          );
          final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
          final expected = [
            Identifier("args"),
            Identifier("table"),
            Identifier("Table"),
            Identifier("specifying"),
            Identifier("which"),
            Identifier("matching"),
            Identifier("strategy"),
            Identifier("to"),
            Identifier("use")
          ];
          for (idx => token in actual) {
            token.should.equal(expected[idx]);
          }
        }
      );
    });
  }
}

