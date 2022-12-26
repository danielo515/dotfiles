package vim;

@:native("vim.lsp")
// @:build(ApiGen.attachApi("lsp"))
extern class Lsp {}

@:native("vim.lsp.buf")
// @:build(ApiGen.attachApi("lsp"))
extern class LspBuf {}
