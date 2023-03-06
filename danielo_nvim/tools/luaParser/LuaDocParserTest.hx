
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
      public function new() { describe("vim/filetype.lua", {
    
  it("---@param bufnr number|nil The buffer to get the lines from", {
      final parser = new LuaDocParser(ByteData.ofString("bufnr number|nil The buffer to get the lines from"));
      final actual = parser.parse();
      final expected = "{\"name\":\"bufnr\",\"description\":\"The buffer to get the lines from\",\"type\":\"Either<Number, Nil>\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param start_lnum number|nil The line number of the first line (inclusive, 1-based)", {
      final parser = new LuaDocParser(ByteData.ofString("start_lnum number|nil The line number of the first line (inclusive, 1-based)"));
      final actual = parser.parse();
      final expected = "{\"name\":\"start_lnum\",\"description\":\"The line number of the first line (inclusive, 1-based)\",\"type\":\"Either<Number, Nil>\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param end_lnum number|nil The line number of the last line (inclusive, 1-based)", {
      final parser = new LuaDocParser(ByteData.ofString("end_lnum number|nil The line number of the last line (inclusive, 1-based)"));
      final actual = parser.parse();
      final expected = "{\"name\":\"end_lnum\",\"description\":\"The line number of the last line (inclusive, 1-based)\",\"type\":\"Either<Number, Nil>\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param s string The string to check", {
      final parser = new LuaDocParser(ByteData.ofString("s string The string to check"));
      final actual = parser.parse();
      final expected = "{\"name\":\"s\",\"description\":\"The string to check\",\"type\":\"String\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param patterns table<string> A list of Lua patterns", {
      final parser = new LuaDocParser(ByteData.ofString("patterns table<string> A list of Lua patterns"));
      final actual = parser.parse();
      final expected = "{\"name\":\"patterns\",\"description\":\"A list of Lua patterns\",\"type\":\"Table<String>\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param bufnr number The buffer to get the line from", {
      final parser = new LuaDocParser(ByteData.ofString("bufnr number The buffer to get the line from"));
      final actual = parser.parse();
      final expected = "{\"name\":\"bufnr\",\"description\":\"The buffer to get the line from\",\"type\":\"Number\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param start_lnum number The line number of the first line to start from (inclusive, 1-based)", {
      final parser = new LuaDocParser(ByteData.ofString("start_lnum number The line number of the first line to start from (inclusive, 1-based)"));
      final actual = parser.parse();
      final expected = "{\"name\":\"start_lnum\",\"description\":\"The line number of the first line to start from (inclusive, 1-based)\",\"type\":\"Number\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param filetypes table A table containing new filetype maps (see example).", {
      final parser = new LuaDocParser(ByteData.ofString("filetypes table A table containing new filetype maps (see example)."));
      final actual = parser.parse();
      final expected = "{\"name\":\"filetypes\",\"description\":\"A table containing new filetype maps (see example).\",\"type\":\"Table\"}";
      Json.stringify(actual).should.be(expected);
  });
	
  it("---@param args table Table specifying which matching strategy to use. Accepted keys are:", {
      final parser = new LuaDocParser(ByteData.ofString("args table Table specifying which matching strategy to use. Accepted keys are:"));
      final actual = parser.parse();
      final expected = "{\"name\":\"args\",\"description\":\"Table specifying which matching strategy to use. Accepted keys are:\",\"type\":\"Table\"}";
      Json.stringify(actual).should.be(expected);
  });
  });
      }
    }
  