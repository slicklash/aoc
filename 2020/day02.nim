import re, sequtils, strutils

type Rule = (int, int, char, string)

proc parse(line: string): Rule =
  var m: array[4, string]
  discard line.match(re"(\d+)-(\d+) (\w): (\w+)", m)
  result = (m[0].parseInt, m[1].parseInt, m[2][0], m[3])

proc part1(rules: seq[Rule]): int =
  for rule in rules:
    let (lo, hi, c, str) = rule
    let count = str.count(c)
    if count >= lo and count <= hi:
      inc(result)

proc part2(rules: seq[Rule]): int =
  for rule in rules:
    let (lo, hi, c, str) = rule
    if str[lo - 1] == c xor str[hi - 1] == c:
      inc(result)

when isMainModule:
  let rules = toSeq(lines("day02.txt")).map(parse)
  doAssert part1(rules) == 410
  doAssert part2(rules) == 694
