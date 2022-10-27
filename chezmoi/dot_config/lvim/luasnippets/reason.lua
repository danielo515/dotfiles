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
  s(
    { trig = "rstr", dscr = "react string", regTrig = false },
    fmt(
      [[
      "{}" -> React.string
    ]],
      {
        i(0),
      }
    )
  ),
  s(
    { trig = "usestate", dscr = "use state reac", regTrig = false },
    fmt(
      [[ 
  let ({}, {}) = React.useState(_ => {});
    ]],
      {
        i(1, "state"),
        i(2, "setState"),
        i(0),
      }
    )
  ),
  s(
    { trig = "uef1", dscr = "react use effect 1", regTrig = false },
    fmt(
      [[ 
  
  React.useEffect1(()=>{{

    {}

    None;

    }},[|{}|]);

    ]],
      {
        i(0),
        i(1),
      }
    )
  ),
  s(
    { trig = "map", dscr = "Any map", regTrig = false },
    fmt(
      [[ {} -> {}.map(({}) => {{ {} }});
    ]],
      {
        i(1),
        c(2, { t "Array", t "Option", t "List" }),
        i(3),
        i(0),
      }
    )
  ),
  s(
    { trig = "jslog", dscr = "Javascript easier log", regTrig = false },
    fmt(
      [[
        //TODO: Remove this debug line
          Js.log2("{}", {});
      ]],
      {
        rep(1),
        i(1),
      }
    )
  ),
}
