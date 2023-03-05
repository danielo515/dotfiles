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
  final basePath = FileTools.getNvimRuntimePath() + '/lua/' + relativePath;
  final contents = File.getContent(Path.join([basePath, 'lua', relativePath]));
  return contents.split('\n');
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

function generateTestCase(fixture, expected) {
  final contents = '
  it("$fixture", {
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
  final contents = '
  describe("$referenceFile", {
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
    import tools.luaParser.Lexer.TokenDef;

    using StringTools;
    using buddy.Should;

    class LuaDocLexerTest extends buddy.SingleSuite {
      public function new() {
        ${testSuites.join("\n\t")}
      }
    }
  ';

  return contents;
}

function main() {
  final file = "lua/luadoc.lua";
  final fixture = 'foo string';
  final lexer = new LuaDocLexer(ByteData.ofString(fixture));
  final expected = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
  final testCase = generateTestCase(fixture, expected);
  final testSuite = generateTestSuite(file, [testCase]);
  final testFile = generateTestFile([testSuite]);
  writeTextFile('tools/luaParser/LuaDocLexerTest.hx', testFile);
};
