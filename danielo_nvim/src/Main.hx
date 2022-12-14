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
	}

	static function openInGh() {
		if (vim.Fn.executable("gh") != 1)
			return;

		final currentFile = vim.Fn.expand(CurentFile);
		Job.make({command: "gh", arguments: [currentFile], cwd: null}).sync();
	}
}

@:expose("setup")
function setup() {
	Vim.print("ran setup");
}
