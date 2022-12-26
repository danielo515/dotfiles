package kickstart;

import lua.Table.AnyTable;
import vim.Vim;
import vim.VimTypes;
import lua.Table.create as t;

typedef LspConfigSetupFn = {
  final setup:(
    config:TableWrapper< {on_attach:(a:Dynamic, bufnr:Buffer) -> Void, Settings:AnyTable, capabilities:Dynamic} >
  ) -> Void;
}

@:luaRequire('lspconfig')
extern class Lspconfig {
  final sumneko_lua:LspConfigSetupFn;
}

// LSP settings.
//  This function gets run when an LSP connects to a particular buffer.
function on_attach(_:Dynamic, bufnr:Buffer) {
  final nmap = function(keys, func, desc) {
    Keymap.setBuf(Normal, keys, func, {buffer: bufnr, desc: 'LSP: $desc'});
  }

  nmap('<leader>rn', LspBuf.rename, '[R]e[n]ame');
  nmap('<leader>ca', LspBuf.code_action, '[C]ode [A]ction');

  nmap('gd', LspBuf.definition, '[G]oto [D]efinition');
  // nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences');
  nmap('gI', LspBuf.implementation, '[G]oto [I]mplementation');
  nmap('<leader>D', LspBuf.type_definition, 'Type [D]efinition');
  // nmap(
  //   '<leader>ds',
  //   require('telescope.builtin').lsp_document_symbols,
  //   '[D]ocument [S]ymbols'
  // );
  // nmap(
  //   '<leader>ws',
  //   require('telescope.builtin').lsp_dynamic_workspace_symbols,
  //   '[W]orkspace [S]ymbols'
  // ) // See `:help K` for why this keymap

  nmap('K', LspBuf.hover, 'Hover Documentation');
  nmap('<C-k>', LspBuf.signature_help, 'Signature Documentation') // Lesser used LSP functionality

  nmap('gD', LspBuf.declaration, '[G]oto [D]eclaration');
  nmap('<leader>wa', LspBuf.add_workspace_folder, '[W]orkspace [A]dd Folder');
  nmap('<leader>wr', LspBuf.remove_workspace_folder, '[W]orkspace [R]emove Folder');
  nmap(
    '<leader>wl',
    () -> Vim.print(LspBuf.list_workspace_folders()),
    '[W]orkspace [L]ist Folders'
  ) // Create a command `:Format` local to the LSP buffer

  nvim.API.nvim_buf_create_user_command(
    bufnr,
    'Format',
    (_) -> LspBuf.format(),
    t({desc: 'Format current buffer with LSP'})
  );
}
