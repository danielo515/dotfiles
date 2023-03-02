package plugins;

import vim.plugin.types.VimPlugin;

typedef Config = TableWrapper< {
  panel:{
    enabled:Bool,
    auto_refresh:Bool,
    keymap:{
      jump_prev:String,
      jump_next:String,
      accept:String,
      refresh:String,
      open:String,
    },
    layout:{
      position:String,
      ratio:Float,
    },
  },
  suggestion:{
    enabled:Bool,
    auto_trigger:Bool,
    debounce:Int,
    keymap:{
      accept:String,
      accept_word:Bool,
      accept_line:Bool,
      next:String,
      prev:String,
      dismiss:String,
    },
  },
  filetypes:{
    yaml:Bool,
    markdown:Bool,
    help:Bool,
    gitcommit:Bool,
    gitrebase:Bool,
    hgcommit:Bool,
    svn:Bool,
    cvs:Bool,
  },
  copilot_node_command:String,
} >

extern class Copilot {
  @:luaDotMethod function setup(config:Config):Void;
}

inline function configure() {
  final x:VimPlugin< Copilot > = "copilot";
  x.call(copilot -> copilot.setup({
    panel: {
      enabled: true,
      auto_refresh: true,
      keymap: {
        jump_prev: "[[",
        jump_next: "]]",
        accept: "<CR>",
        refresh: "gr",
        open: "<M-CR>",
      },
      layout: {
        position: "bottom",
        ratio: 0.4,
      },
    },
    suggestion: {
      enabled: true,
      auto_trigger: true,
      debounce: 75,
      keymap: {
        accept: "<c-e>",
        accept_word: false,
        accept_line: false,
        next: "<M-b>",
        prev: "<M-v>",
        dismiss: "<C-c>",
      },
    },
    filetypes: {
      yaml: false,
      markdown: false,
      help: false,
      gitcommit: false,
      gitrebase: false,
      hgcommit: false,
      svn: false,
      cvs: false,
    },
    copilot_node_command: "node"
  }));
}
