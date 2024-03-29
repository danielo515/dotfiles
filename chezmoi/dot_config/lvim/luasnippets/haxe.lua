---@diagnostic disable: unused-local
local ls = require "luasnip"
ls.setup_snip_env()
local sn = ls.snippet_node
local extras = require "luasnip.extras"
local s = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.i
local l = extras.lambda
local dl = extras.dynamic_lambda
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta
local t = ls.text_node

-- Yeah, they need to be separated
local rec_ls
rec_ls = function(pos, _nodes)
  assert(type(_nodes) == "table", "List of nodes must be a table")
  -- flat-copy nodes, otherwise we'd insert `d(...)` in every iteration.
  local nodes = { unpack(_nodes) }
  return function()
    table.insert(nodes, d(pos, rec_ls(pos, _nodes), {}))
    return sn(nil, {
      c(1, {
        -- important!! Having the sn(...) as the first choice will cause infinite recursion.
        t { "" },
        -- deep copy of nodes here.
        sn(nil, nodes):copy(),
      }),
    })
  end
end
local snippets = {

  s(
    { trig = "typedef", dscr = "a more convenient typedef", regTrig = false },
    fmt(
      [[ typedef {} = {{ 
        final {};
        {};
    }}]],
      { i(1), i(2), i(0) }
    )
  ),
  s({ trig = "unlua", dscr = "untyped lua block", regTrig = false }, fmt([[ untyped __lua__("{}");]], { i(0) })),
  s(
    { trig = "pustif", dscr = "static inline function", regTrig = false },
    fmt([[ public static inline function {}({}):{}<T> {{ {} }} ]], { i(1), i(2), i(3), i(0) })
  ),
  s(
    { trig = "pustef", dscr = "extern static function", regTrig = false },
    fmt([[ public static function {}({}):{}<T>;{} ]], { i(1), i(2), i(3), i(0) })
  ),
  s(
    { trig = "abs", dscr = "Abstract value", regTrig = false },

    fmt(
      [[
abstract {}<T>({}) {{
	@:from
	public static inline function from<T>({}):{}<T> {{
		return {};
	}}
}}

    ]],
      { i(1), i(2), i(3), i(4), i(0) }
    )
  ),

  s(
    { trig = "extl", dscr = "lua extern class", regTrig = false },

    fmt(
      [[ 
      @:luaRequire('{}')
      extern class {} {{
       static function {}({}):{};
               {}
      }}
    ]],
      {
        i(1),
        dl(2, l._1:sub(1, 1):upper() .. l._1:sub(2), 1),
        i(3, "setup"),
        i(4),
        i(5, "Void"),
        i(0),
      }
    )
  ),
  s(
    { trig = "ext", dscr = "Extern class", regTrig = false },

    fmt(
      [[ extern class {} {{
               {}
               {}
            }}
    ]],
      {
        i(1),
        d(2, rec_ls(2, fmt(" static function {}({}):{};", { i(1), i(2), i(3) })), {}),
        i(3),
      }
    )
  ),
}

return snippets
