
This is one of the simplest examples. A call, with several options as a table, some of them being nested. 


```lua
local Job = require "plenary.job"

local path = "defined somewhere else"

-- ....
  local res, code = Job:new({ 
      command = "chezmoi", 
      args = { "add", "-f", path } 
      }):sync()
```

Having the externs already defined to be 1:1 the lua api, I can do this:

```haxe
var args = Table.create(null, {
	command: "chezmoi",
	args: Table.create(["add", "-f", path])
});
Job.new(args).sync();
```

That, indeed, produces very similar lua:

```lua
  __plenary__Job_Job_Fields_.path = "/some/path";
  __plenary__Job_Job_Fields_.args = ({command = "chezmoi", args = ({"add","-f",__plenary__Job_Job_Fields_.path})});
```

But that is not acceptable, because they are untyped, and even if I wanted to type them using
the `Table<A,B>` types, they are not possible to properly type either, so the extern has to be 
typed with Dynamic which is exactly what I'm trying to avoid.

I started defining abstract classes for all the possible argument each function takes, type the
function params, and call the create table methods there using the provided params. 
But that got tedious pretty fast, with a lot of repetition.

Then, someone in stack-overflow suggested to use a macro that converts the arguments of the
abstract class into calls to table.create with all the arguments it has. 
That reduced at least the reptetition of the parameter names, but it only works well in shallow
tables, as soon as you want to define something nested it falls apart.

On top of all that, `Table.create` does not work with variables, it only accepts literal values,
so if you want to create some indirect method call, that will not work/not allowed:

Imagine I want to wrap `Job.new` into a function that always calls it with all the same options
but allos a configurable list of arguments:

```haxe

abstract JobOpts(Table<String, Dynamic>) {
	public inline function new(command:String, args:Array<String>, ?cwd:String) {
		final args = Table.fromArray(args);
		this = Table.create(null, {
			command: command,
			arguments: args,
			cwd: cwd,
		});
	}
}

static public function chezmoi(args:Array<String>) {
    final job = Job.make(new JobOpts("chezmoi", args));
    return job.start();
}
```

That only works because `JobOpts` calls `Table.fromArray` on the args argument, which has some
runtime overhead (even JobOpts being inlined, it still creates an array just to immediatelly 
turn it into a table):


```lua
  local ret = ({});
  local _g = 0;
  local _g1 = args.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local idx = _g - 1;
    ret[idx + 1] = args[idx];
  end;
  local args = ret;
  local this1 = ({command = "chezmoi", arguments = args, cwd = cwd});
  local args = this1;
  local job = __plenary_Job:new(args);
  do return job:start() end;
```

As you can see, a lot of boilerplate that, I don't have to write, but ti is also a lot of redundant
and unnecessary code. Also I am not a fan of having to call new with a constructor just to pass some
typed arguments. What I want, ideally is to do it like this:

```haxe

typedef Job_opts = {
    final command:String;
    final arguments:Array<String>;
}
job.make({command: 'chezmoi', args: ['add', '-f']});
```

Of course that is not good becuase it creates a lot of extra fields, and
a lot of vim methods are picky about extra fields. Not to mention the unecessary
metatable assignation:


```lua

  job:new(_hx_o({__fields__={command=true,args=true},command="chezmoi",args=_hx_tab_array({[0]="add", "-f"}, 2)}));
```

So I was wondering if there could be a more advanced macro, that is able to track the arguments up to the function call site and embed the `table.create` calls there. Because normal macros are specific to the arguments of the abstract class. 
So as soon as I want to create a higher abstraction, the problem I  mentioned earlier applies again.
