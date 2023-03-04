package tools.luaParser;

import tools.luaParser.Lexer;
import tools.luaParser.Lexer.TokenDef;
import haxe.io.*;

class ParserTest {
  static function main() {
    final input = "
      -- This is a comment
      -- This is another comment
      --@param name description
      --@return string description
      function foo(name)
        return 'Hello ' + name;
      end
      ";
    final inputBytes = byte.ByteData.ofString(input);
    final lexer = new LuaLexer(inputBytes);
    var token = lexer.token(LuaLexer.tok);
    while (token.tok != Eof) {
      trace(token);
      token = lexer.token(LuaLexer.tok);
    }
  }
}
