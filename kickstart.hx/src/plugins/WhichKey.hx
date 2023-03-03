package plugins;

import vim.VimTypes;
/*
  WhichKey.nvim default configuration values.
  {
   plugins = {
     marks = true, -- shows a list of your marks on ' and `
     registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
     -- the presets plugin, adds help for a bunch of default keybindings in Neovim
     -- No actual key bindings are created
     spelling = {
       enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
       suggestions = 20, -- how many suggestions should be shown in the list?
     },
     presets = {
       operators = true, -- adds help for operators like d, y, ...
       motions = true, -- adds help for motions
       text_objects = true, -- help for text objects triggered after entering an operator
       windows = true, -- default bindings on <c-w>
       nav = true, -- misc bindings to work with windows
       z = true, -- bindings for folds, spelling and others prefixed with z
       g = true, -- bindings for prefixed with g
     },
   },
   -- add operators that will trigger motion and text object completion
   -- to enable all native operators, set the preset / operators plugin above
   operators = { gc = "Comments" },
   key_labels = {
     -- override the label used to display some keys. It doesn't effect WK in any other way.
     -- For example:
     -- ["<space>"] = "SPC",
     -- ["<cr>"] = "RET",
     -- ["<tab>"] = "TAB",
   },
   motions = {
     count = true,
   },
   icons = {
     breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
     separator = "➜", -- symbol used between a key and it's label
     group = "+", -- symbol prepended to a group
   },
   popup_mappings = {
     scroll_down = "<c-d>", -- binding to scroll down inside the popup
     scroll_up = "<c-u>", -- binding to scroll up inside the popup
   },
   window = {
     border = "none", -- none, single, double, shadow
     position = "bottom", -- bottom, top
     margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
     padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
     winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
   },
   layout = {
     height = { min = 4, max = 25 }, -- min and max height of the columns
     width = { min = 20, max = 50 }, -- min and max width of the columns
     spacing = 3, -- spacing between columns
     align = "left", -- align columns left, center or right
   },
   ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
   hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
   show_help = true, -- show a help message in the command line for using WhichKey
   show_keys = true, -- show the currently pressed key and its label as a message in the command line
   triggers = "auto", -- automatically setup triggers
   -- triggers = {"<leader>"} -- or specifiy a list manually
   -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
   triggers_nowait = {
     -- marks
     "`",
     "'",
     "g`",
     "g'",
     -- registers
     '"',
     "<c-r>",
     -- spelling
     "z=",
   },
   triggers_blacklist = {
     -- list of mode / prefixes that should never be hooked by WhichKey
     -- this is mostly relevant for keymaps that start with a native binding
     i = { "j", "k" },
     v = { "j", "k" },
   },
   -- disable the WhichKey popup for certain buf types and file types.
   -- Disabled by default for Telescope
   disable = {
     buftypes = {},
     filetypes = {},
   },
  }
 */
import haxe.extern.EitherType;
import vim.Vim;

typedef WhichKeyConfig = TableWrapper< {
  plugins:{
    ?marks:Bool,
    ?registers:Bool,
    ?spelling:{
      ?enabled:Bool,
      ?suggestions:Int,
    },
    ?presets:{
      ?operators:Bool,
      ?motions:Bool,
      ?text_objects:Bool,
      ?windows:Bool,
      ?nav:Bool,
      ?z:Bool,
      ?g:Bool,
    },
  },
  ?operators:lua.Table< String, String >,
  ?key_labels:lua.Table< String, String >,
  ?motions:{
    ?count:Bool,
  },
  ?icons:{
    ?breadcrumb:String,
    ?separator:String,
    ?group:String,
  },
  ?popup_mappings:{
    ?scroll_down:String,
    ?scroll_up:String,
  },
  ?window:{
    ?border:String,
    ?position:String,
    ?margin:Vector4< Int, Int, Int, Int >,
    ?padding:Vector4< Int, Int, Int, Int >,
    ?winblend:Int,
  },
  ?layout:{
    ?height:{
      ?min:Int,
      ?max:Int,
    },
    ?width:{
      ?min:Int,
      ?max:Int,
    },
    ?spacing:Int,
    ?align:String,
  },
  ?ignore_missing:Bool,
  ?hidden:Array< String >,
  ?show_help:Bool,
  ?show_keys:Bool,
  ?triggers:String,
  ?triggers_nowait:Array< String >,
  ?triggers_blacklist:{
    ?i:Array< String >,
    ?v:Array< String >,
  },
  ?disable:{
    ?buftypes:Array< String >,
    ?filetypes:Array< String >,
  },
} >;

typedef MappingGroup = {name:String, mappings:lua.Table< String, EitherType< String, Void -> Void > >};
typedef Mappings = lua.Table< String, MappingGroup >;

/**
  wk.register({
  f = {
    name = "file", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
    n = { "New File" }, -- just a label. don't create any mapping
    e = "Edit File", -- same as above
    ["1"] = "which_key_ignore",  -- special label to hide it in the popup
    b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
  },
  }, { prefix = "<leader>" })
 */
extern class WhichKey {
  @:luaDotMethod function setup(config:WhichKeyConfig):Void;
}
