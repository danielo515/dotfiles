package tools.luaParser;

import haxe.Json;
import tools.FileTools;
import haxe.io.Path;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.LuaDoc;

using haxe.EnumTools;
using haxe.macro.ExprTools;

function readNeovimLuaFile(relativePath:String):Array< String > {
  final runtimePath = FileTools.getNvimRuntimePath();
  switch (runtimePath) {
    case Error(e):
      throw e;
    case Ok(path):
      final contents = File.getContent(Path.join([path, 'lua', relativePath]));
      return contents.split('\n');
  }
}

@:tink class EnuP {
  static public function printEnum(e:EnumValue) {
    final name = e.getName();
    final values = EnumValueTools.getParameters(e);
    if (values.length == 0) {
      return name;
    }
    return switch values[0] {
      case(v : String): '$name("$v")';
      default: '$name($values)';
    }
  }
}

function generateTestCase(fixture, original, expected) {
  // final expected = [${expected.map(EnuP.printEnum).join(', ')}];
  final contents = '
  it("$original", {
      final parser = new LuaDocParser(ByteData.ofString("$fixture"));
      final actual = parser.parse();
      final expected = Json.stringify($expected);
      Json.stringify(actual).should.be(expected);
  });';
  return contents;
};

function generateTestSuite(referenceFile:String, testCases) {
  final contents = 'describe("$referenceFile", {
    ${testCases.join("\n\t")}
  });';
  return contents;
};

function generateTestFile(testSuites) {
  final contents = '
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
      public function new() { ${testSuites.join("\n\t")}
      }
    }
  ';

  return contents;
}

typedef MatchStr = {line:String, match:String};

function extractAllParamCommentsFromFile(file:String):Array< MatchStr > {
  final lines = readNeovimLuaFile(file);
  final comments = [];
  final commentRegex = ~/-{2,3} ?@param (.*)/;
  for (line in lines) {
    if (commentRegex.match(line)) {
      comments.push({line: line, match: commentRegex.matched(1)});
    }
  }
  return comments;
}

function parseParamComment(comment:MatchStr) {
  final parser = new LuaDocParser(ByteData.ofString(comment.match));
  Log.prettyPrint("=====", comment.line);
  final parseResult = parser.parse();
  Log.prettyPrint('', parseResult);
  return parseResult;
}

function generateTestCasesForFile(filename:String) {
  final commentsAsStrings = extractAllParamCommentsFromFile(filename);
  final commentsParsed = commentsAsStrings.map(parseParamComment);
  final testCases = [for (idx => expected in commentsParsed) {
    final fixture = commentsAsStrings[idx];
    generateTestCase(fixture.match, fixture.line, Json.stringify(expected));
  }];
  return testCases;
}

function main() {
  final files = ['vim/filetype.lua', 'vim/fs.lua', 'vim/keymap.lua'];
  final testSuites = [for (file in files) {
    final testCases = generateTestCasesForFile(file);
    generateTestSuite(file, testCases);
  }];
  final testFile = generateTestFile(testSuites);
  writeTextFile('tools/luaParser/LuaDocParserTest.hx', testFile);
  // final parsed = new LuaDocParser(
  //   ByteData.ofString('bufnr string The buffer to get the lines from')
  // ).parse();
  // Log.prettyPrint("parsed", parsed);
};
