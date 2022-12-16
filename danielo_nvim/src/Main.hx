import vim.Ui;
import plenary.Job;
import vim.Vim;
import vim.VimTypes;

using lua.NativeStringTools;
using Test;

class Main {
  public static inline function command(name, fn, description, args) {
    vim.Api.nvim_create_user_command(name, fn, {desc: description, force: true, nargs: args});
  }

  static function main() {
    // vim.Ui.select(["a"], {prompt: "Pick one sexy option"}, (choice, _) -> Vim.print(choice));
    vim.Api.nvim_create_user_command(
      "HaxeCmd",
      (args) -> Vim.print(args),
      {desc: "Testing from haxe", force: true, nargs: Any}
    );

    DanieloVim.autocmd('HaxeEvent', [BufWritePost], "*.hx", "Created from haxe", () -> {
      var filename = Vim.expand(ExpandString.plus(CurentFile, FullPath));
      Vim.print('Hello from axe', filename);
      return true;
    });
    vim.Api.nvim_create_user_command(
      "OpenInGh",
      openInGh,
      {desc: "Open the current file in github", force: true, nargs: None}
    );
    vim.Api.nvim_create_user_command(
      "CopyGhUrl",
      copyGhUrl,
      {desc: "Copy current file github URL", force: true, nargs: None}
    );

    command(
      "CopyMessagesToClipboard",
      (args) -> copy_messages_to_clipboard(args.args),
      "Copy the n number of messages to clipboard",
      ExactlyOne
    );
    final keymaps = nvim.API.nvim_buf_get_keymap(CurrentBuffer, "n");
    Vim.print(keymaps.map(x -> '${x.lhs} -> ${x.rhs} ${x.desc}'));
  }

  static function runGh(args):Null< lua.Table< Int, String > > {
    if (vim.Fn.executable("gh") != 1) return null;

    final job = Job.make({
      command: "gh",
      args: args,
      on_stderr: (args, return_val) -> {
        Vim.print("Job got stderr", args, return_val);
      }
    });
    return job.sync();
  }

  static function openInGh(_) {
    final currentFile = vim.Fn.expand(CurentFile);
    final curentBranch = get_branch();
    runGh(["browse", currentFile, "--branch", curentBranch[1]]);
  }

  static function get_branch() {
    var args = lua.Table.create(["rev-parse", "--abbrev-ref", "HEAD"]);
    final job = Job.make({
      command: "git",
      args: args,
      on_stderr: (args, return_val) -> {
        Vim.print("Something may have  failed", args, return_val);
      }
    });
    return job.sync();
  }

  public static function copy_messages_to_clipboard(number:String) {
    final cmd = "let @* = execute('%smessages')".format(number.or(""));
    Vim.cmd(cmd);
    Vim.notify('$number :messages copied to the clipboard', "info");
  }

  static function copyGhUrl(_) {
    final currentFile = vim.Fn.expand(CurentFile);
    final curentBranch = get_branch();
    var lines = runGh(["browse", currentFile, "--no-browser", "--branch", curentBranch[1]]);
    switch (lines) {
      case null:
        Vim.print("No URL");
      case _:
        Vim.print("lines", lines[1]);
    }
  }
}

@:expose("setup")
function setup() {
  Vim.print("ran setup");
}
