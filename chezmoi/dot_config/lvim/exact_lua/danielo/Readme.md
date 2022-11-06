# Helper methods for Danielo

This is a simple library of helper methods to configure Neovim that I compiled for myself.
They are focused in correctness, ease of use, debuggability and safeness.


## Global usage
If you are me or really like this library, you may want to use it everywhere without having to require it.
To do so, just require the globals module of this library. This will add a global namespace called `D`
that you can then use to access the different methods this library provides. 
They should be all nicely named and documented, with typed function signatures:

```lua
-- your personal init.lua at the very top of the file
require "danielo.globals"; -- This creates the D namespace as global
local x = D.Peek "Example" -- Use the available functions.
```


## Dependencies
List here the dependencies we use
