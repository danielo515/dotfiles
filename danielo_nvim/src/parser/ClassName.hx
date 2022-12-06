package parser;

typedef Tokens = Array<String>;

enum State {
	Initial;
	Finished(tokens:Tokens);
	Running(buffer:String, position:Int);
}

class Parser {
	private final string:String;
	private var position:State;
	private var tokens:Array<String>;

	public function new(str:String) {
		this.string = str;
		this.position = Initial;
		this.tokens = [];
	}

	public function seek(checker) {
		var nextChar = switch (this.position) {
			case Initial: string.charAt(0);
			case Finished(_): string.substr(-1, 1);
			case Running(_, pos): string.charAt(pos);
		}
		var checkResult = checker(nextChar);
		switch ([checkResult, this.position]) {
			case [true, Running(buffer, pos)]:
				Running(buffer + nextChar, pos);
			case [false, Running(buffer, pos)]:
				Running(buffer, pos + 1);
			case [true, Initial]:
				Running(nextChar, 1);
			case [false, Initial]:
				Running("", 1);
			case [_, Finished(_)]:
				Finished;
		}
	}

	public function advance() {
		this.position = switch (this.position) {
			case Initial: Running("", 1);
			case Finished(tokens): Finished(tokens);
			case Running(buffer, pos):
				if (pos + 1 >= this.string.length) Finished([]) else Running(buffer, pos + 1);
		}
	}

	public function tokenize() {}
}

class ClassName {
	private final parser:Parser;

	public function new(str:String) {
		this.parser = new Parser(str);
	}

	private function parse() {
		return this.parser.tokenize();
	}
}
