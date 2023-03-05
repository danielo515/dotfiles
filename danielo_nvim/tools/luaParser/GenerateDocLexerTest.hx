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
  // final contents = macro it($v{fixture}, macro @mergeBlock {
  //   final lexer = new LuaDocLexer('$fixture');
  //   final actual = consumeTokens(lexer, LuaDocLexer.paramDoc);
  //   for (idx => token in actual) {
  //     compareTokens(token, expected[idx]);
  //   }
  // });
  final contents = 'it("$fixture", {
    final lexer = new LuaDocLexer("$fixture");
    final actual = consumeTokens(lexer, LuaDocLexer.paramDoc);
    final expected = [${expected.map(EnuP.printEnum).join(', ')}];
    for (idx => token in actual) {
      compareTokens(token, expected[idx]);
    }
  })';
  trace(contents.toString());
  return contents;
};

function generateTestSuite(referenceFile:String, testCases) {
  final contents = macro describe('$v{referenceFile}', {
    $a{testCases}
  });
  trace(contents.toString());
  return contents;
};

function generateTestFile(testSuites) {
  final contents = macro @:mergeBlock {
    // import hxparse.Lexer;
    // import haxe.io.Path;
    // import sys.io.File;
    // import byte.ByteData;
    // import tools.luaParser.Lexer;
    // import tools.luaParser.LuaDoc;
    // import tools.luaParser.Lexer.TokenDef;

    macro class LuaDocLexerTest extends buddy.SingleSuite {
      public function new() {
        $a{testSuites}
      }
    }
  };
  return contents;
}

function main() {
  final file = "lua/luadoc.lua";
  final fixture = 'foo string';
  final lexer = new LuaDocLexer(ByteData.ofString(fixture));
  final expected = ParserTest.consumeTokens(lexer, LuaDocLexer.paramDoc);
  final testCase = generateTestCase(fixture, expected);
  writeTextFile('LuaDocLexerTest', testCase);
  // final testSuite = generateTestSuite(file, [testCase]);
  // final testFile = generateTestFile([testSuite]);
  // final printer = new haxe.macro.Printer("  ");
  // // trace(printer.printExpr(testFile));
};
