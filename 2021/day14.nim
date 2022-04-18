import sequtils, strutils, tables

type
  Rules = Table[string, char]

proc count(s: string, rules: Rules, n: int): int =
  var cx = s.toCountTable
  var cp = zip(s, s[1..^1]).toCountTable
  for _ in 1 .. n:
    var prev = cp
    for p, c in prev:
      let (a, b) = p
      let r = rules[a & b]
      let (ar, rb) = ((a, r), (r, b))
      cx.inc(r, c)
      cp.inc(ar, c)
      cp.inc(rb, c)
      cp[p] = cp[p] - c
  result = cx.largest.val - cx.smallest.val

proc part1(s: string, rules: Rules, n: int): int = count(s, rules, 10)
proc part2(s: string, rules: Rules, n: int): int = count(s, rules, 40)

when isMainModule:
  let z = readFile("day14.txt").split("\n\n")
  let s = z[0]
  let rules = z[1].strip.split('\n')
                  .mapIt(it.split(" -> "))
                  .mapIt((it[0], it[1][0])).toTable

  doAssert part1(s, rules, 10) == 2447
  doAssert part2(s, rules, 40) == 3018019237563
