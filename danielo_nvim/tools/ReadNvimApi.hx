import haxe.Json;
import tools.Result;
import tools.GitRepo;
import tools.Cmd;
import haxe.io.Path;
import sys.io.Process;
import sys.io.File;
import org.msgpack.MsgPack;

using Lambda;
using StringTools;

typedef ApiData = {
  final functions:Array< {name:String, return_type:String, deprecated_since:Null< Int >} >;
}

function capitalize(value:String):String {
  return value.charAt(0).toUpperCase() + value.substr(1);
}

function prettyPrint(?msg, data:Dynamic) {
  Sys.println(msg);
  Sys.println(Json.stringify(data, null, "  "));
}

typedef FunctionBlock = {
  final docs:Array< String >;
  var parameters:Array< Array< String > >;
  var return_type:String;
  final annotations:Array< String >;
  var name:String;
  var fullyQualified_name:String;
}

enum Annotation {
  Return(type:String);
  Param(name:String, type:String);
  Optional(name:String, type:String);
}

typedef AnnotationMap = Map< String, Annotation >;

@:tink class AnnotationParser {
  final getPath:String -> String;

  public function new(getPath) {
    this.getPath = getPath;
  }

  function getFunctionBlocks(file) {
    final path = getPath(file);
    final file = File.read(path, false).readAll().toString();
    return file.split("\n\n").filter(x -> x != "" && x != "---@meta").map(x -> x.split("\n"));
  }

  static function formatTypeStr(type:String) {
    return switch (type) {
      case 'any[]':
        'Array<Dynamic>';
      case 'number[]':
        'Array<Int>';
      case '$kind[]':
        'Array<$kind>';
      case 'any': 'Dynamic';
      case 'number': 'Int';
      case 'table<string, any>': 'Table<String, Dynamic>';
      case 'table<string, $b>': 'Table<String, ${capitalize(b)}>';
      case 'fun()': 'Function';
      case 'boolean': 'Bool';
      case value: capitalize(value);
    }
  }

  static function parseAnnotations(annotations:Array< String >):AnnotationMap {
    var result = new Map();

    return annotations.fold((annotation, parsed:AnnotationMap) -> {
      final returnRegex = ~/@return (.*)/i;
      final paramRegex = ~/@param ([^ ]*)(.*)/i;
      final paramWithParens = ~/@param ([^ ]*) \(([^\)]*)\)(.*)/i;

      switch (annotation) {
        case returnRegex.match(_) => true:
          parsed.set("return", Return(formatTypeStr(returnRegex.matched(1))));
        case paramWithParens.match(_) => true:
          final paramName = paramWithParens.matched(1);
          final paramType = formatTypeStr(paramWithParens.matched(2).trim());
          parsed.set(paramName, Param(paramName, paramType));
        case paramRegex.match(_) => true:
          final paramName = paramRegex.matched(1);
          final paramType = formatTypeStr(paramRegex.matched(2).trim());
          switch (paramName) {
            case '$name?':
              parsed.set(name, Optional(name, paramType));
            case name: parsed.set(name, Param(name, paramType));
          }
        case _: "";
      }

      return parsed;
    }, result);
  }

  static function parseFunctionArgs(annotations:AnnotationMap, args) {
    final args:Array< String > = args.split(',').map(StringTools.trim);
    return switch (args) {
      case [''] | []:
        [];
      case args:
        args.map(x -> switch (annotations.get(x)) {
          case Optional(name, type): ['Null<$type>', name];
          case Param(name, type): [type, name];
          case _: ['Dynamic', x];
        });
    }
  }

  static function parseFunctionBlock(result:FunctionBlock, lines:Array< String >) {
    final regexFn = ~/function ([A-Z._0-9]+)\(([^)]*)/i;
    final weirdFn = ~/\["([^"]*)"\] = function ?\(([^)]*)/i;
    return switch (lines) {
      case []:
        return result;
      case [line, @rest rest]:
        switch (line) {
          case ~/^--- ?@/:
            result.annotations.push(line.substr(3));
            return parseFunctionBlock(result, rest);
          case ~/^---? /:
            result.docs.push(line.substr(3));
            return parseFunctionBlock(result, rest);
          case regexFn.match(_) => true:
            final parsedAnnotations = parseAnnotations(result.annotations);
            final fullyQualifiedName = regexFn.matched(1);
            result.name = fullyQualifiedName.split(".").pop();
            result.fullyQualified_name = fullyQualifiedName;
            result.parameters = parseFunctionArgs(parsedAnnotations, regexFn.matched(2));
            result.return_type = switch (parsedAnnotations.get("return")) {
              case Return(type): type;
              case _: 'Void';
            }
            return parseFunctionBlock(result, rest);
          case weirdFn.match(_) => true:
            final parsedAnnotations = parseAnnotations(result.annotations);
            result.name = weirdFn.matched(1);
            result.parameters = parseFunctionArgs(parsedAnnotations, weirdFn.matched(2));
            result.return_type = switch (parsedAnnotations.get("return")) {
              case Return(type): type;
              case _: 'Void';
            }
            return parseFunctionBlock(result, rest);
          case _:
            Sys.println("WTF " + line);
            return parseFunctionBlock(result, rest);
        }
      case [last]:
        Sys.println("Ignoring last line" + last);
        return result;
      case _:
        throw "Impossible case reached";
    }
  }

  public function parsePath(leafPath) {
    final fnsBlocks = getFunctionBlocks(leafPath);
    return fnsBlocks.map(
      x -> parseFunctionBlock({
        docs: [],
        parameters: [],
        annotations: [],
        name: "",
        fullyQualified_name: "",
        return_type: "Void"
      }, x)
    ).filter(x -> !(x.name == "" && x.fullyQualified_name == ""));
  }

  public function parseFn() {
    final fnsBlocks = getFunctionBlocks('vim.fn.lua').concat(getFunctionBlocks('vim.fn.1.lua'));
    return fnsBlocks.map(x -> parseFunctionBlock({
      docs: [],
      parameters: [],
      annotations: [],
      name: "",
      fullyQualified_name: "",
      return_type: "Void"
    }, x));
  }
}

class ReadNvimApi {
  final rawData:ApiData;
  final outputPath:String;

  public final nvimPath:Result< String >;

  static final luadevRepo = "git@github.com:folke/neodev.nvim.git";

  public function new(outputPath:String) {
    final bytes = readMsgpack();
    this.outputPath = outputPath;
    rawData = MsgPack.decode(bytes);
    nvimPath = getNvimRuntime();
  }

  public static function readMsgpack() {
    final readLines = new Process("nvim", ["--api-info"]);

    return readLines.stdout.readAll();
  }

  static function getTmpDir(path) {
    return executeCommand("mktemp", ["-d", "-t", path]);
  }

  public static function getNvimRuntime() {
    return switch (executeCommand("nvim",
      ["--clean", "--headless", "--cmd", "echo $VIMRUNTIME | qa "],
      true)) {
      case Error(error):
        Sys.println("Failed to get VIMRUNTIME");
        Sys.println(error);
        Error(error);
      case ok: ok;
    }
  }

  private static function writeFile(outputPath:String, data:Dynamic) {
    final handle = File.write(outputPath, false);
    handle.writeString(Json.stringify(data, null, "  "));
    handle.close();
  }

  function cleanup(tmpdir) {
    switch (executeCommand("rm", ["-rf", tmpdir])) {
      case Ok(_):
        Sys.println("Cleanup done");
      case Error(error):
        Sys.println("Failed the cleanup process");
        Sys.println(error);
    }
  }

  static function main() {
    final vimApi = new ReadNvimApi('./res/nvim-api.json');
    final tmpDir = switch (getTmpDir("nvim-api")) {
      case Ok(dirPath):
        Sys.println('Using $dirPath as temp folder');
        dirPath;
      case Error(msg):
        Sys.println('Failed getting temp dir: $msg');
        throw "TMP_DIR_FAIL";
    }
    switch (GitRepo.clone(luadevRepo, tmpDir)) {
      case Ok(output):
        Sys.println("Repo cloned");
        Sys.println(output);
      case Error(err):
        Sys.println("Failed clone neodev repo");
        Sys.println(err);
        return;
    };
    final neoDev = new AnnotationParser((leaf) -> Path.join([tmpDir, "types", "stable", leaf]));

    try {
      final parsed = neoDev.parseFn();
      writeFile('./res/fn.json', parsed);
    }
    catch (e) {
      Sys.println("Error during parsing, proceeding to cleanup");
      Sys.println(e);
    }
    switch (vimApi.nvimPath) {
      case Ok(path):
        final vimBuiltin = new AnnotationParser((leaf) -> Path.join([path, "lua", "vim", leaf]));
        final parsed = vimBuiltin.parsePath('fs.lua');
        writeFile('./res/fs.json', parsed);
      case Error(error):
        Sys.println("Could not get neovim path, skip parsing");
        Sys.println(error);
    }

    // final functions = switch (vimApi.rawData.functions) {
    //   case null:
    //     throw "Missing functions key in the API data";
    //   case functions:
    //     functions;
    // };
    vimApi.cleanup(tmpDir);
  }
}
