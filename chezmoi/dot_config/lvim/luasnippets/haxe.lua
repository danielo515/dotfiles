---@diagnostic disable: unused-local
local ls = require "luasnip"
local sn = ls.snippet_node
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

-- Yeah, they need to be separated
local rec_ls
rec_ls = function(pos, _nodes)
  assert(type(_nodes) == "table", "List of nodes must be a table")
  local nodes = vim.list_extend({ t "" }, _nodes:copy())
  return function()
    table.insert(nodes, d(pos, rec_ls(pos, _nodes:copy()), {}))
    vim.pretty_print(nodes)
    return sn(nil, {
      c(1, {
        -- important!! Having the sn(...) as the first choice will cause infinite recursion.
        t { "" },
        -- The same dynamicNode as in the snippet (also note: self reference).
        sn(nil, nodes),
      }),
    })
  end
end

local snippets = {

  s(
    { trig = "abs", dscr = "Abstract class", regTrig = false },

    fmt(
      [[
abstract {}<T>({}) {{
	@:from
	public static inline function from<T>({}):{}<T> {{
		return {};
	}}
}}

    ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
      }
    )
  ),

  s(
    { trig = "ext", dscr = "Extern class", regTrig = false },

    fmt(
      [[ extern class {} {{
           static function {}({}):{};
              {}
              }}
    ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
        -- d(5, rec_ls(2, fmt(" static function {}({}):{};", { i(1), i(2), i(3) })), {}),
      }
    )
  ),
}

return snippets
