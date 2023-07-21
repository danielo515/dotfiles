package kickstart;

import plugins.Plugins.KylechuiNvimSurround;
import plugins.Plugins.TmuxNavigation;
import plugins.Plugins.NeoTree;
import plugins.FzfLua;
import plugins.LspConfig.Lspconfig;

using vim.TableTools;

import plugins.Plugins.SchemaStore;
import plugins.Plugins.MasonLspConfig;
import plugins.Plugins.Cmp_nvim_lsp;
import vim.Lsp;
import plugins.Plugins.Fidget;
import plugins.Plugins.Mason;
import plugins.Plugins.Neodev;
import plugins.Plugins.Comment;
import plugins.Plugins.IndentBlankline;
import plugins.Gitsigns;
import vim.Vimx;
import vim.plugin.types.VimPlugin;
import plugins.WhichKey;
import lua.Table.create as t;
import packer.Packer;
import vim.Vim;
import vim.VimTypes;

function config_nvim_surround() {
  untyped {lua: "require('nvim-surround').setup{}"}
}

function main() {
  final plugins:Array< Plugin > = [
    {name: "wbthomason/packer.nvim"},
    {name: "folke/which-key.nvim"},
    {name: "psliwka/vim-smoothie"},
    {
      name: "kdheepak/lazygit.nvim",
      requires: t(["nvim-lua/plenary.nvim"]),
    },
    {name: "nvim-lua/plenary.nvim"},
    {
      name: "nvim-neo-tree/neo-tree.nvim",
      branch: "v2.x",
      requires: t([
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      ]),
      config: NeoTree.configure,
    },
    { // LSP Configuration & Plugins
      name: "neovim/nvim-lspconfig",
      requires: t([
        // Automatically install LSPs to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        // Useful status updates for LSP
        "j-hui/fidget.nvim",

        // Additional lua configuration, makes nvim stuff amazing
        "folke/neodev.nvim",
      ]),
    },
    // -- Autocompletion
    {
      name: "hrsh7th/nvim-cmp",
      requires: t(["hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"]),
    },

    {name: "lukas-reineke/cmp-rg"},
    {name: "hrsh7th/cmp-cmdline", commit: "9c0e331"},
    {name: "andersevenrud/cmp-tmux"},
    // -- Autocompletion end
    { // Highlight, edit, and navigate code
      name: "nvim-treesitter/nvim-treesitter",
      run: 'pcall(require("nvim-treesitter.install").update({ with_sync = true }))'
    },

    {name: "b0o/schemastore.nvim"},
    // Git related plugins
    {name: "tpope/vim-fugitive"},
    {name: "tpope/vim-rhubarb"},
    {name: "lewis6991/gitsigns.nvim"},

    {name: "navarasu/onedark.nvim"}, // Theme inspired by Atom
    {name: "nvim-lualine/lualine.nvim"}, // Fancier statusline
    {name: "lukas-reineke/indent-blankline.nvim"}, // Add indentation guides even on blank lines
    {
      name: "numToStr/Comment.nvim",
      config: Comment.configure_comment
    }, // "gc" to comment visual regions/lines
    {name: "tpope/vim-sleuth"}, // Detect tabstop and shiftwidth automatically
    {
      name: "zbirenbaum/copilot.lua",
      cmd: "Copilot",
      event: ["InsertEnter"],
      config: plugins.Copilot.configure
    },
    {
      name: "ibhagwan/fzf-lua",
      requires: t(["nvim-tree/nvim-web-devicons"]),
      config: plugins.FzfLua.configure
    },
    {name: "jdonaldson/vaxe"},
    {name: "alexghergh/nvim-tmux-navigation"},
    {
      name: "kylechui/nvim-surround",
      tag: '*',
      requires: t(
        ["wellle/targets.vim"]
      ), // Adds more targets to vim's built-in text object motions
      config: config_nvim_surround
    },
  ];

  final is_bootstrap = Packer.init(plugins);
  if (is_bootstrap) {
    vim.Vim.print("==================================");
    vim.Vim.print("    Plugins are being installed");
    vim.Vim.print("    Wait until Packer completes,");
    vim.Vim.print("       then restart nvim");
    vim.Vim.print("==================================");
    return;
  }

  // vim.Filetype.add({
  //   extension = {
  //     hx = "haxe"
  //   }
  // })
  keymaps();
  setupPlugins();
  vimOptions();
  autoCommands();
  // Is not very well know, but it is true that my personal config exist within haxe-nvim
  Main.setup();
}

function autoCommands() {
  Vimx.autocmd(
    "Kickstart",
    t([BufWritePost]),
    Fn.expand(MYVIMRC),
    "Reload the config",
    () -> Vim.cmd("source <afile> | PackerCompile")
  );
  Vimx.autocmd(
    "Kickstart-yank",
    [TextYankPost],
    "*",
    "Highlight on yank",
    kickstart.Untyped.higlightOnYank
  );
  Vimx.autocmdStr(
    "Kickstart",
    t([WinEnter]),
    "*",
    "set relative numbers on win enter",
    "set relativenumber number cursorline"
  );
  Vimx.autocmdStr(
    "Kickstart",
    t([WinLeave]),
    "*",
    "unset numbers on unfocussed window",
    "set norelativenumber nocursorline"
  );
}

inline function vimOptions() {
  Vim.cmd("colorscheme onedark");
  // -- Vim options
  Vim.o.hlsearch = false;
  Vim.o.mouse = 'a';
  Vim.o.breakindent = true;
  Vim.o.undofile = true;
  Vim.wo.Number = true;
  // show the effects of a search / replace in a live preview window
  Vim.o.inccommand = "split";
}

// LSP settings.
//  This function gets run when an LSP connects to a particular buffer.
function onAttach(x:Dynamic, bufnr:Buffer):Void {
  function nmap(keys, func, desc) {
    Keymap.setBuf(Normal, keys, func, {buffer: bufnr, desc: 'LSP: $desc'});
  }
  nmap('<leader>rn', LspBuf.rename, '[R]e[n]ame');
  nmap('<leader>ca', LspBuf.code_action, '[C]ode [A]ction');

  nmap('gd', LspBuf.definition, '[G]oto [D]efinition');
  // nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences');
  nmap('gI', LspBuf.implementation, '[G]oto [I]mplementation');
  nmap('<leader>D', LspBuf.type_definition, 'Type [D]efinition');
  nmap('<leader>ds', ':FzfLua lsp_document_symbols<cr>', '[D]ocument [S]ymbols');
  nmap('<leader>wd', ':FzfLua diagnostics_workspace<CR>', '[W]orkspace [D]iagnostics');

  nmap('K', LspBuf.hover, 'Hover Documentation');
  // imap('<C-k>', LspBuf.signature_help, 'Signature Documentation'); // Lesser used LSP functionality

  nmap('gD', LspBuf.declaration, '[G]oto [D]eclaration');
  nmap('<leader>wa', LspBuf.add_workspace_folder, '[W]orkspace [A]dd Folder');
  nmap('<leader>wr', LspBuf.remove_workspace_folder, '[W]orkspace [R]emove Folder');
  nmap(
    '<leader>wl',
    () -> Vim.print(LspBuf.list_workspace_folders()),
    '[W]orkspace [L]ist Folders'
  ); // Create a command `:Format` local to the LSP buffer

  vim.Api.nvim_buf_create_user_command(bufnr, 'Format', (_) -> LspBuf.format(), {
    desc: 'Format current buffer with LSP',
    force: true,
    nargs: None,
    bang: false,
    range: No,
  });
}

function setupPlugins() {
  IndentBlankline.require()!.setup(t({
    char: '┊',
    show_trailing_blankline_indent: false,
  }));
  Neodev.require()!.setup();
  Mason.require()!.setup();
  Fidget.require()!.setup();
  KylechuiNvimSurround.require()!.setup();
  Cmp.configure();
  TmuxNavigation.configure();

  final capabilities = Cmp_nvim_lsp.require()!.default_capabilities(
    vim.Lsp.Protocol.make_client_capabilities()
  );

  final lualine = plugins.Lualine.require();
  if (lualine != null) {
    // -- Set lualine as statusline
    // -- See `:help lualine.txt`
    lualine.setup({
      options: {
        icons_enabled: true,
        theme: 'onedark',
        component_separators: '|',
        section_separators: '',
      },
    });
  }
  final wk:VimPlugin< WhichKey > = "which-key";
  wk.call(wk -> {
    Vim.o.timeout = true;
    Vim.o.timeoutlen = 300;
    wk.setup({
      plugins: {
        marks: true,
        registers: true,
        spelling: {
          enabled: true,
          suggestions: 20,
        },
        presets: {
          operators: true,
          motions: true,
          text_objects: true,
          windows: true,
          nav: true,
          z: true,
          g: true,
        },
      },
    });
  });
  final gs:VimPlugin< Gitsigns > = "gitsigns";
  gs.call(gs -> {
    gs.setup({
      signs: {
        add: {
          text: '+'
        },
        change: {
          text: '~'
        },
        delete: {
          text: '_'
        },
        topdelete: {
          text: '‾'
        },
        changedelete: {
          text: '~'
        },
      },
    });
  });

  final lspconfig:VimPlugin< Lspconfig > = "lspconfig";
  lspconfig.call(lspconfig -> {
    final mason = MasonLspConfig.require();
    if (capabilities == null)
      return;
    if (mason == null)
      return;
    mason.setup_handlers(t([(server_name:String) -> {
      switch (server_name) {
        case 'lua_ls': lspconfig.lua_ls.setup({
            capabilities: capabilities,
            on_attach: onAttach,
            settings: t({
              lua: t({
                workspace: t({checkThirdParty: false}),
                telemetry: t({enable: false}),
              })
            })
          });
        case 'haxe_language_server': lspconfig.haxe_language_server.setup({
            capabilities: capabilities,
            on_attach: onAttach,
            settings: t({})
          });
        case 'jsonls':
          final jsonSchemas = SchemaStore.require()!.json!.schemas();
          var schemas = t([{
            description: "Haxe format schema",
            fileMatch: t(["hxformat.json"]),
            name: "hxformat.schema.json",
            url: "https://raw.githubusercontent.com/vshaxe/vshaxe/master/schemas/hxformat.schema.json",
          }]);
          if (jsonSchemas != null)
            schemas = schemas.concat(jsonSchemas);
          lspconfig.jsonls.setup({
            capabilities: capabilities,
            on_attach: onAttach,
            settings: t({
              json: t({
                schemas: schemas,
              })
            })
          });
        case _: Vim.print('Ignoring $server_name');
      }
    }]));
  });
}

function keymaps() {
  Vim.g.mapleader = " ";
  Vim.g.maplocalleader = ",";
  Keymap.set(
    t([Normal]),
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    {desc: 'up when word-wrap', silent: true, expr: true}
  );
  Keymap.set(
    t([Normal]),
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    {desc: 'down when word-wrap', silent: true, expr: true}
  );
  Keymap.set(
    t([Normal]),
    '<leader>w',
    "<Cmd>wa<CR>",
    {desc: 'Write all files', silent: true}
  );

  Keymap.set(t([Normal]), '<leader>gg', "<Cmd>LazyGit<CR>", {desc: 'LazyGit', silent: true});
  final fzf = FzfLua.require();
  if (fzf != null) {
    Keymap.set(
      t([Normal]),
      '<leader>ff',
      "<Cmd>lua require('fzf-lua').files()<CR>",
      {desc: 'Find files', silent: true}
    );
    Keymap.set(
      t([Normal]),
      '<leader>fg',
      "<Cmd>lua require('fzf-lua').grep()<CR>",
      {desc: 'Grep files', silent: true}
    );
    Keymap.set(
      t([Normal]),
      '<leader>fb',
      "<Cmd>lua require('fzf-lua').buffers()<CR>",
      {desc: 'Find buffers', silent: true}
    );
    Keymap.set(
      t([Normal]),
      '<leader>fh',
      "<Cmd>lua require('fzf-lua').help_tags()<CR>",
      {desc: 'Find help tags', silent: true}
    );
    // Keymap.set(t([Normal]), '<c-k>', "<c-w>k", {desc: 'Move to window up', silent: true});
    // Keymap.set(t([Normal]), '<c-j>', "<c-w>j", {desc: 'Move to window down', silent: true});
    // Keymap.set(t([Normal]), '<c-h>', "<c-w>h", {desc: 'Move to window left', silent: true});
    // Keymap.set(t([Normal]), '<c-l>', "<c-w>l", {desc: 'Move to window right', silent: true});
    NeoTree.require().run(_ -> {
      Keymap.set(
        Normal,
        '<leader>e',
        ":Neotree filesystem reveal left toggle<cr>",
        {desc: 'Toggle NeoTree', silent: true, expr: false}
      );
    });
  }
}
