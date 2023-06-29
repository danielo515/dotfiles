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

return {
  s({ trig = "sst", dscr = "static string", regTrig = false },
    fmt("&'static str{}", i(0))),
  s({ trig = "deder", dscr = "default derive" },
    fmt("#[derive(Debug, Clone{})]", i(0))) }
