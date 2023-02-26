package kickstart;

import plugins.Packer;
import lua.Table.create as t;

function main() {
  final plugins:Array< Plugin > = [
    {name: "wbthomason/packer.nvim"},
    {name: "kylechui/nvim-surround"}
  ];
  Packer.init(plugins);
}
