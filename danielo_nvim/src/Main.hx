import vim.Vim;

class Main {
	static function main() {
		vim.Ui.select(["a"], {prompt: "Pick one sexy option"}, (choice, _) -> Vim.print(choice));
	}
}
