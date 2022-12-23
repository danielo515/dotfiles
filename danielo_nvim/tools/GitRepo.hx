package tools;

import tools.Cmd;
import sys.FileSystem;
import tools.Result;

class GitRepo {
  final path:String;
  final repoUrl:String;

  public function new(repoUrl, destinationPath) {
    this.path = destinationPath;
    this.repoUrl = repoUrl;
  }

  static function destinationExists(path) {
    return FileSystem.isDirectory(path);
  }

  public static function clone(repo, dest):Result< GitRepo > {
    if (destinationExists(dest)) return Ok(new GitRepo(repo, dest));
    final status = executeCommand("git", ["clone", repo, dest, "--single-branch"]);
    return switch (status) {
      case Ok(_): Ok(new GitRepo(repo, dest));
      case Error(err): Error(err);
    }
  }
}
