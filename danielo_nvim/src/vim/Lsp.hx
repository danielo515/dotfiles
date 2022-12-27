package vim;

import haxe.Constraints.Function;
import vim.VimTypes;

@:native("vim.lsp")
@:build(ApiGen.attachApi("lsp"))
extern class Lsp {}

@:native("vim.lsp.buf")
@:build(ApiGen.attachApi("lsp_buf"))
extern class LspBuf {}
