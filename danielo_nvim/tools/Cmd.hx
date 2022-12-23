package tools;

import sys.io.Process;

function executeCommand(cmd, args, readStder = false):Result< String > {
  final res = new Process(cmd, args);
  return switch (res.exitCode(true)) {
    case 0:
      Ok(!readStder ? res.stdout.readAll().toString() : res.stderr.readAll().toString());
    case _:
      Error(res.stderr.readLine());
  }
}

function getHomeFolder() {
  return Sys.getEnv(if (Sys.systemName() == "Windows")"UserProfile" else "HOME");
}
