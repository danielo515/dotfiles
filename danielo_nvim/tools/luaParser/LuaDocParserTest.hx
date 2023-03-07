package tools.luaParser;

import byte.ByteData;
import haxe.Json;
import tools.luaParser.Lexer;
import tools.luaParser.LuaDoc;
import tools.luaParser.LuaDoc.DocToken;

using StringTools;
using buddy.Should;

@colorize
class LuaDocParserTest extends buddy.SingleSuite {
  public function new() {
    describe("vim/filetype.lua", {
      it("---@param bufnr number|nil The buffer to get the lines from", {
        final parser = new LuaDocParser(
          ByteData.ofString("bufnr number|nil The buffer to get the lines from")
        );
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "bufnr", "description": "The buffer to get the lines from", "type": "Either<Number, Nil>"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param start_lnum number|nil The line number of the first line (inclusive, 1-based)",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "start_lnum number|nil The line number of the first line (inclusive, 1-based)"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify(
            {"name": "start_lnum", "description": "The line number of the first line (inclusive, 1-based)", "type": "Either<Number, Nil>"}
          );
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param end_lnum number|nil The line number of the last line (inclusive, 1-based)",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "end_lnum number|nil The line number of the last line (inclusive, 1-based)"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify(
            {"name": "end_lnum", "description": "The line number of the last line (inclusive, 1-based)", "type": "Either<Number, Nil>"}
          );
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param s string The string to check", {
        final parser = new LuaDocParser(ByteData.ofString("s string The string to check"));
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "s", "description": "The string to check", "type": "String"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it("---@param patterns table<string> A list of Lua patterns", {
        final parser = new LuaDocParser(
          ByteData.ofString("patterns table<string> A list of Lua patterns")
        );
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "patterns", "description": "A list of Lua patterns", "type": "Table<String>"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it("---@param bufnr number The buffer to get the line from", {
        final parser = new LuaDocParser(
          ByteData.ofString("bufnr number The buffer to get the line from")
        );
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "bufnr", "description": "The buffer to get the line from", "type": "Number"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param start_lnum number The line number of the first line to start from (inclusive, 1-based)",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "start_lnum number The line number of the first line to start from (inclusive, 1-based)"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify(
            {"name": "start_lnum", "description": "The line number of the first line to start from (inclusive, 1-based)", "type": "Number"}
          );
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param filetypes table A table containing new filetype maps (see example).",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "filetypes table A table containing new filetype maps (see example)."
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify(
            {"name": "filetypes", "description": "", "type": "Table"}
          );
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param args table Table specifying which matching strategy to use. Accepted keys are:",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "args table Table specifying which matching strategy to use. Accepted keys are:"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({"name": "args", "description": "", "type": "Table"});
          Json.stringify(actual).should.be(expected);
        }
      );
    });
    describe("vim/fs.lua", {
      it("---@param start (string) Initial file or directory.", {
        final parser = new LuaDocParser(
          ByteData.ofString("start (string) Initial file or directory.")
        );
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "start", "description": "Initial file or directory.", "type": "String"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it("---@param file (string) File or directory", {
        final parser = new LuaDocParser(ByteData.ofString("file (string) File or directory"));
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "file", "description": "File or directory", "type": "String"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it("---@param file (string) File or directory", {
        final parser = new LuaDocParser(ByteData.ofString("file (string) File or directory"));
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "file", "description": "File or directory", "type": "String"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param path (string) An absolute or relative path to the directory to iterate",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "path (string) An absolute or relative path to the directory to iterate"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify(
            {"name": "path", "description": "An absolute or relative path to the directory to iterate", "type": "String"}
          );
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param names (string|table|fun(name: string): boolean) Names of the files",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("names (string|table|fun(name: string): boolean) Names of the files")
          );
          final actual = parser.parse();
          final expected = Json.stringify(
            {"name": "names", "description": "Names of the files", "type": "Either<String, FunctionWithArgs(name: String):Boolean>"}
          );
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param opts (table) Optional keyword arguments:", {
        final parser = new LuaDocParser(
          ByteData.ofString("opts (table) Optional keyword arguments:")
        );
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "opts", "description": "Optional keyword arguments:", "type": "Table"}
        );
        Json.stringify(actual).should.be(expected);
      });

      it("---@param path (string) Path to normalize", {
        final parser = new LuaDocParser(ByteData.ofString("path (string) Path to normalize"));
        final actual = parser.parse();
        final expected = Json.stringify(
          {"name": "path", "description": "Path to normalize", "type": "String"}
        );
        Json.stringify(actual).should.be(expected);
      });
    });
  }
}
