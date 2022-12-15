import sys.io.File;
import org.msgpack.MsgPack;

using Lambda;

typedef ApiData = {
	final functions:Array<{name:String, return_type:String, deprecated_since:Null<Int>}>;
}

class ReadNvimApi {
	final rawData:ApiData;

	public function new(path) {
		final bytes = File.getBytes(path);
		rawData = MsgPack.decode(bytes);
	}

	static function main() {
		final vimApi = new ReadNvimApi('./nvim-api.msgpack');
		final functions = switch (vimApi.rawData.functions) {
			case null:
				throw "Missing functions key in the API data";
			case functions:
				functions;
		};
		functions.filter(x -> x.deprecated_since == null).iter(Sys.println);
	}
}
