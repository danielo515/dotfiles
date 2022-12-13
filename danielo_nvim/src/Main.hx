import vim.Vim;

class Main {
	static function main() {
		// vim.Ui.select(["a"], {prompt: "Pick one sexy option"}, (choice, _) -> Vim.print(choice));
		vim.Api.nvim_create_user_command("HaxeCmd", (args) -> Vim.print(args), {desc: "Testing from haxe", force: true});
	}
}
