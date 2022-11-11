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
local partial = require("luasnip.extras").partial
local ext_opts = {
  -- these ext_opts are applied when the node is active (e.g. it has been
  -- jumped into, and not out yet).
  -- this is the table actually passed to `nvim_buf_set_extmark`.
  active = {
    -- highlight the text inside the node red.
    hl_group = "GruvboxRed",
  },
}

local node_ops = { node_ext_ops = ext_opts }

--regTrig = trigger should be interpreted as a lua pattern
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
      [[ {} -> {}.map(({}) => {{ {} }})
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
  s(
    { trig = "fn", dscr = "Create a function easily", regTrig = false },
    fmt(
      [[
          let {} = ({}) => {}
      ]],
      {
        i(1),
        i(2),
        c(3, { i(0), t "{{ {} }}" }),
      }
    )
  ),
  s(
    { trig = "log", dscr = "Logs using our nice logger", regTrig = false },
    fmt(
      [[
    Log.{}(~call="{}", {})
      ]],
      {
        c(1, { t "error", t "warn" }, node_ops),
        partial(vim.fn.expand, "%:t:r"),
        i(0, "error"),
      }
    )
  ),
  s(
    { trig = "red", dscr = "reduce helper", regTrig = false },
    fmt(
      [[
      {} -> Array.reduce((acc,{}) => {{ 
        {} 
        acc;
      }})
      ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),
}
