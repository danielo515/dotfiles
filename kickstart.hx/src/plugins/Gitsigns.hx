package plugins;

extern class Gitsigns {
  @:luaDotMethod function setup(config:TableWrapper< {
    signs:{
      add:{text:String},
      change:{text:String},
      delete:{text:String},
      topdelete:{text:String},
      changedelete:{text:String},
    }
  } >):Void;
}
