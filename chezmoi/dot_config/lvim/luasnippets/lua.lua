local extras = require "luasnip.extras"
local rep = extras.rep

return {
  s(
    { trig = "pc", dscr = "protected call" },
    fmt("local {}, {} = pcall({},{})", {
      i(1, "ok"),
      i(2, "val"),
      i(3),
      i(4),
    })
  ),
  s(
    { trig = "snip", dscr = "Create lua snippet" },
    fmt([[ s({{ trig = "{trig}", dscr = "{dscr}" }}, {} )]], { trig = i(1), dscr = i(2), i(0) })
  ),
  s(
    { trig = "fmt", dscr = "fmt snippet to use with snip" },
    fmt([[ fmt( "{}" , {{ {} = i({}) }}) )]], { i(1, "key"), rep(1), i(2, "value") })
  ),
}
