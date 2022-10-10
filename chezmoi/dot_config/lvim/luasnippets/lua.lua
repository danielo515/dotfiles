local ls = require "luasnip"
local extras = require "luasnip.extras"
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.i
local l = extras.lambda
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta
local t = ls.text_node

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
  s({ trig = "vpp", dscr = "Vim pretty print" }, { t "vim.pretty_print(", i(1), t ")" }),
  s(
    { trig = "snip", dscr = "Create lua snippet" },
    fmt(
      [[ s({{ trig = "{trig}", dscr = "{dscr}", {regTrig} }}, {} )]],
      { trig = i(1), dscr = i(2, "description"), regTrig = c(3, { t "regTrig=false", t "regTrig=true" }), i(0) }
    )
  ),
  s(
    { trig = "fmt", dscr = "fmt snippet to use with snip" },
    fmta(
      [[ 
    fmt( "{<>}" , { 
      <> = i(<>,"default") 
      })
    ]],
      { i(1, "key"), rep(1), i(2, "1") }
    )
  ),
  s({ trig = "(%w+)tmap", dscr = "Wrap current table with a map method", regTrig = true }, {
    t "vim.tbl_map(",
    l(l.CAPTURE1, {}),
    i(0),
    t ")",
  }),
  s(
    { trig = "reqm", dscr = "Require a module but extract a method" },
    fmt("local {} = require'{}'.{}", {
      i(1, "method"),
      c(2, { t "", sn(nil, dl(nil, "user.util." .. l._1, ai[1])) }),
      rep(1),
    })
  ),
},
  {
    -- Auto snippets, note the comma above

    s(
      { trig = "(%w+)__", regTrig = true, dscr = "automatically repeat what we have assigned to itself" },
      { l(l.CAPTURE1), t " = ", l(l.CAPTURE1, {}) }
    ),
  }
