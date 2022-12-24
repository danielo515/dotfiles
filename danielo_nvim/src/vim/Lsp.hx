package vim;

@:native("vim.lsp")
@:build(ApiGen.attachApi("lsp"))
extern class Lsp {}
