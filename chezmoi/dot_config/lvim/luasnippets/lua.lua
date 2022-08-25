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
}
