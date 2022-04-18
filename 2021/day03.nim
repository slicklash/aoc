import sequtils, strutils, tables

proc loHi(xs: seq[string]): (string, string)

proc part1(xs: seq[string]): int =
  let (e, g) = loHi(xs)
  result = g.parseBinInt * e.parseBinInt

proc part2(xs: seq[string]): int =
  var ls, hs = xs
  for i in 0 .. xs[0].high:
    let (lo, hi) = (loHi(ls)[0], loHi(hs)[1])
    if ls.len > 1: ls = ls.filterIt(it[i] == lo[i])
    if hs.len > 1: hs = hs.filterIt(it[i] == hi[i])
  result = ls[0].parseBinInt * hs[0].parseBinInt

proc loHi(xs: seq[string]): (string, string) =
  let n = xs[0].high
  var cx: seq[CountTable[char]]
  for _ in 0 .. n:
    cx.add(initCountTable[char]())
  for x in xs:
    for i, c in x:
      cx[i].inc(c)
  var lo, hi: string
  for i in 0 .. n:
    let (c0, c1) = (cx[i]['0'], cx[i]['1'])
    lo.add(if c1 < c0: "1" else: "0")
    hi.add(if c0 > c1: "0" else: "1")
  result = (lo, hi)

when isMainModule:
  let xs = lines("day03.txt").toSeq
  doAssert part1(xs) == 3882564
  doAssert part2(xs) == 3385170
