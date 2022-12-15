import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;

var patches = [
	"nvim_create_augroup" => macro:vim.Vim.Group,
	"nvim_create_user_command.command" => macro:vim.VimTypes.LuaObj<vim.Vim.CommandCallbackArgs>->Void,
	"nvim_create_user_command.opts" => macro:TableWrapper<{
		desc:String,
		force:Bool
	}>
];

macro function generateApi():Void {
	var specs = Json.parse(File.getContent('res/nvim-api.json'));

	Context.defineType({
		pack: ["nvim"],
		name: "API",
		isExtern: true,
		kind: TDClass(),
		#if !dump
		meta: [meta("native", [macro "vim.api"])],
		#end
		fields: [
			for (f in(specs.functions : Array<FunctionDef>)) {
				{
					name: f.name,
					access: [AStatic, APublic],
					meta: (f.deprecated_since != null) ? [meta('deprecated')] : [],
					kind: FFun({
						args: f.parameters.map(p -> ({
							name: p.name,
							type: resolveType(f.name, p.name, p.type)
						} : FunctionArg)),
						ret: resolveType(f.name, null, f.return_type)
					}),
					pos: (macro null).pos
				}
			}
		],
		pos: (macro null).pos
	});
}

function resolveType(fun:String, arg:Null<String>, t:String):ComplexType {
	var patch = patches.get(arg == null ? fun : '$fun.$arg');
	if (patch != null)
		return patch;

	return switch (t) {
		case "String": macro
		:String;
		case "LuaRef": macro
		:haxe.Constraints.Function;
		case "Window": macro
		:vim.VimTypes.WindowId;
		case "Buffer": macro
		:vim.VimTypes.BufferId;
		case "Integer": macro
		:Int;
		case "Float": macro
		:Float;
		case "Tabpage": macro
		:vim.VimTypes.TabPage;
		case "Dictionary": macro
		:lua.Table<String, Dynamic>;
		case "Boolean": macro
		:Bool;
		case "Object": macro
		:Dynamic;
		case "Array": macro
		:Array<Dynamic>;
		case "void": macro
		:Void;

		case t if (StringTools.startsWith(t, "ArrayOf(")):
			final regexArrayArg = ~/ArrayOf\(([a-zA-Z]+),?/i;
			regexArrayArg.match(t);
			var itemType = resolveType(fun, (arg == null ? "" : arg) + "[]", regexArrayArg.matched(1));
			macro
		:Array<$itemType>;

		case _:
			Context.warning('Cannot resolve type $t', (macro null).pos);
			macro
		:Dynamic;
	};
}

function meta(m:String, ?params:Array<Expr>):MetadataEntry {
	return {name: ':$m', params: params, pos: (macro null).pos};
}

typedef FunctionDef = {
	final name:String;
	final method:Bool;
	final parameters:Array<ParamDef>;
	final return_type:String;
	final since:Int;
	@:optional final deprecated_since:Int;
}

abstract ParamDef(Array<String>) {
	public var type(get, never):String;

	function get_type():String
		return this[0];

	public var name(get, never):String;

	function get_name():String
		return this[1];
}
