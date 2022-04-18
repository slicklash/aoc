import math, sequtils, strutils

proc part1(xs: seq[int]): int =
  for i in 1 .. xs.high:
    if xs[i] > xs[i-1]:
      inc result

proc part2(xs: seq[int]): int =
  var prev = sum(xs[0 .. 2])
  for i in 1 .. xs.high - 2:
    let s = sum(xs[i .. i + 2])
    if s > prev:
      inc result
    prev = s

when isMainModule:
  let xs = lines("day01.txt").toSeq.map(parseInt)
  doAssert part1(xs) == 1184
  doAssert part2(xs) == 1158
