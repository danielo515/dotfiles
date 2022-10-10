local ls = require "luasnip"
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.s
local i = ls.i
local extras = require "luasnip.extras"
local l = extras.lambda
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta
local t = ls.text_node

return {
  s(
    { trig = "switch", dscr = "switch expression", regTrig = false },
    fmt(
      [[
switch({}) {{
  | {} => {}
  }};
]],
      {
        i(1),
        c(2, { t "", t "Some()" }),
        i(0),
      }
    )
  ),
  s(
    { trig = "remod", dscr = "react component as module", regTrig = false },
    fmt(
      [[
module {} = {{
  [@react.component]
  let make = ({}) => {{
    <div>{}</div>;
  }};
}};
    ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),
}
