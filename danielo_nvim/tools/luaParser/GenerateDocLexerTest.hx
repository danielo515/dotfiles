package tools.luaParser;

import haxe.io.Path;
import haxe.EnumTools;
import haxe.EnumTools.EnumValueTools;
import sys.io.File;
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
  final contents = '
  it("$original", {
      final lexer = new LuaDocLexer(ByteData.ofString("$fixture"));
      final actual = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
      final expected = [${expected.map(EnuP.printEnum).join(', ')}];
      for (idx => token in actual) {
        token.should.equal(expected[idx]);
      }
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
  final commentRegex = ~/-- ?@param(.*)/;
  for (line in lines) {
    if (commentRegex.match(line)) {
      comments.push({line: line, match: commentRegex.matched(1)});
    }
  }
  return comments;
}

function parseParamComment(comment:MatchStr):Array< LuaDoc.DocToken > {
  final lexer = new LuaDocLexer(ByteData.ofString(comment.match));
  final tokens = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
  return tokens;
}

function main() {
  final file = 'vim/filetype.lua';
  final commentsAsStrings = extractAllParamCommentsFromFile(file);
  final commentsAsTokens = commentsAsStrings.map(parseParamComment);
  final testCases = [for (idx => expected in commentsAsTokens) {
    final fixture = commentsAsStrings[idx];
    generateTestCase(fixture.match, fixture.line, expected);
  }];
  final testSuite = generateTestSuite(file, testCases);
  final testFile = generateTestFile([testSuite]);
  writeTextFile('tools/luaParser/LuaDocLexerTest.hx', testFile);
};
