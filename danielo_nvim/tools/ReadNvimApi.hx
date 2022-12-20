import haxe.Json;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.Process;
import haxe.SysTools;
import sys.io.File;
import org.msgpack.MsgPack;

using Lambda;

typedef ApiData = {
  final functions:Array< {name:String, return_type:String, deprecated_since:Null< Int >} >;
}

enum Result< T > {
  Ok(result:T);
  Error(message:String);
}

function executeCommand(cmd, args) {
  final res = new Process(cmd, args);
  return switch (res.exitCode(true)) {
    case 0:
      Ok(res.stdout.readAll().toString());
    case _:
      Error(res.stderr.readLine());
  }
}

typedef FunctionBlock = {
  final docs:Array< String >;
  var args:Array< String >;
  final annotations:Array< String >;
  var name:String;
}

@:tink class NeoDev {
  final repoPath:String;

  public function new(repoPath) {
    this.repoPath = repoPath;
  }

  function getPath(leaf) {
    return Path.join([repoPath, "types", "stable", leaf]);
  }

  function getFunctionBlocks(file) {
    final path = getPath(file);
    final file = File.read(path, false).readAll().toString();
    return file.split("\n\n").filter(x -> x != "" && x != "---@meta").map(x -> x.split("\n"));
  }

  function parseFunctionArgs(annotations, args) {
    // TODO: handle annotations
    return args.split(',');
  }

  function parseFunctionBlock(result:FunctionBlock, lines:Array< String >) {
    final regexFn = ~/function ([A-Z._0-9]+)\(([^)]*)/i;
    return switch (lines) {
      case []:
        return result;
      case [line, @rest rest]:
        switch (line.substr(0, 3)) {
          case "-- ":
            result.docs.push(line.substr(3));
            return parseFunctionBlock(result, rest);
          case "---":
            result.annotations.push(line.substr(3));
            return parseFunctionBlock(result, rest);
          case "fun":
            if (regexFn.match(line)) {
              result.name = regexFn.matched(1);
              result.args = parseFunctionArgs(result.annotations, regexFn.matched(2));
            } else {
              Sys.println(line);
              result.name;
            };
            return parseFunctionBlock(result, rest);
          case wtf:
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

  public function parseFn() {
    final fnsBlocks = getFunctionBlocks('vim.fn.lua');
    return fnsBlocks.map(x -> parseFunctionBlock({
      docs: [],
      args: [],
      annotations: [],
      name: ""
    }, x));
  }
}

class ReadNvimApi {
  final rawData:ApiData;
  final outputPath:String;

  static final luadevRepo = "git@github.com:folke/neodev.nvim.git";

  public function new(outputPath:String) {
    final bytes = readMsgpack();
    this.outputPath = outputPath;
    rawData = MsgPack.decode(bytes);
  }

  public static function readMsgpack() {
    final readLines = new Process("nvim", ["--api-info"]);

    return readLines.stdout.readAll();
  }

  static function clone(repo, dest) {
    return executeCommand("git", ["clone", repo, dest, "--single-branch"]);
  }

  static function getTmpDir(path) {
    return executeCommand("mktemp", ["-d", "-t", path]);
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
    switch (clone(luadevRepo, tmpDir)) {
      case Ok(output):
        Sys.println("Repo cloned");
        Sys.println(output);
      case Error(err):
        Sys.println("Failed clone neodev repo");
        Sys.println(err);
    };
    final neoDev = new NeoDev(tmpDir);
    trace(Json.stringify(neoDev.parseFn().slice(0, 5), null, "  "));

    // final functions = switch (vimApi.rawData.functions) {
    //   case null:
    //     throw "Missing functions key in the API data";
    //   case functions:
    //     functions;
    // };
    vimApi.cleanup(tmpDir);
  }
}
