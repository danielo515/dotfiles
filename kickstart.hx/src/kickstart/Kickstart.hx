package kickstart;

using vim.TableTools;

import kickstart.LspConfig;
import vim.VimTypes;
import lua.Table.create as t;

/**
  Port to Haxe of https://github.com/nvim-lua/kickstart.nvim
 */
function main() {
  MasonLspConfig.setup_handlers(t([server_name -> {
    switch (server_name) {
      case 'sumneko_lua': Lspconfig.sumneko_lua.setup({
          capabilities: capabilities,
          on_attach: onAttach,
          settings: t({
            lua: t({
              workspace: t({checkThirdParty: false}),
              telemetry: t({enable: false}),
            })
          })
        });
      case 'haxe_language_server': Lspconfig.haxe_language_server.setup({
          capabilities: capabilities,
          on_attach: onAttach,
          settings: t({})
        });
      case 'jsonls': Lspconfig.jsonls.setup({
          capabilities: capabilities,
          on_attach: onAttach,
          settings: t({
            json: t({
              schemas: t([
                ({
                  description: "Haxe format schema",
                  fileMatch: t(["hxformat.json"]),
                  name: "hxformat.schema.json",
                  url: "https://raw.githubusercontent.com/vshaxe/vshaxe/master/schemas/hxformat.schema.json",
                })
              ]).concat(SchemaStore.json.schemas())
            })
          })
        });
      case _: Vim.print('Ignoring $server_name');
    }
  }]));
}
