import plenary.Job;
import vim.Vim;
import vim.VimTypes;

class Main {
	static function main() {
		// vim.Ui.select(["a"], {prompt: "Pick one sexy option"}, (choice, _) -> Vim.print(choice));
		vim.Api.nvim_create_user_command("HaxeCmd", (args) -> Vim.print(args), {desc: "Testing from haxe", force: true});

		DanieloVim.autocmd('HaxeEvent', [BufWritePost], "*.hx", "Created from haxe", () -> {
			var filename = Vim.expand(ExpandString.plus(CurentFile, FullPath));
			Vim.print('Hello from axe', filename);
			return true;
		});
		vim.Api.nvim_create_user_command("OpenInGh", openInGh, {desc: "Open the current file in github", force: true});
		vim.Api.nvim_create_user_command("CopyGhUrl", copyGhUrl, {desc: "Copy current file github URL", force: true});
		Vim.print(nvim.API.nvim_buf_get_keymap(CurrentBuffer, "n"));
	}

	static function runGh(args):Null<lua.Table<Int, String>> {
		if (vim.Fn.executable("gh") != 1)
			return null;

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
