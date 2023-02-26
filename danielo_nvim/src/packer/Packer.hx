package packer;

import vim.Vim;
import lua.Table.create as t;
import plenary.Job;

/**
  PluginSpec type reference:
  {
  'myusername/example',        -- The plugin location string
  -- The following keys are all optional
  disable = boolean,           -- Mark a plugin as inactive
  as = string,                 -- Specifies an alias under which to install the plugin
  installer = function,        -- Specifies custom installer. See "custom installers" below.
  updater = function,          -- Specifies custom updater. See "custom installers" below.
  after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
  rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
  opt = boolean,               -- Manually marks a plugin as optional.
  bufread = boolean,           -- Manually specifying if a plugin needs BufRead after being loaded
  branch = string,             -- Specifies a git branch to use
  tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
  commit = string,             -- Specifies a git commit to use
  lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
  run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
  requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
  rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
  config = string or function, -- Specifies code to run after this plugin is loaded.
  -- The setup key implies opt = true
  setup = string or function,  -- Specifies code to run before this plugin is loaded. The code is ran even if
                               -- the plugin is waiting for other conditions (ft, cond...) to be met.
  -- The following keys all imply lazy-loading and imply opt = true
  cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
  ft = string or list,         -- Specifies filetypes which load this plugin.
  keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
  event = string or list,      -- Specifies autocommand events which load this plugin.
  fn = string or list          -- Specifies functions which load this plugin.
  cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
  module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
                               -- with one of these module names, the plugin will be loaded.
  module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
                               -- requiring a string which matches one of these patterns, the plugin will be loaded.
  }
 */
// PackerSpec translated to haxe
function doit(spec:TableWrapper< {
  name:String,
  ?superUnique:Bool,
  ?disable:Bool,
} >) {
  return spec;
};

@keep final danielotest = doit({
  name: "myusername/example",
  superUnique: true,
  disable: null,
});

inline extern function packer_plugins():Null< lua.Table< String, {loaded:Bool, path:String, url:String} > >
  return untyped __lua__("_G.packer_plugins");

function get_plugin_version(name:String):String {
  return if (packer_plugins() != null) {
    final path = packer_plugins()[cast name].path;
    final job = Job.make({
      command: "git",
      cwd: path,
      args: t(['rev-parse', '--short', 'HEAD']),
      on_stderr: (args, return_val) -> {
        Vim.print("Job got stderr", args, return_val);
      }
    });
    job.sync()[1];
  } else {
    "unknown";
  }
}
