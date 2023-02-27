package kickstart;

import lua.Table.create as t;
import packer.Packer;

function main() {
  final plugins:Array< Plugin > = [
    {name: "wbthomason/packer.nvim"},
    {name: "kylechui/nvim-surround"}
  ];
  Packer.init(plugins);
}
