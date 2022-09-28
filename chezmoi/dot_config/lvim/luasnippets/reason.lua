local ls = require "luasnip"
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
    { trig = "remod", dscr = "react component as module", regTrig = false },
    fmt(
      [[
module {} = {
  [@react.component]
  let make = ({}) => {
    <div>{0}</div>;
  };
};
    ]],
      {
        i(1),
        i(2),
      }
    )
  ),
}
