package plugins;

typedef Config = TableWrapper<{
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
}>

extern class Copilot {
	@:luaDotMethod function setup(config:Config):Void;
}
