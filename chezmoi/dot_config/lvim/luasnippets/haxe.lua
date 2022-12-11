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
rec_ls = function(_nodes)
  local nodes = vim.list_extend({ t "" }, _nodes)
  nodes:insert(d(#nodes, rec_ls, {}))
  return sn(nil, {
    c(1, {
      -- important!! Having the sn(...) as the first choice will cause infinite recursion.
      t { "" },
      -- The same dynamicNode as in the snippet (also note: self reference).
      sn(nil, nodes),
    }),
  })
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
      [[
extern class {} {{
{}
}}

    ]],
      {
        i(1),
        d(rec_ls(fmt(" static function {}({}):{}; ", { i(1), i(2), i(0) }))),
      }
    )
  ),
}

return snippets
