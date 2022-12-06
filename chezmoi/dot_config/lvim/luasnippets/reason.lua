local ls = require "luasnip"

local s = ls.s
local i = ls.i
local extras = require "luasnip.extras"
local fmt = require("luasnip.extras.fmt").fmt
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

local function switch_match(index)
  return c(index, {
    i(nil, ""),
    sn(
      nil,
      fmt(
        [[ 
      | Some({}) => {} 
      | None => {}
    ]],
        { i(1, "_"), i(3), i(0) }
      )
    ),
    sn(nil, { t "Ok(", i(1, "_"), t ")" }),
    sn(nil, { t "Error(", i(1, "_"), t ")" }),
  })
end

--regTrig = trigger should be interpreted as a lua pattern
local normal_ones = {
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
        switch_match(2),
        i(0),
      }
    )
  ),
  s(
    { trig = "swi2", dscr = "switch with tuples", regTrig = false },
    fmt(
      [[
        switch(({},{})) {{
          | (Some({}),Some({})) => {}
          | None => ()
          }};
        ]],
      {
        i(1),
        i(2),
        rep(1),
        rep(2),
        i(0),
      }
    )
  ),
  s(
    { trig = "sm", dscr = "switch match", regTrig = false },
    fmt([[ | {} => {} ]], {
      switch_match(1),
      i(0),
    })
  ),
  s(
    { trig = "recostate", dscr = "use recoil state", regTrig = false },
    fmt([[  let ({}, set{}) = Recoil.useRecoilState({}); ]], {
      i(1),
      i(2),
      i(0),
    })
  ),
  s(
    { trig = "recoatom", dscr = "use recoil atom", regTrig = false },
    fmt(
      [[ 
    let {}: Recoil.readWrite({}) =
          Recoil.atom({{ key: "{}.{}", default: {} }});
]],
      {
        i(1),
        i(2, "option(string)"),
        partial(vim.fn.expand, "%:t:r"),
        rep(1),
        i(3, "None"),
      }
    )
  ),
  s(
    { trig = "remod", dscr = "react component as module", regTrig = false },
    fmt(
      [[ module {} = {{ 
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
    { trig = "restr", dscr = "react string", regTrig = false },
    fmt([[ {} -> React.string{} ]], {
      i(1),
      i(0),
    })
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
        c(2, { t "Js.Array2", t "Array", t "Option", t "List" }),
        i(3),
        i(0),
      }
    )
  ),
  s(
    { trig = "jslog", dscr = "Javascript easier log", regTrig = false },
    fmt(
      [[ //TODO: Remove this debug line
          Js.log2("{}", {}{});
      ]],
      {
        rep(1),
        i(1),
        i(0),
      }
    )
  ),
  s(
    { trig = "fn", dscr = "Create a function easily", regTrig = false },
    fmt([[ let {} = ({}) => {} ]], {
      i(1),
      i(2),
      c(3, { i(0), { t "{ ", t "}" } }),
    })
  ),
  s(
    { trig = "log", dscr = "Logs using our nice logger", regTrig = false },
    fmt(
      [[
    Log.{}(~call="{}", ~error={}, {})
      ]],
      {
        c(1, { t "error", t "warn", t "debug" }, node_ops),
        partial(vim.fn.expand, "%:t:r"),
        i(2),
        i(0),
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
  s(
    { trig = "useff", dscr = "Use effect", regTrig = false },
    fmt(
      [[
          React.useEffect1(
            () => {{
              {}
              Some(() => setRef(_ => Js.Nullable.null));
            }},
            [|{}|],
          );
      ]],
      { i(1), i(0) }
    )
  ),
}

local auto_trigger = {
  s(
    { trig = "prr", dscr = "Promise result return", regTrig = false },
    fmt([[ -> PromiseResult.return {} ]], {
      i(0),
    })
  ),
  s(
    { trig = "logw", dscr = "Promise result return", regTrig = false },
    fmt([[ Log.warning(~call="{}{}", {})]], {
      partial(vim.fn.expand, "%:t:r"),
      i(1),
      i(0),
    })
  ),
}

return normal_ones, auto_trigger
